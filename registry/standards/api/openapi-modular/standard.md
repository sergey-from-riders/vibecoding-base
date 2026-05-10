# 21. OpenAPI Modular Contract Standard (Strict)

Этот стандарт обязателен для всех endpoint-ов API.

## 0) Normative baseline

1. OpenAPI Specification pinned for this starter: `3.2.0`
2. HTTP Semantics (`RFC 9110`): https://www.rfc-editor.org/rfc/rfc9110
3. Problem Details (`RFC 9457`): https://www.rfc-editor.org/rfc/rfc9457
4. HTTP Method Registry (IANA): https://www.iana.org/assignments/http-methods/http-methods.xhtml
5. OpenAPI `Path Item`/Operations (same path + different methods): https://spec.openapis.org/oas/v3.2.0.html#path-item-object

## 1) Version and structure (fixed)

1. `OPENAPI_VERSION = 3.2.0`
2. `ROOT_FILE = packages/contracts/openapi/openapi.root.yaml`
3. `MODULE_FILES = 1` файл на модуль (`auth.yaml`, `company.yaml`, `docs.yaml`)
4. `INVENTORY_FILE = packages/contracts/openapi/endpoints.inventory.tsv`
5. `DIST_DIR = packages/contracts/openapi/dist`

## 2) Endpoint coverage rules

1. Endpoint в коде без OpenAPI контракта: `0`
2. Endpoint в OpenAPI без inventory записи: `0`
3. Endpoint в inventory без OpenAPI записи: `0`
4. `operationId` отсутствует: `0`
5. `summary` отсутствует: `0`
6. `2xx response` отсутствует: `0`
7. `4xx response` отсутствует: `0`
8. `tags` отсутствует: `0`

## 3) Examples and testing rules

1. `REQUEST_EXAMPLES_MIN = 1` для операций с body
2. `RESPONSE_EXAMPLES_MIN = 1` для каждой операции
3. `CODE_SAMPLES_MIN = 1` (`x-codeSamples`, curl минимум)
4. Testing hints в docs catalog для endpoint: `>= 1`

## 4) Mandatory docs endpoints

1. `GET /api/v1/docs/openapi.json`
2. `GET /api/v1/docs/openapi.yaml`
3. `GET /api/v1/docs/endpoints`
4. `GET /api/v1/docs/testing/postman`

`/api/v1/docs/endpoints` обязан возвращать список всех endpoint-ов с:
1. method
2. path
3. summary
4. tag
5. operation_id
6. curl_examples
7. test_hints

## 5) Consistent response contract (mandatory)

Плоскими и стабильными должны быть служебные части контракта (headers + error shape), а бизнес-payload следует OpenAPI schema.

1. В success-ответе не вводим универсальные технические обертки `data/meta/errors` по умолчанию.
2. В error-ответе нет вложенной структуры `error.details.items...`.
3. Глобального лимита на глубину `payload` нет; глубина определяется контрактом OpenAPI schema.
4. Для `docs/export/catalog` endpoint-ов разрешен большой и разветвленный JSON (включая OpenAPI bundle).
5. Если для доменного сценария нужна структурная обертка (например, пагинация), она описывается явно в OpenAPI schema endpoint-а.
6. Top-level обязательные ключи для error:
- `status`
- `title`
- `detail`
- `action`
- `validate`
- `request_id`

## 6) Mandatory response headers

Каждый API ответ обязан включать:

1. `X-Request-Id` (уникальный id запроса)
2. `X-App-Result`:
- `ok`
- `fix_required`
- `error`
3. `Content-Language` (`ru-RU`)

Матрица `X-App-Result` по статусам:
1. `2xx` -> `ok`
2. `4xx` с исправляемым запросом -> `fix_required`
3. `5xx`/инфраструктурные ошибки -> `error`

Условные заголовки (только при необходимости исправления/проверки):
1. `X-App-Action` (короткая инструкция действия)
2. `X-App-Validate` (поля для проверки, csv)

Если проверка не пройдена:
1. `X-App-Result = fix_required`
2. `X-App-Action` обязателен
3. `X-App-Validate` обязателен

Если серверная ошибка (`X-App-Result = error`):
1. `X-App-Action` опционален
2. `X-App-Validate` обычно пустой/отсутствует

## 7) Error language policy (mandatory tone)

Запрещенные формулировки:
1. “неверно”
2. “неправильно”
3. “ошибка пользователя”

Обязательный стиль:
1. “Исправьте ...”
2. “Проверьте ...”
3. “Укажите ...”
4. “Добавьте ...”
5. “Повторите ...”
6. “Validate ...”

Примеры:
1. `detail = "Исправьте email и повторите запрос."`
2. `action = "Проверьте validate name,email"`
3. `validate = "name,email"`

## 8) Build and validation scripts

1. `tools/scripts/build_openapi_bundle.sh`
2. `tools/scripts/check_openapi_coverage.sh`

Критерии:
1. Допустимое число нарушений: `0`
2. Код возврата при нарушении: `1`
3. Coverage script проверяет inventory coverage, request examples, response examples, `x-codeSamples` и обязательные response headers.

## 9) CI gate

Обязательный этап:
1. `verify-contracts`
2. Запускает:
- `build_openapi_bundle.sh`
- `check_openapi_coverage.sh`
3. При fail deploy блокируется.

## 10) Feature sync rule

Команда “актуализируй фичу” обязана:
1. найти все измененные endpoint-ы;
2. добавить/обновить их в module file;
3. добавить/обновить примеры;
4. добавить/обновить inventory;
5. прогнать contract scripts;
6. обновить docs endpoint catalog.

Невыполнение любого пункта: merge запрещен.

## 11) HTTP method policy (strict matrix)

### 11.1 Allowed methods in Go Next Postgres Framework API
1. `GET` (read)
2. `POST` (commands/create/mutation)
3. `PUT` (full replace, only if explicitly needed)
4. `PATCH` (partial update, only if explicitly needed)
5. `DELETE` (resource/session revoke/delete)
6. `HEAD` (optional mirror of GET metadata)
7. `OPTIONS` (CORS/capability negotiation)

### 11.2 Disallowed methods for business API
1. `TRACE = 0`
2. `CONNECT = 0`

### 11.3 Decision table
1. `GET`: read-only, no state mutation, no business side effects.
2. `POST`: non-idempotent command, create, auth flow steps, switch/revoke/refresh/exchange.
3. `PUT`: idempotent full replacement of known resource.
4. `PATCH`: idempotent-or-not partial update (must document semantics in summary/description).
5. `DELETE`: revoke/remove resource state.
6. `HEAD`: same headers as GET, no body.
7. `OPTIONS`: allowed methods/CORS negotiation.

### 11.4 Body rules
1. `GET` request body: `0`
2. `HEAD` request body: `0`
3. `OPTIONS` request body: `0`
4. `POST|PUT|PATCH` request body examples minimum: `1`

### 11.5 Same path + different methods
Разрешено и обязательно описывается явно в OpenAPI, если semantics разные.

Пример:
1. `GET /api/v1/companies` — получить список.
2. `POST /api/v1/companies` — создать компанию.

Ограничения:
1. `PATH_METHOD_CONFLICT_WITHOUT_DISTINCT_OPERATIONID = 0`
2. `PATH_METHOD_CONFLICT_WITHOUT_DISTINCT_SUMMARY = 0`
3. `PATH_METHOD_CONFLICT_WITHOUT_DISTINCT_EXAMPLES = 0`
4. `PATH_METHOD_CONFLICT_WITHOUT_DISTINCT_RESPONSES = 0`
5. `PATH_METHOD_CONFLICT_WITHOUT_METHOD_SPECIFIC_TEST_HINTS = 0`

## 12) Backward compatibility and deprecation

1. Breaking changes в `v1` без migration/deprecation плана: `0`.
2. Любое удаление/переименование поля или endpoint-а сначала проходит через deprecation этап.
3. Минимальный deprecation window: `90` дней (prod).
4. Для deprecated endpoint-а обязательны:
- `deprecated: true` в OpenAPI operation;
- `summary/description` с датой удаления (`YYYY-MM-DD`);
- migration note в документации модуля.
5. Добавление новых полей допускается только как backward-compatible (опциональные либо с безопасным default-поведением).
