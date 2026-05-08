# 22. Observability Standard (Mandatory)

Этот документ фиксирует обязательный стандарт observability для Python React Postgres Framework.

## 1) Scope

Стандарт обязателен для:
1. `apps/api` (все handler/service операции)
2. `apps/web` (client + server adapters)
3. `apps/mobile/android` (WebView shell, deep link, bridge)
4. `apps/desktop/qt` (native adapter)

## 2) Three-signal model (required)

1. `traces` — причинно-следственная цепочка запроса
2. `logs` — структурированные события
3. `metrics` — агрегаты для SLA/SLO и алертов

Наличие только логов без trace/metrics считается неполным внедрением.

## 3) Request correlation contract

Обязательная связка идентификаторов:
1. `request_id` — всегда в HTTP header `X-Request-Id`
2. `trace_id` — всегда в span context
3. `span_id` — для конкретного span

Правило:
1. Если `X-Request-Id` пришел извне, используем его.
2. Если не пришел, генерируем и возвращаем в ответе.
3. `request_id` обязан быть в:
- response headers;
- structured logs;
- span attributes (`rp.request_id`).

## 4) Structured logging format

Формат логов API: JSON lines.

Обязательные ключи каждого server log record:
1. `timestamp`
2. `level`
3. `message`
4. `service`
5. `env`
6. `module`
7. `operation`
8. `request_id`
9. `trace_id`
10. `span_id`
11. `http_method`
12. `http_route`
13. `http_status`
14. `latency_ms`
15. `result` (`ok|fix_required|error`)

Условные ключи (если есть контекст):
1. `user_id`
2. `company_id`
3. `session_id`
4. `error_code`
5. `validate`

Запрещено логировать:
1. plaintext password/token/code_verifier
2. access/refresh tokens
3. Telegram raw init data целиком
4. OAuth authorization codes
5. любые секреты из env

## 5) Tracing standard

## 5.1 Span naming

Формат server span:
`HTTP <METHOD> <ROUTE_TEMPLATE>`

Пример:
`HTTP POST /api/v1/auth/login`

## 5.2 Required span attributes

1. `http.request.method`
2. `url.path`
3. `http.response.status_code`
4. `client.address` (если доступно)
5. `user_agent.original` (если доступно)
6. `enduser.id` (если authenticated)
7. `rp.company_id` (если есть tenant context)
8. `rp.session_id` (если есть session)
9. `rp.request_id`
10. `rp.module`
11. `rp.operation`

## 5.3 Status mapping

1. `2xx` -> span status `Ok`
2. `4xx` -> span status `Ok` (если бизнес-валидация), но с event `validation_required`
3. `5xx` -> span status `Error`

## 6) Metrics baseline (mandatory)

Минимальный набор API-метрик:
1. `http_server_requests_total{method,route,status,result}`
2. `http_server_request_duration_ms{method,route}` (histogram)
3. `auth_attempts_total{provider,result}`
4. `auth_session_revocations_total{mode}` (`one|others|mass`)
5. `active_sessions_gauge`

Latency SLO baseline:
1. `P95 < 300ms` для read endpoints
2. `P95 < 500ms` для auth/session mutation endpoints

## 7) Mandatory handler observability checklist

Каждый HTTP handler обязан:
1. получить/создать `request_id`
2. стартовать span с route template
3. передать `context.Context` ниже по слоям
4. добавить domain attributes (`module`, `operation`, `user_id/company_id` при наличии)
5. записать structured log на завершении
6. записать duration metric
7. выставить `X-Request-Id` в ответ

Если любой пункт не выполнен, handler считается non-compliant.

## 8) Error observability rules

1. Для `fix_required` записываем validation event:
- `event = validation_required`
- `validate = <csv>`
2. Для `error` записываем:
- `event = internal_error`
- `error_code`
- stacktrace только в internal sink

Пользовательский ответ не должен содержать stacktrace.

## 9) Sampling and retention

1. Error traces (`5xx`) sampling: `100%`
2. Validation traces (`4xx/fix_required`) sampling: `25%`
3. Success traces sampling: `10%`

Retention baseline:
1. logs: `30` дней
2. traces: `14` дней
3. high-cardinality debug traces: `3` дня

## 10) Platform-specific notes

### Web
1. Web-Vitals (`CLS`, `INP`, `LCP`) обязательны в telemetry pipeline.
2. `request_id` передается в API calls и сохраняется в client diagnostics.

### Android WebView shell
1. Логируются события `webview_load_start`, `webview_load_end`, `deep_link_open`.
2. Bridge вызовы логируются без payload с PII.

### Qt desktop
1. Network request logs должны содержать `request_id` и `trace_id` (если прокинуты).
2. Crash/exception events идут в отдельный error sink.

## 11) Definition of Done for observability

Фича не принимается без:
1. trace coverage для новых endpoint-ов
2. structured logs с `request_id` на success/error paths
3. metrics для latency + request count
4. update docs при изменении telemetry contract
