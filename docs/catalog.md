# Каталог инженерных требований

Редакция от 13 ноября 2026 года: **212 правил, 19 разделов, 26 модулей**. Канонический текст находится только в связанных `rules/*.md`. Уровень обязательности действует в пределах области применения статьи.

[Результат содержательной редакции](revision-2026-11-13.md) · [Языковые требования](language-baselines.md) · [Профили](stack-profiles.md) · [Статус публикации](publication-status.md).

## Разделы

| Раздел | Правил |
| --- | ---: |
| [Основы и архитектура](../registry/handbook/architecture.md) | 7 |
| [Работа с AI-агентами](../registry/handbook/ai-agents.md) | 6 |
| [Совместная разработка](../registry/handbook/collaboration.md) | 6 |
| [Базы данных](../registry/handbook/database.md) | 11 |
| [API](../registry/handbook/api.md) | 9 |
| [Backend](../registry/handbook/backend.md) | 7 |
| [Frontend](../registry/handbook/frontend.md) | 10 |
| [Интерфейс](../registry/handbook/interface.md) | 33 |
| [Фреймворки и CMS](../registry/handbook/frameworks.md) | 25 |
| [Интеграции](../registry/handbook/integrations.md) | 6 |
| [Кеш и фоновые задачи](../registry/handbook/caching.md) | 7 |
| [Безопасность](../registry/handbook/security.md) | 12 |
| [Тестирование](../registry/handbook/testing.md) | 6 |
| [Выпуск и эксплуатация](../registry/handbook/operations.md) | 9 |
| [Мобильные приложения](../registry/handbook/mobile.md) | 5 |
| [Платежи](../registry/handbook/payments.md) | 5 |
| [Языки и базовые соглашения](../registry/handbook/languages.md) | 17 |
| [SEO и приемка публичного сайта](../registry/handbook/seo.md) | 17 |
| [Персональные данные и требования РФ](../registry/handbook/legal-ru.md) | 14 |

## Основы и архитектура

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `architecture.markdown-publishing` | [Публикации из Markdown: GitHub, даты, Redis и выгрузка](../registry/standards/content/markdown/rules/markdown-publishing.md) | По условию | `content/markdown` |
| `architecture.scope` | [Границы задачи](../registry/standards/framework/lifecycle/rules/scope.md) | Рекомендуется | `framework/lifecycle` |
| `architecture.one-source` | [Единый источник истины](../registry/standards/framework/lifecycle/rules/one-source.md) | Рекомендуется | `framework/lifecycle` |
| `architecture.contract-first` | [Контракты компонентов](../registry/standards/framework/lifecycle/rules/contract-first.md) | Рекомендуется | `framework/lifecycle` |
| `architecture.thin-slice` | [Вертикальный сценарий](../registry/standards/framework/lifecycle/rules/thin-slice.md) | Рекомендуется | `framework/lifecycle` |
| `architecture.choose-dependencies` | [Зависимости проекта](../registry/standards/framework/lifecycle/rules/choose-dependencies.md) | По условию | `framework/lifecycle` |
| `architecture.readiness` | [Критерии готовности](../registry/standards/framework/lifecycle/rules/readiness.md) | Обязательно | `framework/lifecycle` |

## Работа с AI-агентами

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `ai-agents.context` | [Контекст проекта](../registry/standards/agent/base/rules/context.md) | Рекомендуется | `agent/base` |
| `ai-agents.untrusted-input` | [Prompt injection](../registry/standards/agent/base/rules/untrusted-input.md) | Обязательно | `agent/base` |
| `ai-agents.least-privilege` | [Минимальные привилегии](../registry/standards/agent/base/rules/least-privilege.md) | Обязательно | `agent/base` |
| `ai-agents.confirm-impact` | [Полномочия агента](../registry/standards/agent/base/rules/confirm-impact.md) | Обязательно | `agent/base` |
| `ai-agents.evidence` | [Доказательства выполнения](../registry/standards/agent/base/rules/evidence.md) | Обязательно | `agent/base` |
| `ai-agents.evals-budget` | [AI evals](../registry/standards/agent/base/rules/evals-budget.md) | Рекомендуется | `agent/base` |

## Совместная разработка

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `collaboration.small-pr` | [Pull request](../registry/standards/collaboration/team/rules/small-pr.md) | Рекомендуется | `collaboration/team` |
| `collaboration.ownership` | [Распределение изменений](../registry/standards/collaboration/team/rules/ownership.md) | Рекомендуется | `collaboration/team` |
| `collaboration.preserve-changes` | [Рабочее дерево Git](../registry/standards/collaboration/team/rules/preserve-changes.md) | Обязательно | `collaboration/team` |
| `collaboration.review` | [Code review](../registry/standards/collaboration/team/rules/review.md) | Рекомендуется | `collaboration/team` |
| `collaboration.handoff` | [Передача результата](../registry/standards/collaboration/team/rules/handoff.md) | Рекомендуется | `collaboration/team` |
| `collaboration.decisions` | [Architecture Decision Record](../registry/standards/collaboration/team/rules/decisions.md) | По условию | `collaboration/team` |

## Базы данных

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `database.identifiers` | [Идентификаторы: UUID и bigint](../registry/standards/database/postgres/rules/identifiers.md) | По условию | `database/postgres` |
| `database.naming` | [Имена таблиц и полей](../registry/standards/database/postgres/rules/naming.md) | Рекомендуется | `database/postgres` |
| `database.constraints` | [Ограничения целостности](../registry/standards/database/postgres/rules/constraints.md) | Обязательно | `database/postgres` |
| `database.foreign-keys` | [Внешние ключи](../registry/standards/database/postgres/rules/foreign-keys.md) | Рекомендуется | `database/postgres` |
| `database.transactions` | [Транзакции](../registry/standards/database/postgres/rules/transactions.md) | Обязательно | `database/postgres` |
| `database.migrations` | [Миграции схемы](../registry/standards/database/postgres/rules/migrations.md) | Обязательно | `database/postgres` |
| `database.indexes` | [Индексы PostgreSQL](../registry/standards/database/postgres/rules/indexes.md) | Рекомендуется | `database/postgres` |
| `database.time-money` | [Дата и время: timestamptz](../registry/standards/database/postgres/rules/time-money.md) | Рекомендуется | `database/postgres` |
| `database.jsonb` | [JSONB и реляционные поля](../registry/standards/database/postgres/rules/jsonb.md) | По условию | `database/postgres` |
| `database.history-delete` | [История и удаление данных](../registry/standards/database/postgres/rules/history-delete.md) | По условию | `database/postgres` |
| `database.money` | [Деньги: bigint, numeric и валюта](../registry/standards/database/postgres/rules/money.md) | Рекомендуется | `database/postgres` |

## API

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `api.http-status` | [HTTP-статусы](../registry/standards/api/openapi-modular/rules/http-status.md) | Обязательно | `api/openapi-modular` |
| `api.methods` | [HTTP-методы](../registry/standards/api/openapi-modular/rules/methods.md) | Обязательно | `api/openapi-modular` |
| `api.error-details` | [Problem Details](../registry/standards/api/openapi-modular/rules/error-details.md) | Рекомендуется | `api/openapi-modular` |
| `api.openapi` | [OpenAPI-контракт](../registry/standards/api/openapi-modular/rules/openapi.md) | Рекомендуется | `api/openapi-modular` |
| `api.idempotency` | [Идемпотентность API](../registry/standards/api/openapi-modular/rules/idempotency.md) | Обязательно | `api/openapi-modular` |
| `api.concurrency` | [Оптимистическая блокировка](../registry/standards/api/openapi-modular/rules/concurrency.md) | Рекомендуется | `api/openapi-modular` |
| `api.pagination` | [Пагинация](../registry/standards/api/openapi-modular/rules/pagination.md) | Рекомендуется | `api/openapi-modular` |
| `api.compatibility` | [Совместимость API](../registry/standards/api/openapi-modular/rules/compatibility.md) | Обязательно | `api/openapi-modular` |
| `api.headers` | [HTTP-заголовки](../registry/standards/api/openapi-modular/rules/headers.md) | Рекомендуется | `api/openapi-modular` |

## Backend

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `backend.boundaries` | [Границы backend](../registry/standards/backend/go/rules/boundaries.md) | Рекомендуется | `backend/go` |
| `backend.go-context` | [Go context](../registry/standards/backend/go/rules/go-context.md) | Рекомендуется | `backend/go` |
| `backend.errors` | [Обработка ошибок](../registry/standards/backend/go/rules/errors.md) | Обязательно | `backend/go` |
| `backend.bounded-concurrency` | [Ограничение параллелизма](../registry/standards/backend/go/rules/bounded-concurrency.md) | Рекомендуется | `backend/go` |
| `backend.async` | [Async I/O](../registry/standards/backend/python/rules/async.md) | Обязательно | `backend/python` |
| `backend.typed-boundaries` | [Валидация типов](../registry/standards/backend/python/rules/typed-boundaries.md) | Обязательно | `backend/python` |
| `backend.readable-code` | [Читаемость кода](../registry/standards/backend/python/rules/readable-code.md) | Рекомендуется | `backend/python` |

## Frontend

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `frontend.server-client` | [Server и Client Components](../registry/standards/frontend/next/rules/server-client.md) | Рекомендуется | `frontend/next` |
| `frontend.data-boundary` | [Серверные данные](../registry/standards/frontend/next/rules/data-boundary.md) | Рекомендуется | `frontend/next` |
| `frontend.derived-state` | [Производное состояние](../registry/standards/frontend/react/rules/derived-state.md) | Рекомендуется | `frontend/react` |
| `frontend.remote-drafts` | [Черновики и серверное состояние](../registry/standards/frontend/react/rules/remote-drafts.md) | Рекомендуется | `frontend/react` |
| `frontend.url-state` | [Состояние в URL](../registry/standards/frontend/react/rules/url-state.md) | Рекомендуется | `frontend/react` |
| `frontend.states` | [Состояния интерфейса](../registry/standards/frontend/next/rules/states.md) | Обязательно | `frontend/next` |
| `frontend.performance` | [Web performance](../registry/standards/frontend/next/rules/performance.md) | Рекомендуется | `frontend/next` |
| `frontend.component-naming` | [Имена и определения React-компонентов](../registry/standards/frontend/react/rules/component-naming.md) | Обязательно | `frontend/react` |
| `frontend.hooks` | [Порядок и область вызова React Hooks](../registry/standards/frontend/react/rules/hooks.md) | Обязательно | `frontend/react` |
| `frontend.next-file-conventions` | [Имена файлов и маршруты Next.js](../registry/standards/frontend/next/rules/next-file-conventions.md) | Обязательно | `frontend/next` |

## Интерфейс

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `interface.table-layout` | [Табличные представления](../registry/standards/ui/admin-interface/rules/table-layout.md) | Рекомендуется | `ui/admin-interface` |
| `interface.table-sorting` | [Сортировка таблиц](../registry/standards/ui/admin-interface/rules/table-sorting.md) | Обязательно | `ui/admin-interface` |
| `interface.table-columns` | [Настройка столбцов](../registry/standards/ui/admin-interface/rules/table-columns.md) | Рекомендуется | `ui/admin-interface` |
| `interface.server-thumbnails` | [Серверные превью](../registry/standards/ui/admin-interface/rules/server-thumbnails.md) | Рекомендуется | `ui/admin-interface` |
| `interface.row-navigation` | [Навигация по строке](../registry/standards/ui/admin-interface/rules/row-navigation.md) | Обязательно | `ui/admin-interface` |
| `interface.row-selection` | [Выделение строк](../registry/standards/ui/admin-interface/rules/row-selection.md) | Обязательно | `ui/admin-interface` |
| `interface.sticky-header` | [Закрепленный заголовок](../registry/standards/ui/admin-interface/rules/sticky-header.md) | Рекомендуется | `ui/admin-interface` |
| `interface.incremental-loading` | [Постепенная загрузка](../registry/standards/ui/admin-interface/rules/incremental-loading.md) | Рекомендуется | `ui/admin-interface` |
| `interface.bulk-actions` | [Групповые действия](../registry/standards/ui/admin-interface/rules/bulk-actions.md) | Обязательно | `ui/admin-interface` |
| `interface.manual-order` | [Ручной порядок](../registry/standards/ui/admin-interface/rules/manual-order.md) | Рекомендуется | `ui/admin-interface` |
| `interface.natural-search` | [Поиск на естественном языке](../registry/standards/ui/admin-interface/rules/natural-search.md) | Рекомендуется | `ui/admin-interface` |
| `interface.saved-views` | [Сохраненные представления](../registry/standards/ui/admin-interface/rules/saved-views.md) | Рекомендуется | `ui/admin-interface` |
| `interface.search-fallback` | [Отказоустойчивый поиск](../registry/standards/ui/admin-interface/rules/search-fallback.md) | Обязательно | `ui/admin-interface` |
| `interface.editor-layout` | [Вкладки и свойства](../registry/standards/ui/admin-interface/rules/editor-layout.md) | Рекомендуется | `ui/admin-interface` |
| `interface.field-validation` | [Поиск свойств и валидация](../registry/standards/ui/admin-interface/rules/field-validation.md) | Обязательно | `ui/admin-interface` |
| `interface.important-switches` | [Тумблеры важных свойств](../registry/standards/ui/admin-interface/rules/important-switches.md) | Рекомендуется | `ui/admin-interface` |
| `interface.draft-autosave` | [Автосохранение черновика](../registry/standards/ui/admin-interface/rules/draft-autosave.md) | Обязательно | `ui/admin-interface` |
| `interface.draft-history` | [Версии и отмена](../registry/standards/ui/admin-interface/rules/draft-history.md) | Обязательно | `ui/admin-interface` |
| `interface.preview-publication` | [Предпросмотр и публикация](../registry/standards/ui/admin-interface/rules/preview-publication.md) | Обязательно | `ui/admin-interface` |
| `interface.editing-locks` | [Конкурентное редактирование](../registry/standards/ui/admin-interface/rules/editing-locks.md) | Обязательно | `ui/admin-interface` |
| `interface.media-import` | [Добавление медиа](../registry/standards/ui/admin-interface/rules/media-import.md) | Обязательно | `ui/admin-interface` |
| `interface.media-gallery` | [Галерея и описание медиа](../registry/standards/ui/admin-interface/rules/media-gallery.md) | Рекомендуется | `ui/admin-interface` |
| `interface.media-editing` | [Редактирование медиа](../registry/standards/ui/admin-interface/rules/media-editing.md) | Рекомендуется | `ui/admin-interface` |
| `interface.loading-errors` | [Загрузка и ошибки](../registry/standards/ui/admin-interface/rules/loading-errors.md) | Обязательно | `ui/admin-interface` |
| `interface.keyboard-mobile` | [Клавиатура и мобильный экран](../registry/standards/ui/admin-interface/rules/keyboard-mobile.md) | Обязательно | `ui/admin-interface` |
| `interface.editor-performance` | [Быстрое открытие формы](../registry/standards/ui/admin-interface/rules/editor-performance.md) | Рекомендуется | `ui/admin-interface` |
| `interface.related-records` | [Связанные записи](../registry/standards/ui/admin-interface/rules/related-records.md) | Обязательно | `ui/admin-interface` |
| `interface.record-address` | [Адрес записи](../registry/standards/ui/admin-interface/rules/record-address.md) | Обязательно | `ui/admin-interface` |
| `interface.agent-proposals` | [Подготовленные правки агента](../registry/standards/ui/admin-interface/rules/agent-proposals.md) | Обязательно | `ui/admin-interface` |
| `interface.context-help` | [Контекстная справка](../registry/standards/ui/admin-interface/rules/context-help.md) | Рекомендуется | `ui/admin-interface` |
| `interface.navigation-links` | [Ссылки родительских разделов меню](../registry/standards/ui/admin-interface/rules/navigation-links.md) | Обязательно | `ui/admin-interface` |
| `interface.search-suggestions` | [Подсказки поиска при фокусе](../registry/standards/ui/admin-interface/rules/search-suggestions.md) | Рекомендуется | `ui/admin-interface` |
| `interface.fuzzy-search` | [Поиск с учетом опечаток](../registry/standards/ui/admin-interface/rules/fuzzy-search.md) | Рекомендуется | `ui/admin-interface` |

## Фреймворки и CMS

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `frameworks.laravel-validation` | [Laravel: Form Request и Policy](../registry/standards/frameworks/platforms/rules/laravel-validation.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.laravel-jobs` | [Laravel: транзакция и afterCommit](../registry/standards/frameworks/platforms/rules/laravel-jobs.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.laravel-eloquent` | [Laravel: Eloquent и N+1](../registry/standards/frameworks/platforms/rules/laravel-eloquent.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.bitrix-local` | [1С-Битрикс: /local и расширения](../registry/standards/frameworks/platforms/rules/bitrix-local.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.bitrix-transactions` | [1С-Битрикс: D7-транзакции](../registry/standards/frameworks/platforms/rules/bitrix-transactions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.bitrix-cache` | [1С-Битрикс: ключ кеша и инвалидация](../registry/standards/frameworks/platforms/rules/bitrix-cache.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.bitrix24-webhook` | [Bitrix24: серверный вебхук](../registry/standards/frameworks/platforms/rules/bitrix24-webhook.md) | Обязательно | `frameworks/platforms` |
| `frameworks.bitrix24-limits` | [Bitrix24: лимиты и повтор запросов](../registry/standards/frameworks/platforms/rules/bitrix24-limits.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.django-atomic` | [Django: atomic и on_commit](../registry/standards/frameworks/platforms/rules/django-atomic.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.fastapi-io` | [FastAPI: async и блокирующий I/O](../registry/standards/frameworks/platforms/rules/fastapi-io.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.nestjs-validation` | [NestJS: ValidationPipe и DTO](../registry/standards/frameworks/platforms/rules/nestjs-validation.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.vue-computed` | [Vue: computed и производное состояние](../registry/standards/frameworks/platforms/rules/vue-computed.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.nuxt-ssr-data` | [Nuxt: useAsyncData и SSR](../registry/standards/frameworks/platforms/rules/nuxt-ssr-data.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.sveltekit-server` | [SvelteKit: server-only modules](../registry/standards/frameworks/platforms/rules/sveltekit-server.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.wordpress-permissions` | [WordPress: capabilities и nonce](../registry/standards/frameworks/platforms/rules/wordpress-permissions.md) | Обязательно | `frameworks/platforms` |
| `frameworks.bitrix-autoload` | [1С-Битрикс: namespace, загрузка классов и обработчики](../registry/standards/frameworks/platforms/rules/bitrix-autoload.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.bitrix-scheduling` | [1С-Битрикс: агенты, cron и безопасный CLI](../registry/standards/frameworks/platforms/rules/bitrix-scheduling.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.laravel-conventions` | [Laravel: начальная структура и регистрация кода](../registry/standards/frameworks/platforms/rules/laravel-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.django-conventions` | [Django: приложения, имена и безопасная инициализация](../registry/standards/frameworks/platforms/rules/django-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.fastapi-conventions` | [FastAPI: routers, модели и жизненный цикл ресурсов](../registry/standards/frameworks/platforms/rules/fastapi-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.nestjs-conventions` | [NestJS: модули, имена и внедрение зависимостей](../registry/standards/frameworks/platforms/rules/nestjs-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.vue-conventions` | [Vue: SFC, props, события и имена компонентов](../registry/standards/frameworks/platforms/rules/vue-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.nuxt-conventions` | [Nuxt: структура app/server и правила регистрации](../registry/standards/frameworks/platforms/rules/nuxt-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.sveltekit-conventions` | [SvelteKit: файлы маршрутов и контекст запроса](../registry/standards/frameworks/platforms/rules/sveltekit-conventions.md) | Рекомендуется | `frameworks/platforms` |
| `frameworks.wordpress-conventions` | [WordPress: плагины, имена и жизненный цикл hooks](../registry/standards/frameworks/platforms/rules/wordpress-conventions.md) | Рекомендуется | `frameworks/platforms` |

## Интеграции

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `integrations.timeouts` | [Тайм-ауты интеграций](../registry/standards/integrations/external/rules/timeouts.md) | Обязательно | `integrations/external` |
| `integrations.retries` | [Retry и backoff](../registry/standards/integrations/external/rules/retries.md) | Рекомендуется | `integrations/external` |
| `integrations.oauth` | [OAuth и PKCE](../registry/standards/integrations/external/rules/oauth.md) | Обязательно | `integrations/external` |
| `integrations.webhooks` | [Подпись вебхуков](../registry/standards/integrations/external/rules/webhooks.md) | Обязательно | `integrations/external` |
| `integrations.mcp` | [Авторизация MCP](../registry/standards/integrations/external/rules/mcp.md) | Обязательно | `integrations/external` |
| `integrations.files` | [Загрузка файлов](../registry/standards/integrations/external/rules/files.md) | Обязательно | `integrations/external` |

## Кеш и фоновые задачи

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `caching.source-of-truth` | [Источник истины кеша](../registry/standards/backend/worker/rules/source-of-truth.md) | Рекомендуется | `backend/worker` |
| `caching.freshness` | [TTL и инвалидация](../registry/standards/backend/worker/rules/freshness.md) | Рекомендуется | `backend/worker` |
| `caching.private-cache` | [Изоляция кеша](../registry/standards/backend/worker/rules/private-cache.md) | Обязательно | `backend/worker` |
| `caching.idempotent-worker` | [Идемпотентность worker](../registry/standards/backend/worker/rules/idempotent-worker.md) | Обязательно | `backend/worker` |
| `caching.outbox` | [Transactional outbox](../registry/standards/backend/worker/rules/outbox.md) | По условию | `backend/worker` |
| `caching.dead-letter` | [Dead-letter queue](../registry/standards/backend/worker/rules/dead-letter.md) | Рекомендуется | `backend/worker` |
| `caching.redis-persistence` | [Redis: persistence и восстановление](../registry/standards/backend/worker/rules/redis-persistence.md) | Рекомендуется | `backend/worker` |

## Безопасность

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `security.object-access` | [Object-level authorization](../registry/standards/security/no-secrets/rules/object-access.md) | Обязательно | `security/no-secrets` |
| `security.secrets` | [Управление секретами](../registry/standards/security/no-secrets/rules/secrets.md) | Обязательно | `security/no-secrets` |
| `security.sql-injection` | [SQL-параметры](../registry/standards/security/no-secrets/rules/sql-injection.md) | Обязательно | `security/no-secrets` |
| `security.ssrf` | [SSRF-защита](../registry/standards/security/no-secrets/rules/ssrf.md) | Обязательно | `security/no-secrets` |
| `security.redaction` | [Маскирование секретов в логах](../registry/standards/security/no-secrets/rules/redaction.md) | Обязательно | `security/no-secrets` |
| `security.supply-chain` | [Software supply chain](../registry/standards/security/no-secrets/rules/supply-chain.md) | Рекомендуется | `security/no-secrets` |
| `security.resource-limits` | [Лимиты ресурсов](../registry/standards/security/no-secrets/rules/resource-limits.md) | Обязательно | `security/no-secrets` |
| `security.authentication` | [Аутентификация: вход, факторы и восстановление](../registry/standards/security/no-secrets/rules/authentication.md) | Обязательно | `security/no-secrets` |
| `security.sessions` | [Сессии: выдача, срок и отзыв](../registry/standards/security/no-secrets/rules/sessions.md) | Обязательно | `security/no-secrets` |
| `security.output-encoding` | [Браузер: безопасный вывод текста и HTML](../registry/standards/security/no-secrets/rules/output-encoding.md) | Обязательно | `security/no-secrets` |
| `security.csrf` | [Браузер: защита изменяющих запросов от CSRF](../registry/standards/security/no-secrets/rules/csrf.md) | Обязательно | `security/no-secrets` |
| `security.vulnerability-response` | [Уязвимости: прием сообщений и выпуск исправлений](../registry/standards/security/no-secrets/rules/vulnerability-response.md) | Обязательно | `security/no-secrets` |

## Тестирование

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `testing.risk` | [Тестирование по риску](../registry/standards/testing/tdd-strict/rules/risk.md) | Рекомендуется | `testing/tdd-strict` |
| `testing.regression` | [Регрессионные тесты](../registry/standards/testing/tdd-strict/rules/regression.md) | Рекомендуется | `testing/tdd-strict` |
| `testing.integration` | [Интеграционные тесты](../registry/standards/testing/tdd-strict/rules/integration.md) | Рекомендуется | `testing/tdd-strict` |
| `testing.critical-paths` | [End-to-end тесты](../registry/standards/testing/tdd-strict/rules/critical-paths.md) | Рекомендуется | `testing/tdd-strict` |
| `testing.honest-checks` | [Статус проверок](../registry/standards/testing/tdd-strict/rules/honest-checks.md) | Обязательно | `testing/tdd-strict` |
| `testing.determinism` | [Детерминизм тестов](../registry/standards/testing/tdd-strict/rules/determinism.md) | Рекомендуется | `testing/tdd-strict` |

## Выпуск и эксплуатация

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `operations.correlation` | [Correlation ID](../registry/standards/observability/three-signals/rules/correlation.md) | Рекомендуется | `observability/three-signals` |
| `operations.http-spans` | [HTTP spans](../registry/standards/observability/three-signals/rules/http-spans.md) | Рекомендуется | `observability/three-signals` |
| `operations.signals` | [Observability](../registry/standards/observability/three-signals/rules/signals.md) | Рекомендуется | `observability/three-signals` |
| `operations.slo` | [SLO и error budget](../registry/standards/observability/three-signals/rules/slo.md) | Рекомендуется | `observability/three-signals` |
| `operations.immutable-release` | [Неизменяемый артефакт](../registry/standards/delivery/release/rules/immutable-release.md) | Обязательно | `delivery/release` |
| `operations.rollback` | [Rollback](../registry/standards/delivery/release/rules/rollback.md) | Обязательно | `delivery/release` |
| `operations.restore` | [Backup и restore](../registry/standards/delivery/release/rules/restore.md) | Обязательно | `delivery/release` |
| `operations.config` | [Конфигурация окружения](../registry/standards/delivery/release/rules/config.md) | Обязательно | `delivery/release` |
| `operations.incident` | [Incident runbook](../registry/standards/delivery/release/rules/incident.md) | Рекомендуется | `delivery/release` |

## Мобильные приложения

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `mobile.secure-storage` | [Keychain и Keystore](../registry/standards/mobile/react-native/rules/secure-storage.md) | Обязательно | `mobile/react-native` |
| `mobile.deep-links` | [Deep links](../registry/standards/mobile/react-native/rules/deep-links.md) | Обязательно | `mobile/react-native` |
| `mobile.offline` | [Офлайн-синхронизация](../registry/standards/mobile/react-native/rules/offline.md) | Рекомендуется | `mobile/react-native` |
| `mobile.native-release` | [Мобильный релиз](../registry/standards/mobile/react-native/rules/native-release.md) | Рекомендуется | `mobile/react-native` |
| `mobile.react-native-conventions` | [React Native: компоненты, типы и платформенный профиль](../registry/standards/mobile/react-native/rules/react-native-conventions.md) | Рекомендуется | `mobile/react-native` |

## Платежи

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `payments.payment-truth` | [Подтверждение оплаты](../registry/standards/payments/stripe/rules/payment-truth.md) | Обязательно | `payments/stripe` |
| `payments.payment-events` | [Платежные события](../registry/standards/payments/stripe/rules/payment-events.md) | Обязательно | `payments/stripe` |
| `payments.card-data` | [Платежные данные](../registry/standards/payments/stripe/rules/card-data.md) | Обязательно | `payments/stripe` |
| `payments.reconciliation` | [Платежная сверка](../registry/standards/payments/stripe/rules/reconciliation.md) | Рекомендуется | `payments/stripe` |
| `payments.test-live` | [Платежные окружения](../registry/standards/payments/stripe/rules/test-live.md) | Обязательно | `payments/stripe` |

## Языки и базовые соглашения

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `languages.go-naming` | [Go: имена, экспорт и инициализмы](../registry/standards/languages/go/rules/go-naming.md) | Рекомендуется | `languages/go` |
| `languages.go-imports` | [Go: явные imports и границы пакета](../registry/standards/languages/go/rules/go-imports.md) | Рекомендуется | `languages/go` |
| `languages.go-types` | [Go: типы и проверка значений на границе](../registry/standards/languages/go/rules/go-types.md) | Рекомендуется | `languages/go` |
| `languages.go-toolchain` | [Go: версия toolchain и граф модулей](../registry/standards/languages/go/rules/go-toolchain.md) | Рекомендуется | `languages/go` |
| `languages.python-naming` | [Python: имена классов, функций и констант](../registry/standards/languages/python/rules/python-naming.md) | Рекомендуется | `languages/python` |
| `languages.python-imports` | [Python: явные imports и управляемая инициализация](../registry/standards/languages/python/rules/python-imports.md) | Рекомендуется | `languages/python` |
| `languages.python-types` | [Python: аннотации и runtime-валидация](../registry/standards/languages/python/rules/python-types.md) | Рекомендуется | `languages/python` |
| `languages.python-toolchain` | [Python: интерпретатор, окружение и зависимости](../registry/standards/languages/python/rules/python-toolchain.md) | Рекомендуется | `languages/python` |
| `languages.javascript-naming` | [Имена в JavaScript и TypeScript](../registry/standards/languages/typescript/rules/javascript-naming.md) | Рекомендуется | `languages/typescript` |
| `languages.bindings` | [Привязки const и let](../registry/standards/languages/typescript/rules/bindings.md) | Рекомендуется | `languages/typescript` |
| `languages.runtime-boundaries` | [Проверка внешних данных в TypeScript](../registry/standards/languages/typescript/rules/runtime-boundaries.md) | Обязательно | `languages/typescript` |
| `languages.nullability` | [Отсутствие, null и undefined](../registry/standards/languages/typescript/rules/nullability.md) | Рекомендуется | `languages/typescript` |
| `languages.promise-errors` | [Результаты и ошибки Promise](../registry/standards/languages/typescript/rules/promise-errors.md) | Обязательно | `languages/typescript` |
| `languages.module-boundaries` | [Модули и разрешение импортов](../registry/standards/languages/typescript/rules/module-boundaries.md) | Рекомендуется | `languages/typescript` |
| `languages.php-types` | [PHP: типы и проверка входных значений](../registry/standards/languages/php/rules/php-types.md) | Рекомендуется | `languages/php` |
| `languages.php-naming` | [PHP: именование и границы PSR-1](../registry/standards/languages/php/rules/php-naming.md) | Рекомендуется | `languages/php` |
| `languages.php-autoload` | [PHP: namespace, PSR-4 и автозагрузка](../registry/standards/languages/php/rules/php-autoload.md) | Рекомендуется | `languages/php` |

## SEO и приемка публичного сайта

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `seo.page-titles` | [Заголовок страницы title](../registry/standards/seo/site-audit/rules/page-titles.md) | Обязательно | `seo/site-audit` |
| `seo.heading-structure` | [Структура заголовков H1–H6](../registry/standards/seo/site-audit/rules/heading-structure.md) | Рекомендуется | `seo/site-audit` |
| `seo.meta-description` | [Описание страницы meta description](../registry/standards/seo/site-audit/rules/meta-description.md) | Рекомендуется | `seo/site-audit` |
| `seo.favicon` | [Favicon и идентификация сайта](../registry/standards/seo/site-audit/rules/favicon.md) | Обязательно | `seo/site-audit` |
| `seo.indexability` | [Индексирование и исключение страниц](../registry/standards/seo/site-audit/rules/indexability.md) | Обязательно | `seo/site-audit` |
| `seo.canonical-urls` | [Канонические URL](../registry/standards/seo/site-audit/rules/canonical-urls.md) | Обязательно | `seo/site-audit` |
| `seo.status-redirects` | [HTTP-статусы и перенаправления страниц](../registry/standards/seo/site-audit/rules/status-redirects.md) | Обязательно | `seo/site-audit` |
| `seo.sitemaps` | [Sitemap и даты изменения](../registry/standards/seo/site-audit/rules/sitemaps.md) | Рекомендуется | `seo/site-audit` |
| `seo.crawlable-links` | [Навигационные ссылки и достижимость страниц](../registry/standards/seo/site-audit/rules/crawlable-links.md) | Обязательно | `seo/site-audit` |
| `seo.rendered-content` | [Доступность содержания при рендеринге](../registry/standards/seo/site-audit/rules/rendered-content.md) | Обязательно | `seo/site-audit` |
| `seo.images` | [Изображения в публичном содержании](../registry/standards/seo/site-audit/rules/images.md) | Обязательно | `seo/site-audit` |
| `seo.structured-data` | [Структурированные данные](../registry/standards/seo/site-audit/rules/structured-data.md) | По условию | `seo/site-audit` |
| `seo.pagination-facets` | [Пагинация и индексирование фильтров](../registry/standards/seo/site-audit/rules/pagination-facets.md) | Обязательно | `seo/site-audit` |
| `seo.multilingual` | [Языковые версии и hreflang](../registry/standards/seo/site-audit/rules/multilingual.md) | По условию | `seo/site-audit` |
| `seo.performance` | [Производительность публичного сайта](../registry/standards/seo/site-audit/rules/performance.md) | Рекомендуется | `seo/site-audit` |
| `seo.mobile-content` | [Мобильное содержание и метаданные](../registry/standards/seo/site-audit/rules/mobile-content.md) | Обязательно | `seo/site-audit` |
| `seo.release-audit` | [Приемка публичного сайта перед релизом](../registry/standards/seo/site-audit/rules/release-audit.md) | Обязательно | `seo/site-audit` |

## Персональные данные и требования РФ

| ID | Правило | Уровень | Модуль |
| --- | --- | --- | --- |
| `legal-ru.processing-basis` | [Правовое основание обработки данных](../registry/standards/legal/russia-web/rules/processing-basis.md) | Обязательно | `legal/russia-web` |
| `legal-ru.privacy-policy` | [Публикация политики обработки данных](../registry/standards/legal/russia-web/rules/privacy-policy.md) | Обязательно | `legal/russia-web` |
| `legal-ru.separate-consent` | [Отдельное согласие на обработку](../registry/standards/legal/russia-web/rules/separate-consent.md) | Обязательно | `legal/russia-web` |
| `legal-ru.consent-evidence` | [Доказательство и отзыв согласия](../registry/standards/legal/russia-web/rules/consent-evidence.md) | Обязательно | `legal/russia-web` |
| `legal-ru.marketing-consent` | [Согласие на рекламные сообщения](../registry/standards/legal/russia-web/rules/marketing-consent.md) | Обязательно | `legal/russia-web` |
| `legal-ru.cookies-trackers` | [Cookies, аналитика и внешние трекеры](../registry/standards/legal/russia-web/rules/cookies-trackers.md) | Обязательно | `legal/russia-web` |
| `legal-ru.localization` | [Локализация баз при сборе данных](../registry/standards/legal/russia-web/rules/localization.md) | Обязательно | `legal/russia-web` |
| `legal-ru.cross-border` | [Трансграничная передача](../registry/standards/legal/russia-web/rules/cross-border.md) | Обязательно | `legal/russia-web` |
| `legal-ru.processors` | [Поручение обработки и подрядчики](../registry/standards/legal/russia-web/rules/processors.md) | Обязательно | `legal/russia-web` |
| `legal-ru.operator-notification` | [Уведомление оператора и ответственность](../registry/standards/legal/russia-web/rules/operator-notification.md) | Обязательно | `legal/russia-web` |
| `legal-ru.retention` | [Минимизация и сроки хранения](../registry/standards/legal/russia-web/rules/retention.md) | Обязательно | `legal/russia-web` |
| `legal-ru.subject-requests` | [Обращения субъектов и отзыв](../registry/standards/legal/russia-web/rules/subject-requests.md) | Обязательно | `legal/russia-web` |
| `legal-ru.public-distribution` | [Публикация персональных данных](../registry/standards/legal/russia-web/rules/public-distribution.md) | Обязательно | `legal/russia-web` |
| `legal-ru.incidents` | [Инциденты с персональными данными](../registry/standards/legal/russia-web/rules/incidents.md) | Обязательно | `legal/russia-web` |
