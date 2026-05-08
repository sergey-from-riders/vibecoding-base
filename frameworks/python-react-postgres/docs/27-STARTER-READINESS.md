# 27. Starter Readiness and Standards Audit

Этот документ фиксирует статус проекта как заготовки, а не как готового продукта.

## 1) Итоговая оценка подхода

Подход правильный для foundation-репозитория: сначала зафиксированы границы продукта, API-контракт, БД, quality gates, agent rules и deploy-модель. Это снижает риск расползания фич до того, как готова базовая auth/company платформа.

Ключевой риск был в другом: часть документов была написана языком "finalized", хотя runtime-код API/Web/Qt/Android еще не создан. Для starter это опасно, потому что агент может принять архитектурные решения за уже реализованные гарантии. Поэтому статус теперь трактуется так:

1. `decision-ready` - решение принято и может использоваться при реализации.
2. `template-ready` - есть файлы заготовки, контракты, миграции или скрипты.
3. `implementation-pending` - runtime-код еще должен быть создан вертикальными срезами.
4. `enforced` - есть локальная/CI-проверка, которая ловит нарушение.

## 2) Что исправлено в starter baseline

1. Добавлен root `package.json` со starter-командами.
2. Добавлены проверки:
   - `tools/scripts/check_db_contract.sh`
   - `tools/scripts/check_starter_integrity.sh`
3. DB-модель приведена к auth/session стандарту:
   - `auth_identities`
   - `device_credentials`
   - `session_token_hash`
   - `refresh_token_hash`
   - `client_type`
   - `auth_identity_versions`
   - `device_credential_versions`
4. OpenAPI coverage check ужесточен:
   - request examples для body endpoints;
   - response examples для content responses;
   - `x-codeSamples` для каждого endpoint;
   - обязательные response headers.
5. OpenAPI auth/company/docs endpoints дополнены headers и curl samples.

## 3) Оценка стандартов

| Standard | Статус | Оценка | Что важно дальше |
| --- | --- | --- | --- |
| `07-DB-NAMING-CONVENTIONS` | enforced | Сильный, конкретный, хорошо подходит для агентов. | Поддерживать `check_db_contract.sh` и добавить SQL-level policy check после появления миграционного runner. |
| `08-UI-CROSS-PLATFORM-RULES` | decision-ready | Правильная token-first рамка, без попытки pixel-copy. | Реализовать token transforms для web/Qt/Android. |
| `09-PLATFORM-UI-STACKS` | decision-ready | Разделяет общий UX и платформенные primitives. | Зафиксировать реальные starter-компоненты web UI перед первой фичей. |
| `10-DESIGN-TOKENS-BUILD-PIPELINE` | template-ready | Источник токенов есть, pipeline пока описательный. | Добавить генерацию CSS/Qt/Android theme artifacts. |
| `11-REALISM-AND-EXECUTION-PLAN` | decision-ready | Практичный phased подход; Android WebView-first снижает объем. | Не начинать Qt/Android до вертикального web+api auth slice. |
| `12-ENV-REPO-DEPLOY` | template-ready | Порты, env и image-based deploy описаны ясно. | Добавить реальные Dockerfile только вместе с runtime-кодом. |
| `13-DEPLOYMENT-MODEL-OPTIONS` | decision-ready | Docker Compose + Nginx уместны для текущей стадии. | Kubernetes не вводить до реальной операционной необходимости. |
| `14-COMMIT-STANDARDS-2026` | decision-ready | Хороший стандарт истории изменений. | Добавить commitlint/husky только если команда реально будет этим пользоваться. |
| `15-DATA-VERSIONING-AND-DIFF` | template-ready | Full snapshot версионность хорошо подходит для аудита. | Проверить нагрузку триггеров на реальных сценариях до расширения домена. |
| `16-UNIFIED-AUTH-SESSION-ARCHITECTURE` | template-ready | Сильная модель identity/session/device restore. | Реализовать PKCE/state/device rotation тестами до UI polish. |
| `17-TESTING-TDD-QUALITY-GATES` | decision-ready | Правильная планка, но тяжелая для пустого starter. | Развести smoke для template и full gates для runtime-кода. |
| `18-GO-BACKEND-ENGINEERING-STANDARD` | template-ready | Хорошая декомпозиция и числовые лимиты. | Добавить настоящий Python package skeleton перед первой backend-фичей. |
| `19-NEXT-NODE-FRONTEND-STANDARD` | template-ready | Полезная compact UI дисциплина, но очень строгая. | Следить, чтобы правила не блокировали доступность и читаемость. |
| `20-CPP-QT-MEMORY-SAFETY-STANDARD` | decision-ready | Сильный стандарт безопасности C++/Qt. | Не применять до появления Qt runtime; затем добавить CMake presets и clang-tidy config. |
| `21-OPENAPI-MODULAR-CONTRACT-STANDARD` | enforced | После правок стал ближе к собственным требованиям. | Поддерживать inventory, examples, headers и code samples как merge gate. |
| `22-OBSERVABILITY-STANDARD` | decision-ready | Нужный стандарт для auth/security. | Реализовать request_id middleware и trace/log/metric helpers в первом API slice. |
| `23-QUICK-START-5-MIN` | template-ready | Хороший first-run сценарий для env/db/contracts. | Не обещать запуск API/Web до появления runtime-кода. |
| `24-ANDROID-ENGINEERING-STANDARD` | decision-ready | WebView-first выбран прагматично. | Не дублировать бизнес-логику в Kotlin. |
| `25-MCP-AGENTS-OPERATIONS-STANDARD` | template-ready | Полезен для управляемой agent work. | Для крупных задач вести task log и не обходить human checkpoints. |
| `26-SECURITY-INCIDENT-RUNBOOK` | decision-ready | Достаточный runbook для auth/session инцидентов. | После реализации auth добавить реальные SQL/scripts для emergency revoke. |

## 4) Starter acceptance baseline

Для заготовки достаточно, чтобы проходили:

```bash
pnpm run verify:offline
pnpm run verify:contracts
```

`verify:offline` не требует скачивания npm-пакетов и проверяет локальную структуру, DB contract и лимиты пустых app-каталогов.

`verify:contracts` требует Redocly/OpenAPI tooling и собирает контрактные artifacts. В CI он обязателен; локально может потребовать `pnpm install`.

## 5) Следующий правильный порядок работ

1. Bootstrap API: `go.mod`, router, request_id/problem middleware, docs endpoints.
2. Bootstrap DB runner и integration-test окружение.
3. Auth vertical slice: register/login/me/refresh/logout.
4. Session management: list/revoke/revoke-others.
5. Company context: list/create/switch.
6. Web auth UI поверх уже зеленого backend contract.
7. Только после этого Qt и Android shells.
