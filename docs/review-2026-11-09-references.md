# Повторная проверка правил и первоисточников — 9 ноября 2026

Проверены все 111 действующих правил: смысл рекомендации, обязательность и область применения, сопоставимость примеров, роли человека и агента, связанные материалы и соответствие первоисточников. Сохранены стабильные ID и URL. Новых правил не добавлено.

В итоговой редакции 125 уникальных ссылок на первоисточники. Для каждой проверены HTTP-ответ, конечный адрес, наличие указанного фрагмента и соответствие темы документа. [Результаты запросов](reference-check-2026-11-09.json) фиксируют состояние на момент проверки; это не гарантия постоянной доступности.

## Исправления

- Bitrix24: исправлен адрес batch, возвращавший 404.
- 1С-Битрикс: удалена ссылка Cache::clean с содержимым «404» при HTTP 200 и ссылка на обзор вместо нужного урока.
- Наборы первоисточников уточнены: JSONB, транзакции, outbox, SQL-параметры, Go context, ADR, AI evals, платежи и другие темы.
- Go: исправлено число возвращаемых значений при ошибке; пример context использует QueryRowContext/Scan и проверяет ошибку.
- WordPress: объект записи совпадает с проверенным ID; добавлены wp_slash и WP_Error.
- Laravel: отмечено, что after_commit=true уже откладывает отправку.
- Android: Keystore хранит ключи шифрования; токен хранится зашифрованным отдельно.
- Stripe: корректное название payment_intent.succeeded и дедупликация бизнес-операции независимо от event_id.
- Деньги: integer, bigint и numeric показаны отдельно; уточнён безопасный диапазон Number.
- История версий отделена от аудита; восстановление — от отдельной проверки целостности копии.
- Правила справочника явно отделены от требований протоколов там, где ссылки описывают инженерный подход.
- Названия документов добавлены в ссылки. Валидатор запрещает расхождение ссылок Markdown и метаданных.

## Границы проверки

Проверка реестра и тесты подтверждают структуру, уникальность, связи, совпадение ссылок и воспроизводимость standard.md и профилей. Тексты и фрагменты сверены с документацией; полноценные приложения на Laravel, Bitrix, WordPress, Django и остальных платформах в этом реестре не запускались. Их примеры требуют контекста проекта и интеграционной проверки перед использованием. Версии в области применения намеренно сохранены: ссылка на Laravel 12.x или Django 5.2 не означает требования обновить все проекты до текущего major.

## По каждому правилу

### Основы и архитектура

- [architecture.scope](../registry/standards/framework/lifecycle/rules/scope.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [architecture.one-source](../registry/standards/framework/lifecycle/rules/one-source.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [architecture.contract-first](../registry/standards/framework/lifecycle/rules/contract-first.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [architecture.thin-slice](../registry/standards/framework/lifecycle/rules/thin-slice.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [architecture.choose-dependencies](../registry/standards/framework/lifecycle/rules/choose-dependencies.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [architecture.readiness](../registry/standards/framework/lifecycle/rules/readiness.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.

### Работа с AI-агентами

- [ai-agents.context](../registry/standards/agent/base/rules/context.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [ai-agents.untrusted-input](../registry/standards/agent/base/rules/untrusted-input.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [ai-agents.least-privilege](../registry/standards/agent/base/rules/least-privilege.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [ai-agents.confirm-impact](../registry/standards/agent/base/rules/confirm-impact.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [ai-agents.evidence](../registry/standards/agent/base/rules/evidence.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [ai-agents.evals-budget](../registry/standards/agent/base/rules/evals-budget.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.

### Совместная разработка

- [collaboration.small-pr](../registry/standards/collaboration/team/rules/small-pr.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [collaboration.ownership](../registry/standards/collaboration/team/rules/ownership.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [collaboration.preserve-changes](../registry/standards/collaboration/team/rules/preserve-changes.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [collaboration.review](../registry/standards/collaboration/team/rules/review.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [collaboration.handoff](../registry/standards/collaboration/team/rules/handoff.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [collaboration.decisions](../registry/standards/collaboration/team/rules/decisions.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.

### Базы данных

- [database.identifiers](../registry/standards/database/postgres/rules/identifiers.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [database.naming](../registry/standards/database/postgres/rules/naming.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [database.constraints](../registry/standards/database/postgres/rules/constraints.md): Псевдокод проверки в приложении больше не помечен как SQL; уникальность остаётся ограничением БД. Ссылки проверены.
- [database.foreign-keys](../registry/standards/database/postgres/rules/foreign-keys.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [database.transactions](../registry/standards/database/postgres/rules/transactions.md): Сценарий сбоя помечен как текст, а SQL-транзакция сохранена; дана прямая документация транзакций. Связанные правила подобраны по смыслу. Ссылки проверены.
- [database.migrations](../registry/standards/database/postgres/rules/migrations.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [database.indexes](../registry/standards/database/postgres/rules/indexes.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [database.time-money](../registry/standards/database/postgres/rules/time-money.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [database.jsonb](../registry/standards/database/postgres/rules/jsonb.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [database.history-delete](../registry/standards/database/postgres/rules/history-delete.md): Разделены аудит и история версий; удалено несвязанное замечание о ключах таблиц связей. Связанные правила подобраны по смыслу. Ссылки проверены.
- [database.money](../registry/standards/database/postgres/rules/money.md): Выбор integer, bigint и numeric показан списком; уточнён безопасный диапазон JavaScript Number. Ссылки проверены.

### API

- [api.http-status](../registry/standards/api/openapi-modular/rules/http-status.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [api.methods](../registry/standards/api/openapi-modular/rules/methods.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [api.error-details](../registry/standards/api/openapi-modular/rules/error-details.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [api.openapi](../registry/standards/api/openapi-modular/rules/openapi.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [api.idempotency](../registry/standards/api/openapi-modular/rules/idempotency.md): Указана граница RFC 9110 и контракта Idempotency-Key; срок хранения не объявлен универсальным. Ссылки проверены.
- [api.concurrency](../registry/standards/api/openapi-modular/rules/concurrency.md): Содержание сохранено. Связанные правила подобраны по смыслу. Ссылки проверены.
- [api.pagination](../registry/standards/api/openapi-modular/rules/pagination.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [api.compatibility](../registry/standards/api/openapi-modular/rules/compatibility.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [api.headers](../registry/standards/api/openapi-modular/rules/headers.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.

### Backend

- [backend.boundaries](../registry/standards/backend/go/rules/boundaries.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [backend.go-context](../registry/standards/backend/go/rules/go-context.md): Уточнены контекст и область примера; результат QueryRow читается через Scan с проверкой ошибки. Связанные правила подобраны по смыслу. Ссылки проверены.
- [backend.errors](../registry/standards/backend/go/rules/errors.md): Исправлена сигнатура возврата Go: при ошибке возвращаются nil и error; причина сохраняется через %w. Связанные правила подобраны по смыслу. Ссылки проверены.
- [backend.bounded-concurrency](../registry/standards/backend/go/rules/bounded-concurrency.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [backend.async](../registry/standards/backend/python/rules/async.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [backend.typed-boundaries](../registry/standards/backend/python/rules/typed-boundaries.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [backend.readable-code](../registry/standards/backend/python/rules/readable-code.md): Содержание сохранено. Связанные правила подобраны по смыслу. Ссылки проверены.

### Frontend

- [frontend.server-client](../registry/standards/frontend/next/rules/server-client.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frontend.data-boundary](../registry/standards/frontend/next/rules/data-boundary.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [frontend.derived-state](../registry/standards/frontend/react/rules/derived-state.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frontend.remote-drafts](../registry/standards/frontend/react/rules/remote-drafts.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frontend.url-state](../registry/standards/frontend/react/rules/url-state.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [frontend.states](../registry/standards/frontend/next/rules/states.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [frontend.performance](../registry/standards/frontend/next/rules/performance.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.

### Фреймворки и CMS

- [frameworks.laravel-validation](../registry/standards/frameworks/platforms/rules/laravel-validation.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.laravel-jobs](../registry/standards/frameworks/platforms/rules/laravel-jobs.md): Уточнена конфигурация очереди: явный afterCommit не обязателен при after_commit=true. Ссылки проверены.
- [frameworks.laravel-eloquent](../registry/standards/frameworks/platforms/rules/laravel-eloquent.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.bitrix-local](../registry/standards/frameworks/platforms/rules/bitrix-local.md): Исправлен путь системного шаблона; удалена ссылка, ведущая на обзор курса вместо нужного урока. Ссылки проверены.
- [frameworks.bitrix-transactions](../registry/standards/frameworks/platforms/rules/bitrix-transactions.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.bitrix-cache](../registry/standards/frameworks/platforms/rules/bitrix-cache.md): Удалён скрытый 404 документации Cache::clean; ошибка JSON больше не превращается в общий пустой ключ. Ссылки проверены.
- [frameworks.bitrix24-webhook](../registry/standards/frameworks/platforms/rules/bitrix24-webhook.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.bitrix24-limits](../registry/standards/frameworks/platforms/rules/bitrix24-limits.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [frameworks.django-atomic](../registry/standards/frameworks/platforms/rules/django-atomic.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.fastapi-io](../registry/standards/frameworks/platforms/rules/fastapi-io.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.nestjs-validation](../registry/standards/frameworks/platforms/rules/nestjs-validation.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.vue-computed](../registry/standards/frameworks/platforms/rules/vue-computed.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.nuxt-ssr-data](../registry/standards/frameworks/platforms/rules/nuxt-ssr-data.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [frameworks.sveltekit-server](../registry/standards/frameworks/platforms/rules/sveltekit-server.md): Серверная выборка ограничена и имеет устойчивый порядок; пример не предлагает неограниченную выдачу. Ссылки проверены.
- [frameworks.wordpress-permissions](../registry/standards/frameworks/platforms/rules/wordpress-permissions.md): Пример привязан к тому же объекту, для которого проверено право; добавлены wp_slash и обработка WP_Error. Ссылки проверены.

### Интеграции

- [integrations.timeouts](../registry/standards/integrations/external/rules/timeouts.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [integrations.retries](../registry/standards/integrations/external/rules/retries.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [integrations.oauth](../registry/standards/integrations/external/rules/oauth.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [integrations.webhooks](../registry/standards/integrations/external/rules/webhooks.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [integrations.mcp](../registry/standards/integrations/external/rules/mcp.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [integrations.files](../registry/standards/integrations/external/rules/files.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.

### Кеш и фоновые задачи

- [caching.source-of-truth](../registry/standards/backend/worker/rules/source-of-truth.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [caching.freshness](../registry/standards/backend/worker/rules/freshness.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [caching.private-cache](../registry/standards/backend/worker/rules/private-cache.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [caching.idempotent-worker](../registry/standards/backend/worker/rules/idempotent-worker.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [caching.outbox](../registry/standards/backend/worker/rules/outbox.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [caching.dead-letter](../registry/standards/backend/worker/rules/dead-letter.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [caching.redis-persistence](../registry/standards/backend/worker/rules/redis-persistence.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.

### Безопасность

- [security.object-access](../registry/standards/security/no-secrets/rules/object-access.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [security.secrets](../registry/standards/security/no-secrets/rules/secrets.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [security.sql-injection](../registry/standards/security/no-secrets/rules/sql-injection.md): SQL-псевдокод заменён корректным вызовом Psycopg 3 с bind-параметром. Ссылки проверены.
- [security.ssrf](../registry/standards/security/no-secrets/rules/ssrf.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [security.redaction](../registry/standards/security/no-secrets/rules/redaction.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [security.supply-chain](../registry/standards/security/no-secrets/rules/supply-chain.md): Содержание сохранено. Связанные правила подобраны по смыслу. Ссылки проверены.
- [security.resource-limits](../registry/standards/security/no-secrets/rules/resource-limits.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.

### Тестирование

- [testing.risk](../registry/standards/testing/tdd-strict/rules/risk.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [testing.regression](../registry/standards/testing/tdd-strict/rules/regression.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [testing.integration](../registry/standards/testing/tdd-strict/rules/integration.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [testing.critical-paths](../registry/standards/testing/tdd-strict/rules/critical-paths.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [testing.honest-checks](../registry/standards/testing/tdd-strict/rules/honest-checks.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [testing.determinism](../registry/standards/testing/tdd-strict/rules/determinism.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.

### Выпуск и эксплуатация

- [operations.correlation](../registry/standards/observability/three-signals/rules/correlation.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [operations.http-spans](../registry/standards/observability/three-signals/rules/http-spans.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [operations.signals](../registry/standards/observability/three-signals/rules/signals.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [operations.slo](../registry/standards/observability/three-signals/rules/slo.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [operations.immutable-release](../registry/standards/delivery/release/rules/immutable-release.md): Содержательных ошибок при повторной сверке не выявлено; сохранены область применения и примеры. Ссылки проверены.
- [operations.rollback](../registry/standards/delivery/release/rules/rollback.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [operations.restore](../registry/standards/delivery/release/rules/restore.md): Убрано неверное «только при восстановлении»: повреждения могут обнаруживаться и проверкой целостности. Связанные правила подобраны по смыслу. Ссылки проверены.
- [operations.config](../registry/standards/delivery/release/rules/config.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [operations.incident](../registry/standards/delivery/release/rules/incident.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.

### Мобильные приложения

- [mobile.secure-storage](../registry/standards/mobile/react-native/rules/secure-storage.md): Исправлено описание Keystore: он защищает ключ шифрования, а не хранит произвольную строку токена. Ссылки проверены.
- [mobile.deep-links](../registry/standards/mobile/react-native/rules/deep-links.md): Содержание сохранено. Связанные правила подобраны по смыслу. Ссылки проверены.
- [mobile.offline](../registry/standards/mobile/react-native/rules/offline.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [mobile.native-release](../registry/standards/mobile/react-native/rules/native-release.md): Добавлен прямой первоисточник runtimeVersion вместо общей страницы безопасности React Native. Связанные правила подобраны по смыслу. Ссылки проверены.

### Платежи

- [payments.payment-truth](../registry/standards/payments/stripe/rules/payment-truth.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [payments.payment-events](../registry/standards/payments/stripe/rules/payment-events.md): Название события приведено к Stripe; добавлена дедупликация бизнес-эффекта независимо от event_id. Ссылки проверены.
- [payments.card-data](../registry/standards/payments/stripe/rules/card-data.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.
- [payments.reconciliation](../registry/standards/payments/stripe/rules/reconciliation.md): Уточнены предметные первоисточники вместо общего раздела документации. Связанные правила подобраны по смыслу. Ссылки проверены.
- [payments.test-live](../registry/standards/payments/stripe/rules/test-live.md): Уточнены предметные первоисточники вместо общего раздела документации. Ссылки проверены.

