# AGENTS: Go Next Postgres Framework (Vibe Coding 2026)

## Template Boundary
В чистом starter baseline уже описаны только:
- архитектурный каркас;
- Auth;
- Switch Active Company.

Новые продуктовые домены добавляются только после явного решения в `docs/adr` и синхронизации contract/test/docs в том же изменении.

## Starter status
Этот репозиторий является foundation-заготовкой. Перед крупной работой агент должен прочитать:
- `docs/27-STARTER-READINESS.md`

Нельзя трактовать `decision-ready` документы как уже реализованный runtime-код.

## Delivery style (agentic)
Каждая задача проходит цикл:
1. `spec` (контракт/сценарий)
2. `contracts` (OpenAPI / schema)
3. `tests-red` (падающие тесты до реализации)
4. `implementation` (минимальный вертикальный срез)
5. `tests-green` (unit + integration + e2e + regression)
6. `observability` (trace + structured logs)
7. `docs` (обновление в том же изменении)

## Repository boundaries
- `apps/api` — Go backend (business rules)
- `apps/web` — Next.js adapter
- `apps/mobile/android` — Android WebView shell
- `apps/desktop/qt` — native adapter
- `packages/contracts` — API contracts and schemas
- `packages/tokens` — design tokens (DTCG)
- `packages/sdk-*` — generated/maintained SDKs
- `db/migrations` — schema evolution only through migrations
- `infra/docker`, `infra/nginx` — deployment and reverse proxy
- `mcp/*` — MCP server/gateway configs
- `agents/*` — agent profiles and task playbooks

## Business logic rule
- Domain logic только в `apps/api` service layer.
- UI/desktop не дублируют бизнес-валидации, только UX guardrails.

## Go backend implementation rules (READ FIRST)
Before any backend code change in `apps/api`, the agent must read:
- `docs/18-GO-BACKEND-ENGINEERING-STANDARD.md`

Mandatory rules:
- Routes are split by module and endpoint files; no monolithic router files.
- Handlers must stay thin and must not contain business logic.
- Hard line limits for files/functions/handlers are mandatory.
- Only explicit numeric limits from docs/18 are allowed (no "approximate"/"target" interpretation).
- Minimal comments policy is mandatory (prefer clear naming/structure).
- Code must stay multi-author friendly: constructor DI, narrow interfaces, explicit boundaries.

## Next/Node frontend implementation rules (READ FIRST)
Before any web code change in `apps/web`, the agent must read:
- `docs/19-NEXT-NODE-FRONTEND-STANDARD.md`

Mandatory rules:
- Reuse-first is mandatory; duplicate list implementations are forbidden.
- Web interactive primitives are shadcn-only in feature code.
- Only explicit numeric limits from docs/19 are allowed.
- Style policy is strict: max `5` colors, no shadows, no black borders.
- Animation policy is strict: no layout-shifting animations by default.

## Android implementation rules (READ FIRST)
Before any android code change in `apps/mobile/android`, the agent must read:
- `docs/24-ANDROID-ENGINEERING-STANDARD.md`

Mandatory rules:
- Android remains WebView-first: native shell only, no duplicated business logic.
- Deep-link auth exchange flow is mandatory and uses `/api/v1/auth/native/exchange`.
- WebView security baseline from docs/24 is mandatory.
- Only explicit numeric limits from docs/24 are allowed.
- Observability events for deep-link and exchange are mandatory.

## C++/Qt implementation rules (READ FIRST)
Before any desktop code change in `apps/desktop/qt`, the agent must read:
- `docs/20-CPP-QT-MEMORY-SAFETY-STANDARD.md`

Mandatory rules:
- C++ language/toolchain versions from docs/20 are fixed.
- Memory ownership must follow strict smart-pointer/Qt ownership contract.
- `new/delete/malloc/free` are forbidden in feature code.
- Sanitizer and static-analysis gates are mandatory.
- Qt UI flow must stay parity-aligned with web/Next flow and design rules.

## Auth & company switch security rules
Before any auth/session/company-switch related change, the agent must read:
- `docs/05-AUTH-COMPANY-SWITCH.md`
- `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`

Mandatory rules:
- Пароли только в hash.
- Сессионный токен хранится в БД только как hash.
- `auth_identities` и `device_credentials` должны соблюдаться в модели данных и API.
- Для Qt/Android native-flow обязателен web-based вход + PKCE + deep link exchange.
- Должны существовать и работать: список сессий, revoke одной сессии, revoke всех кроме текущей.
- Долгоживущий restore (после долгого простоя) реализуется через `device_credentials` с ротацией.
- `users.current_company_id` — canonical active tenant pointer.
- Switch разрешен только при membership/ownership.

Security incident response companion:
- `docs/26-SECURITY-INCIDENT-RUNBOOK.md`

## API conventions
- Prefix: `/api/v1`
- Error model: Problem Details-like payload
- Request ID обязателен для трассировки
- Contract-first: любые изменения API сначала в `packages/contracts`

## Observability rules (READ FIRST)
Before any backend/frontend/mobile/desktop feature completion, the agent must read:
- `docs/22-OBSERVABILITY-STANDARD.md`

Mandatory rules:
- Traces + structured logs + metrics are all mandatory.
- `request_id` must be propagated across headers/logs/spans.
- Handler-level observability checklist from docs/22 is mandatory.
- Sensitive data in logs/traces is forbidden.

## OpenAPI contract rules (READ FIRST)
Before any endpoint change in backend/frontend docs, the agent must read:
- `docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md`

Mandatory rules:
- Every endpoint must be described in modular OpenAPI files.
- Every endpoint must be listed in `endpoints.inventory.tsv`.
- OpenAPI examples/code samples are mandatory.
- Docs endpoints must expose bundled contract and endpoint catalog.
- Consistent response contract and response-header policy are mandatory.
- Error language tone is mandatory: `Исправьте/Проверьте/Укажите/...`.

## Testing & acceptance gate (READ FIRST)
Before any feature implementation or acceptance, the agent must read:
- `docs/17-TESTING-TDD-QUALITY-GATES.md`

Mandatory rules:
- TDD (`Red -> Green -> Refactor`) is required by default.
- Every changed backend module must include real integration tests.
- Every changed frontend feature must include component/integration tests and e2e scenario coverage.
- Universal-account regression pack must pass before feature acceptance.
- A feature is not accepted if any required test gate failed locally or in CI.

## Правила По Окружению И Развертыванию
Before any environment/deployment related change, the agent must read:
- `docs/12-ENV-REPO-DEPLOY.md`
- `docs/23-QUICK-START-5-MIN.md`

Mandatory rules:
- Real secrets are never committed, only `*.env.example`.
- Backend and frontend run on different ports.
- Public traffic goes through Nginx reverse proxy only.

## Commit conventions
Before preparing commits, the agent must read:
- `docs/14-COMMIT-STANDARDS-2026.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`

Mandatory rules:
- Commit messages are in English.
- Use Conventional Commit types (`feat`, `fix`, `chore`, `docs`, ...).
- Keep commits atomic and progressive (feature/fix/test/docs split).
- For non-trivial commits, include detailed body with Why/What/Impact/Validation.

## UI conventions (cross-platform)
Before any UI-related command/change, the agent must read:
- `docs/08-UI-CROSS-PLATFORM-RULES.md`
- `docs/09-PLATFORM-UI-STACKS.md`
- `docs/10-DESIGN-TOKENS-BUILD-PIPELINE.md`
- `docs/19-NEXT-NODE-FRONTEND-STANDARD.md`

Mandatory rules:
- One global accent color from tokens only.
- Web feature UI uses shadcn components only for interactive primitives.
- Reuse-first policy is mandatory; duplicate list implementations are forbidden.
- Web style must stay compact/high-contrast with max `5` colors, `0` shadows, `0` black borders.
- Qt desktop UI must follow same flow semantics and tokenized style constraints.
- Qt uses native components; Android uses WebView-first shell.
- UX flows and semantics must stay unified across all clients.
- Web must remain Telegram Mini App compatible.

## DB conventions
- PostgreSQL 18+
- UUID identifiers only
- UTC timestamps (`timestamptz`)
- append-only migrations (up/down pair)
- Mandatory versioning for business entities (full snapshots on each change)
- Logs/telemetry tables are excluded from business versioning

## Non-negotiable DB naming contract (READ FIRST)
Before any DB-related command/change, the agent must read:
- `docs/07-DB-NAMING-CONVENTIONS.md`
- `docs/15-DATA-VERSIONING-AND-DIFF.md`

Mandatory rules:
- Every entity table is plural snake_case: `users`, `companies`, `sessions`.
- Every entity primary key is exactly `<entity>_id` and `uuid`.
  - Example: table `users` -> PK `user_id uuid`.
- Every foreign key to another entity is exactly `<referenced_entity>_id` and `uuid`.
  - Example: reference to `users` -> column `user_id uuid`.
- Generic key names (`id`, `uuid`, `entity_id`) are forbidden.
- Non-UUID IDs are forbidden for domain entities.
- Join tables use UUID foreign keys with canonical names and usually composite PK.

If a task introduces a DB field that violates this contract, agent must stop and fix naming before proceeding.

## Agent operation conventions
- Before large changes, agent must select and follow a playbook from `agents/playbooks/`.
- Агент должен вести короткий task log в `agents/tasks/<task-id>.md` при крупных изменениях.
- Все решения по архитектуре фиксируются в `docs/adr`.

## MCP and agent operations rules (READ FIRST)
Before MCP config changes or agent-heavy execution, the agent must read:
- `docs/25-MCP-AGENTS-OPERATIONS-STANDARD.md`

Mandatory rules:
- MCP integrations must follow explicit allow/deny conventions.
- Human checkpoint is mandatory before deploy/security-sensitive actions.
- Agent logs and outputs must not leak secrets.
