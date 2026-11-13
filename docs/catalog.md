# Каталог правил

Все 142 правила исходной редакции сгруппированы по 16 разделам справочника. ID и пути сохраняются. Уровень описывает исходную обязательность в пределах области применения и не является оценкой достаточности правила.

Для выбора проектного набора используйте [профили](stack-profiles.md), для уточнения содержания — [аудит](audit-2026-11-13.md) и [очередь улучшений](standards-backlog.md).

## Основы и архитектура

Правил: 7. Описание раздела: [architecture](../registry/handbook/architecture.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `architecture.markdown-publishing` | [Публикации из Markdown: GitHub, даты, Redis и выгрузка](../registry/standards/content/markdown/rules/markdown-publishing.md) | Зависит от задачи |
| `architecture.scope` | [Границы задачи](../registry/standards/framework/lifecycle/rules/scope.md) | Рекомендуется |
| `architecture.one-source` | [Единый источник истины](../registry/standards/framework/lifecycle/rules/one-source.md) | Рекомендуется |
| `architecture.contract-first` | [Контракты компонентов](../registry/standards/framework/lifecycle/rules/contract-first.md) | Рекомендуется |
| `architecture.thin-slice` | [Вертикальный сценарий](../registry/standards/framework/lifecycle/rules/thin-slice.md) | Рекомендуется |
| `architecture.choose-dependencies` | [Зависимости проекта](../registry/standards/framework/lifecycle/rules/choose-dependencies.md) | Зависит от задачи |
| `architecture.readiness` | [Критерии готовности](../registry/standards/framework/lifecycle/rules/readiness.md) | Обязательно |

## Работа с AI-агентами

Правил: 6. Описание раздела: [ai-agents](../registry/handbook/ai-agents.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `ai-agents.context` | [Контекст проекта](../registry/standards/agent/base/rules/context.md) | Рекомендуется |
| `ai-agents.untrusted-input` | [Prompt injection](../registry/standards/agent/base/rules/untrusted-input.md) | Обязательно |
| `ai-agents.least-privilege` | [Минимальные привилегии](../registry/standards/agent/base/rules/least-privilege.md) | Обязательно |
| `ai-agents.confirm-impact` | [Полномочия агента](../registry/standards/agent/base/rules/confirm-impact.md) | Обязательно |
| `ai-agents.evidence` | [Доказательства выполнения](../registry/standards/agent/base/rules/evidence.md) | Обязательно |
| `ai-agents.evals-budget` | [AI evals](../registry/standards/agent/base/rules/evals-budget.md) | Рекомендуется |

## Совместная разработка

Правил: 6. Описание раздела: [collaboration](../registry/handbook/collaboration.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `collaboration.small-pr` | [Pull request](../registry/standards/collaboration/team/rules/small-pr.md) | Рекомендуется |
| `collaboration.ownership` | [Распределение изменений](../registry/standards/collaboration/team/rules/ownership.md) | Рекомендуется |
| `collaboration.preserve-changes` | [Рабочее дерево Git](../registry/standards/collaboration/team/rules/preserve-changes.md) | Обязательно |
| `collaboration.review` | [Code review](../registry/standards/collaboration/team/rules/review.md) | Рекомендуется |
| `collaboration.handoff` | [Передача результата](../registry/standards/collaboration/team/rules/handoff.md) | Рекомендуется |
| `collaboration.decisions` | [Architecture Decision Record](../registry/standards/collaboration/team/rules/decisions.md) | Зависит от задачи |

## Базы данных

Правил: 11. Описание раздела: [database](../registry/handbook/database.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `database.identifiers` | [Идентификаторы: UUID и bigint](../registry/standards/database/postgres/rules/identifiers.md) | Зависит от задачи |
| `database.naming` | [Имена таблиц и полей](../registry/standards/database/postgres/rules/naming.md) | Рекомендуется |
| `database.constraints` | [Ограничения целостности](../registry/standards/database/postgres/rules/constraints.md) | Обязательно |
| `database.foreign-keys` | [Внешние ключи](../registry/standards/database/postgres/rules/foreign-keys.md) | Рекомендуется |
| `database.transactions` | [Транзакции](../registry/standards/database/postgres/rules/transactions.md) | Обязательно |
| `database.migrations` | [Миграции схемы](../registry/standards/database/postgres/rules/migrations.md) | Обязательно |
| `database.indexes` | [Индексы PostgreSQL](../registry/standards/database/postgres/rules/indexes.md) | Рекомендуется |
| `database.time-money` | [Дата и время: timestamptz](../registry/standards/database/postgres/rules/time-money.md) | Рекомендуется |
| `database.jsonb` | [JSONB и реляционные поля](../registry/standards/database/postgres/rules/jsonb.md) | Зависит от задачи |
| `database.history-delete` | [История и удаление данных](../registry/standards/database/postgres/rules/history-delete.md) | Зависит от задачи |
| `database.money` | [Деньги: bigint, numeric и валюта](../registry/standards/database/postgres/rules/money.md) | Рекомендуется |

## API

Правил: 9. Описание раздела: [api](../registry/handbook/api.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `api.http-status` | [HTTP-статусы](../registry/standards/api/openapi-modular/rules/http-status.md) | Обязательно |
| `api.methods` | [HTTP-методы](../registry/standards/api/openapi-modular/rules/methods.md) | Обязательно |
| `api.error-details` | [Problem Details](../registry/standards/api/openapi-modular/rules/error-details.md) | Рекомендуется |
| `api.openapi` | [OpenAPI-контракт](../registry/standards/api/openapi-modular/rules/openapi.md) | Рекомендуется |
| `api.idempotency` | [Идемпотентность API](../registry/standards/api/openapi-modular/rules/idempotency.md) | Обязательно |
| `api.concurrency` | [Оптимистическая блокировка](../registry/standards/api/openapi-modular/rules/concurrency.md) | Рекомендуется |
| `api.pagination` | [Пагинация](../registry/standards/api/openapi-modular/rules/pagination.md) | Рекомендуется |
| `api.compatibility` | [Совместимость API](../registry/standards/api/openapi-modular/rules/compatibility.md) | Обязательно |
| `api.headers` | [HTTP-заголовки](../registry/standards/api/openapi-modular/rules/headers.md) | Рекомендуется |

## Backend

Правил: 7. Описание раздела: [backend](../registry/handbook/backend.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `backend.boundaries` | [Границы backend](../registry/standards/backend/go/rules/boundaries.md) | Рекомендуется |
| `backend.go-context` | [Go context](../registry/standards/backend/go/rules/go-context.md) | Рекомендуется |
| `backend.errors` | [Обработка ошибок](../registry/standards/backend/go/rules/errors.md) | Обязательно |
| `backend.bounded-concurrency` | [Ограничение параллелизма](../registry/standards/backend/go/rules/bounded-concurrency.md) | Рекомендуется |
| `backend.async` | [Async I/O](../registry/standards/backend/python/rules/async.md) | Обязательно |
| `backend.typed-boundaries` | [Валидация типов](../registry/standards/backend/python/rules/typed-boundaries.md) | Обязательно |
| `backend.readable-code` | [Читаемость кода](../registry/standards/backend/python/rules/readable-code.md) | Рекомендуется |

## Frontend

Правил: 7. Описание раздела: [frontend](../registry/handbook/frontend.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `frontend.server-client` | [Server и Client Components](../registry/standards/frontend/next/rules/server-client.md) | Рекомендуется |
| `frontend.data-boundary` | [Серверные данные](../registry/standards/frontend/next/rules/data-boundary.md) | Рекомендуется |
| `frontend.derived-state` | [Производное состояние](../registry/standards/frontend/react/rules/derived-state.md) | Рекомендуется |
| `frontend.remote-drafts` | [Черновики и серверное состояние](../registry/standards/frontend/react/rules/remote-drafts.md) | Рекомендуется |
| `frontend.url-state` | [Состояние в URL](../registry/standards/frontend/react/rules/url-state.md) | Рекомендуется |
| `frontend.states` | [Состояния интерфейса](../registry/standards/frontend/next/rules/states.md) | Обязательно |
| `frontend.performance` | [Web performance](../registry/standards/frontend/next/rules/performance.md) | Рекомендуется |

## Интерфейс

Правил: 30. Описание раздела: [interface](../registry/handbook/interface.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `interface.table-layout` | [Табличные представления](../registry/standards/ui/admin-interface/rules/table-layout.md) | Рекомендуется |
| `interface.table-sorting` | [Сортировка таблиц](../registry/standards/ui/admin-interface/rules/table-sorting.md) | Обязательно |
| `interface.table-columns` | [Настройка столбцов](../registry/standards/ui/admin-interface/rules/table-columns.md) | Рекомендуется |
| `interface.server-thumbnails` | [Серверные превью](../registry/standards/ui/admin-interface/rules/server-thumbnails.md) | Рекомендуется |
| `interface.row-navigation` | [Навигация по строке](../registry/standards/ui/admin-interface/rules/row-navigation.md) | Обязательно |
| `interface.row-selection` | [Выделение строк](../registry/standards/ui/admin-interface/rules/row-selection.md) | Обязательно |
| `interface.sticky-header` | [Закрепленный заголовок](../registry/standards/ui/admin-interface/rules/sticky-header.md) | Рекомендуется |
| `interface.incremental-loading` | [Постепенная загрузка](../registry/standards/ui/admin-interface/rules/incremental-loading.md) | Рекомендуется |
| `interface.bulk-actions` | [Групповые действия](../registry/standards/ui/admin-interface/rules/bulk-actions.md) | Обязательно |
| `interface.manual-order` | [Ручной порядок](../registry/standards/ui/admin-interface/rules/manual-order.md) | Рекомендуется |
| `interface.natural-search` | [Поиск на естественном языке](../registry/standards/ui/admin-interface/rules/natural-search.md) | Рекомендуется |
| `interface.saved-views` | [Сохраненные представления](../registry/standards/ui/admin-interface/rules/saved-views.md) | Рекомендуется |
| `interface.search-fallback` | [Отказоустойчивый поиск](../registry/standards/ui/admin-interface/rules/search-fallback.md) | Обязательно |
| `interface.editor-layout` | [Вкладки и свойства](../registry/standards/ui/admin-interface/rules/editor-layout.md) | Рекомендуется |
| `interface.field-validation` | [Поиск свойств и валидация](../registry/standards/ui/admin-interface/rules/field-validation.md) | Обязательно |
| `interface.important-switches` | [Тумблеры важных свойств](../registry/standards/ui/admin-interface/rules/important-switches.md) | Рекомендуется |
| `interface.draft-autosave` | [Автосохранение черновика](../registry/standards/ui/admin-interface/rules/draft-autosave.md) | Обязательно |
| `interface.draft-history` | [Версии и отмена](../registry/standards/ui/admin-interface/rules/draft-history.md) | Обязательно |
| `interface.preview-publication` | [Предпросмотр и публикация](../registry/standards/ui/admin-interface/rules/preview-publication.md) | Обязательно |
| `interface.editing-locks` | [Конкурентное редактирование](../registry/standards/ui/admin-interface/rules/editing-locks.md) | Обязательно |
| `interface.media-import` | [Добавление медиа](../registry/standards/ui/admin-interface/rules/media-import.md) | Обязательно |
| `interface.media-gallery` | [Галерея и описание медиа](../registry/standards/ui/admin-interface/rules/media-gallery.md) | Рекомендуется |
| `interface.media-editing` | [Редактирование медиа](../registry/standards/ui/admin-interface/rules/media-editing.md) | Рекомендуется |
| `interface.loading-errors` | [Загрузка и ошибки](../registry/standards/ui/admin-interface/rules/loading-errors.md) | Обязательно |
| `interface.keyboard-mobile` | [Клавиатура и мобильный экран](../registry/standards/ui/admin-interface/rules/keyboard-mobile.md) | Обязательно |
| `interface.editor-performance` | [Быстрое открытие формы](../registry/standards/ui/admin-interface/rules/editor-performance.md) | Рекомендуется |
| `interface.related-records` | [Связанные записи](../registry/standards/ui/admin-interface/rules/related-records.md) | Обязательно |
| `interface.record-address` | [Адрес записи](../registry/standards/ui/admin-interface/rules/record-address.md) | Обязательно |
| `interface.agent-proposals` | [Подготовленные правки агента](../registry/standards/ui/admin-interface/rules/agent-proposals.md) | Обязательно |
| `interface.context-help` | [Контекстная справка](../registry/standards/ui/admin-interface/rules/context-help.md) | Рекомендуется |

## Фреймворки и CMS

Правил: 15. Описание раздела: [frameworks](../registry/handbook/frameworks.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `frameworks.laravel-validation` | [Laravel: Form Request и Policy](../registry/standards/frameworks/platforms/rules/laravel-validation.md) | Рекомендуется |
| `frameworks.laravel-jobs` | [Laravel: транзакция и afterCommit](../registry/standards/frameworks/platforms/rules/laravel-jobs.md) | Рекомендуется |
| `frameworks.laravel-eloquent` | [Laravel: Eloquent и N+1](../registry/standards/frameworks/platforms/rules/laravel-eloquent.md) | Рекомендуется |
| `frameworks.bitrix-local` | [1С-Битрикс: /local и расширения](../registry/standards/frameworks/platforms/rules/bitrix-local.md) | Рекомендуется |
| `frameworks.bitrix-transactions` | [1С-Битрикс: D7-транзакции](../registry/standards/frameworks/platforms/rules/bitrix-transactions.md) | Рекомендуется |
| `frameworks.bitrix-cache` | [1С-Битрикс: ключ кеша и инвалидация](../registry/standards/frameworks/platforms/rules/bitrix-cache.md) | Рекомендуется |
| `frameworks.bitrix24-webhook` | [Bitrix24: серверный вебхук](../registry/standards/frameworks/platforms/rules/bitrix24-webhook.md) | Обязательно |
| `frameworks.bitrix24-limits` | [Bitrix24: лимиты и повтор запросов](../registry/standards/frameworks/platforms/rules/bitrix24-limits.md) | Рекомендуется |
| `frameworks.django-atomic` | [Django: atomic и on_commit](../registry/standards/frameworks/platforms/rules/django-atomic.md) | Рекомендуется |
| `frameworks.fastapi-io` | [FastAPI: async и блокирующий I/O](../registry/standards/frameworks/platforms/rules/fastapi-io.md) | Рекомендуется |
| `frameworks.nestjs-validation` | [NestJS: ValidationPipe и DTO](../registry/standards/frameworks/platforms/rules/nestjs-validation.md) | Рекомендуется |
| `frameworks.vue-computed` | [Vue: computed и производное состояние](../registry/standards/frameworks/platforms/rules/vue-computed.md) | Рекомендуется |
| `frameworks.nuxt-ssr-data` | [Nuxt: useAsyncData и SSR](../registry/standards/frameworks/platforms/rules/nuxt-ssr-data.md) | Рекомендуется |
| `frameworks.sveltekit-server` | [SvelteKit: server-only modules](../registry/standards/frameworks/platforms/rules/sveltekit-server.md) | Рекомендуется |
| `frameworks.wordpress-permissions` | [WordPress: capabilities и nonce](../registry/standards/frameworks/platforms/rules/wordpress-permissions.md) | Обязательно |

## Интеграции

Правил: 6. Описание раздела: [integrations](../registry/handbook/integrations.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `integrations.timeouts` | [Тайм-ауты интеграций](../registry/standards/integrations/external/rules/timeouts.md) | Обязательно |
| `integrations.retries` | [Retry и backoff](../registry/standards/integrations/external/rules/retries.md) | Рекомендуется |
| `integrations.oauth` | [OAuth и PKCE](../registry/standards/integrations/external/rules/oauth.md) | Обязательно |
| `integrations.webhooks` | [Подпись вебхуков](../registry/standards/integrations/external/rules/webhooks.md) | Обязательно |
| `integrations.mcp` | [Авторизация MCP](../registry/standards/integrations/external/rules/mcp.md) | Обязательно |
| `integrations.files` | [Загрузка файлов](../registry/standards/integrations/external/rules/files.md) | Обязательно |

## Кеш и фоновые задачи

Правил: 7. Описание раздела: [caching](../registry/handbook/caching.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `caching.source-of-truth` | [Источник истины кеша](../registry/standards/backend/worker/rules/source-of-truth.md) | Рекомендуется |
| `caching.freshness` | [TTL и инвалидация](../registry/standards/backend/worker/rules/freshness.md) | Рекомендуется |
| `caching.private-cache` | [Изоляция кеша](../registry/standards/backend/worker/rules/private-cache.md) | Обязательно |
| `caching.idempotent-worker` | [Идемпотентность worker](../registry/standards/backend/worker/rules/idempotent-worker.md) | Обязательно |
| `caching.outbox` | [Transactional outbox](../registry/standards/backend/worker/rules/outbox.md) | Зависит от задачи |
| `caching.dead-letter` | [Dead-letter queue](../registry/standards/backend/worker/rules/dead-letter.md) | Рекомендуется |
| `caching.redis-persistence` | [Redis: persistence и восстановление](../registry/standards/backend/worker/rules/redis-persistence.md) | Рекомендуется |

## Безопасность

Правил: 7. Описание раздела: [security](../registry/handbook/security.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `security.object-access` | [Object-level authorization](../registry/standards/security/no-secrets/rules/object-access.md) | Обязательно |
| `security.secrets` | [Управление секретами](../registry/standards/security/no-secrets/rules/secrets.md) | Обязательно |
| `security.sql-injection` | [SQL-параметры](../registry/standards/security/no-secrets/rules/sql-injection.md) | Обязательно |
| `security.ssrf` | [SSRF-защита](../registry/standards/security/no-secrets/rules/ssrf.md) | Обязательно |
| `security.redaction` | [Маскирование секретов в логах](../registry/standards/security/no-secrets/rules/redaction.md) | Обязательно |
| `security.supply-chain` | [Software supply chain](../registry/standards/security/no-secrets/rules/supply-chain.md) | Рекомендуется |
| `security.resource-limits` | [Лимиты ресурсов](../registry/standards/security/no-secrets/rules/resource-limits.md) | Обязательно |

## Тестирование

Правил: 6. Описание раздела: [testing](../registry/handbook/testing.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `testing.risk` | [Тестирование по риску](../registry/standards/testing/tdd-strict/rules/risk.md) | Рекомендуется |
| `testing.regression` | [Регрессионные тесты](../registry/standards/testing/tdd-strict/rules/regression.md) | Рекомендуется |
| `testing.integration` | [Интеграционные тесты](../registry/standards/testing/tdd-strict/rules/integration.md) | Рекомендуется |
| `testing.critical-paths` | [End-to-end тесты](../registry/standards/testing/tdd-strict/rules/critical-paths.md) | Рекомендуется |
| `testing.honest-checks` | [Статус проверок](../registry/standards/testing/tdd-strict/rules/honest-checks.md) | Обязательно |
| `testing.determinism` | [Детерминизм тестов](../registry/standards/testing/tdd-strict/rules/determinism.md) | Рекомендуется |

## Выпуск и эксплуатация

Правил: 9. Описание раздела: [operations](../registry/handbook/operations.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `operations.correlation` | [Correlation ID](../registry/standards/observability/three-signals/rules/correlation.md) | Рекомендуется |
| `operations.http-spans` | [HTTP spans](../registry/standards/observability/three-signals/rules/http-spans.md) | Рекомендуется |
| `operations.signals` | [Observability](../registry/standards/observability/three-signals/rules/signals.md) | Рекомендуется |
| `operations.slo` | [SLO и error budget](../registry/standards/observability/three-signals/rules/slo.md) | Рекомендуется |
| `operations.immutable-release` | [Неизменяемый артефакт](../registry/standards/delivery/release/rules/immutable-release.md) | Обязательно |
| `operations.rollback` | [Rollback](../registry/standards/delivery/release/rules/rollback.md) | Обязательно |
| `operations.restore` | [Backup и restore](../registry/standards/delivery/release/rules/restore.md) | Обязательно |
| `operations.config` | [Конфигурация окружения](../registry/standards/delivery/release/rules/config.md) | Обязательно |
| `operations.incident` | [Incident runbook](../registry/standards/delivery/release/rules/incident.md) | Рекомендуется |

## Мобильные приложения

Правил: 4. Описание раздела: [mobile](../registry/handbook/mobile.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `mobile.secure-storage` | [Keychain и Keystore](../registry/standards/mobile/react-native/rules/secure-storage.md) | Обязательно |
| `mobile.deep-links` | [Deep links](../registry/standards/mobile/react-native/rules/deep-links.md) | Обязательно |
| `mobile.offline` | [Офлайн-синхронизация](../registry/standards/mobile/react-native/rules/offline.md) | Рекомендуется |
| `mobile.native-release` | [Мобильный релиз](../registry/standards/mobile/react-native/rules/native-release.md) | Рекомендуется |

## Платежи

Правил: 5. Описание раздела: [payments](../registry/handbook/payments.md).

| ID | Правило | Уровень |
| --- | --- | --- |
| `payments.payment-truth` | [Подтверждение оплаты](../registry/standards/payments/stripe/rules/payment-truth.md) | Обязательно |
| `payments.payment-events` | [Платежные события](../registry/standards/payments/stripe/rules/payment-events.md) | Обязательно |
| `payments.card-data` | [Платежные данные](../registry/standards/payments/stripe/rules/card-data.md) | Обязательно |
| `payments.reconciliation` | [Платежная сверка](../registry/standards/payments/stripe/rules/reconciliation.md) | Рекомендуется |
| `payments.test-live` | [Платежные окружения](../registry/standards/payments/stripe/rules/test-live.md) | Обязательно |
