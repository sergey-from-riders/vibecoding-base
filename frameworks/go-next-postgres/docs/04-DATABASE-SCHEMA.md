# 04. Схема БД (MVP: Auth + Company Context)

## Версия и подход
- PostgreSQL 18+
- SQL migrations (`up/down`)
- append-only history

## Обязательная версионность боевых данных
- Все боевые сущности обязаны иметь `*_versions` таблицы.
- На каждое изменение (`insert`/`update`/`delete`) сохраняется полная snapshot-запись.
- Версионность обязательна даже если изменилось одно поле.
- Лог-таблицы из этого правила исключены.

Политика и детали: [15-DATA-VERSIONING-AND-DIFF.md](15-DATA-VERSIONING-AND-DIFF.md)

## Нейминг ключей (критично)
Для этого проекта действует жесткое правило:
- сущность всегда имеет UUID-идентификатор;
- имя ключа всегда `<entity>_id`.

Пример:
- таблица `users` -> ключ `user_id uuid`;
- таблица `companies` -> ключ `company_id uuid`.

Полный обязательный стандарт: [07-DB-NAMING-CONVENTIONS.md](07-DB-NAMING-CONVENTIONS.md)

## Таблицы

### 1) users
Каноническая таблица пользователей.

Ключевые поля:
- `user_id uuid pk`
- `email citext` (partial unique для active users)
- `password_hash text`
- `is_activated bool`
- `current_company_id uuid nullable`
- activation/reset token hash поля
- `created_at`, `updated_at`, `deleted_at`

### 2) companies
Компании (tenant root).

Ключевые поля:
- `company_id uuid pk`
- `owner_user_id uuid fk -> users.user_id`
- `slug text unique`
- `name text`
- `status` (`active|suspended|archived`)

### 3) company_memberships
Membership пользователей в компаниях.

Ключевые поля:
- `(company_id, user_id)` composite pk
- `role` (`owner|admin|member`)
- `permissions jsonb`
- `invited_by`, `invited_at`

### 4) auth_identities
Связи внутреннего пользователя с внешними провайдерами входа.

Ключевые поля:
- `auth_identity_id uuid pk`
- `user_id uuid fk -> users.user_id`
- `provider text` (`password|telegram|google|yandex|vk`)
- `provider_subject text`
- `provider_email text nullable`
- `provider_login text nullable`
- `is_primary bool`
- `created_at`, `updated_at`, `deleted_at`

Ограничения:
- unique (`provider`, `provider_subject`) для активных записей;
- один пользователь может иметь несколько identity.

### 5) sessions
Сессии пользователей (все платформы: web, qt, android webview, telegram web).

Ключевые поля:
- `session_id uuid pk`
- `user_id uuid fk -> users.user_id`
- `session_token_hash text unique`
- `refresh_token_hash text unique`
- `client_type text`
- `device_label text`
- `user_agent text`, `ip_address inet`
- `expires_at`, `revoked_at`, `last_seen_at`
- `created_at`, `updated_at`

### 6) device_credentials
Долгоживущие device credentials для восстановления авторизации после долгого простоя.

Ключевые поля:
- `device_credential_id uuid pk`
- `user_id uuid fk -> users.user_id`
- `session_id uuid nullable fk -> sessions.session_id`
- `device_platform text`
- `device_fingerprint_hash text`
- `credential_hash text unique`
- `issued_at`, `last_used_at`, `rotate_after`, `expires_at`, `revoked_at`

### 7) auth_events
Аудит auth-событий.

Ключевые поля:
- `auth_event_id uuid pk`
- `user_id uuid`
- `event_type text`
- `payload jsonb`
- `created_at`

### 8) business version tables
Для боевых сущностей используются отдельные таблицы версий:
- `user_versions`
- `company_versions`
- `company_membership_versions`
- `auth_identity_versions`
- `device_credential_versions`

Общий формат:
- `*_version_id uuid pk`
- `<entity>_id uuid`
- `version_no int`
- `operation_type` (`insert|update|delete`)
- `snapshot jsonb` (полная запись)
- `changed_at`, `changed_by_user_id`, `request_id`

## Ключевые ограничения
- `users.current_company_id` -> `companies.company_id` (`ON DELETE SET NULL`)
- switch компании разрешен только если есть membership (или owner)
- plaintext токены/секреты в БД запрещены (только hash)
- боевые таблицы имеют триггеры на запись версий
- `auth_events` (и другие логи) не входят в версионность бизнес-сущностей

## Индексы MVP
- users: email(active), current_company_id
- memberships: user_id и company_id
- auth_identities: `(provider, provider_subject)` unique, `user_id`
- sessions: `session_token_hash` unique, `refresh_token_hash` unique, `(user_id, revoked_at, expires_at)`
- device_credentials: `credential_hash` unique, `(user_id, revoked_at, expires_at)`, `device_fingerprint_hash`
- auth_events: `(user_id, created_at desc)`
- version tables: индексы по entity id и `changed_at desc`
