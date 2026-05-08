# 16. Unified Auth + Sessions + Deep Linking (Web, Qt, Android)

Этот документ фиксирует каноническую модель авторизации Python React Postgres Framework:
- один backend auth-контур для всех клиентов;
- web, Qt desktop и Android WebView работают по единым правилам;
- поддержаны email/password, Telegram, Google, Yandex, VK;
- управление сессиями доступно пользователю: список, завершение одной, завершение всех кроме текущей;
- предусмотрен сценарий входа после долгого простоя (до года и более), если device credential не отозван и не истек.

Incident companion:
- `docs/26-SECURITY-INCIDENT-RUNBOOK.md`

## 1) Границы и принципы

1. Один аккаунт пользователя (`users`) может иметь несколько внешних identity (`auth_identities`).
2. Аутентификация всегда заканчивается созданием server-side сессии (`sessions`).
3. Для долгоживущего входа в нативных клиентах используется отдельный credential (`device_credentials`) с ротацией.
4. Нейминг БД обязательный: таблица-сущность во множественном числе, PK/FK строго `<entity>_id uuid`.
5. Plaintext токены/секреты в БД запрещены, храним только hash (и, при необходимости, зашифрованные provider token blobs).

## 2) Канонические таблицы и поля

Все ключи в этом блоке обязаны следовать контракту `docs/07-DB-NAMING-CONVENTIONS.md`.

### users
- `user_id uuid pk`
- `email`, `password_hash`, `is_activated`
- `current_company_id uuid nullable`
- `created_at`, `updated_at`, `deleted_at`

### auth_identities
Связь внутреннего пользователя с внешним провайдером.

- `auth_identity_id uuid pk`
- `user_id uuid fk -> users.user_id`
- `provider text` (`password|telegram|google|yandex|vk`)
- `provider_subject text` (уникальный user id провайдера)
- `provider_email text null`
- `provider_login text null`
- `is_primary bool`
- `created_at`, `updated_at`, `deleted_at`

Ограничения:
- unique (`provider`, `provider_subject`) для активных записей;
- один `user_id` может иметь несколько providers.

### sessions
Серверные логические сессии для всех клиентов.

- `session_id uuid pk`
- `user_id uuid fk -> users.user_id`
- `session_token_hash text unique`
- `refresh_token_hash text unique`
- `client_type text` (`web|qt-windows|qt-macos|qt-linux|android-webview|telegram-web`)
- `device_label text`
- `ip_address inet`, `user_agent text`
- `created_at`, `last_seen_at`, `expires_at`, `revoked_at`, `revoked_reason`

### device_credentials
Долгоживущие учетные данные устройства для "вернуться через год".

- `device_credential_id uuid pk`
- `user_id uuid fk -> users.user_id`
- `session_id uuid null fk -> sessions.session_id`
- `device_platform text`
- `device_fingerprint_hash text`
- `credential_hash text unique`
- `issued_at`, `last_used_at`, `rotate_after`, `expires_at`, `revoked_at`

Смысл:
- credential хранится на клиенте в secure storage;
- при успешном restore credential ротируется (старый hash больше невалиден);
- revoke credential мгновенно отключает long-lived restore для конкретного устройства.

### auth_events
Аудит входов/отказов/revoke/restore, только логовый слой.

## 3) Версионность данных

Обязательная версионность полных snapshot-записей распространяется на:
- `users` -> `user_versions`
- `companies` -> `company_versions`
- `company_memberships` -> `company_membership_versions`
- `auth_identities` -> `auth_identity_versions`
- `device_credentials` -> `device_credential_versions`

`auth_events` исключена из версионности как логовая таблица.
`sessions` трактуется как operational security state: хранится полноценно в БД, участвует в аудитах и revoke-процессах, но не входит в бизнес-versioning по умолчанию.

## 4) Единый API-контракт (v1)

Базовые:
- `POST /api/v1/auth/register`
- `POST /api/v1/auth/activate`
- `POST /api/v1/auth/login` (email/password)
- `POST /api/v1/auth/logout` (текущая сессия)
- `GET /api/v1/auth/me`
- `POST /api/v1/auth/refresh`

OAuth/OpenID/соцвход:
- `GET /api/v1/auth/oauth/{provider}/start`
- `GET /api/v1/auth/oauth/{provider}/callback`
- `POST /api/v1/auth/telegram/miniapp` (валидация `initData`)
- `POST /api/v1/auth/native/exchange` (code + PKCE verifier после deep link callback)

Сессии:
- `GET /api/v1/auth/sessions`
- `DELETE /api/v1/auth/sessions/{session_id}`
- `POST /api/v1/auth/sessions/revoke-others`

Компания:
- `POST /api/v1/companies/{company_id}/switch`

## 5) Потоки авторизации

### 5.1 Web (обычный браузер)
1. Пользователь проходит login/password или OAuth.
2. Backend создает `sessions` запись.
3. В браузер ставится secure HttpOnly refresh-cookie (first-party).
4. Access token короткоживущий; refresh обновляется ротацией.

### 5.2 Qt desktop (Windows/macOS/Linux) через web + deep link
1. Desktop клиент генерирует `state` + PKCE (`code_verifier`, `code_challenge`).
2. Открывает системный браузер: `/auth/oauth/{provider}/start?...`.
3. После успешного входа backend редиректит в deep link `aiapp://auth/callback?...`.
4. Клиент принимает callback, вызывает `POST /api/v1/auth/native/exchange` с `code_verifier`.
5. Получает сессию + `device_credential`, сохраняет credential в OS secure storage.

### 5.3 Android (WebView-first)
1. Основной UI работает в WebView.
2. Для входа применяем те же backend endpoints, что и web.
3. Для устойчивого native restore используем bridge к Android Keystore и `device_credentials`.
4. При необходимости deep link используется App Link/custom scheme с тем же exchange контрактом.

### 5.4 Telegram
1. В Telegram Web App backend валидирует `initData` подпись.
2. На основе Telegram identity создается/находится `auth_identities` запись.
3. Далее создается обычная `sessions` запись и действует тот же session management.

## 6) "Открыл приложение через год" (долгий простой)

Цель: пользователь не теряет вход после длительного простоя при сохраненном secure storage.

Правила:
- Access token: короткий TTL (например 15 минут).
- Refresh/session: ротация и серверная проверка revoke/expiry.
- Device credential: длинный TTL (например 400 дней) + sliding extension + обязательная ротация на restore.

Сценарий restore:
1. Клиент стартует и читает `device_credential` из secure storage.
2. Вызывает restore endpoint (через `POST /api/v1/auth/native/exchange` или отдельный `POST /api/v1/auth/device/restore`).
3. Backend проверяет hash, expiry, revoke, fingerprint policy.
4. Если ок: выпускает новую сессию и новый credential; старый credential инвалидируется.
5. Если не ок: клиент переводится в полный login flow.

Для web:
- работает только пока браузер сохранил cookie/storage;
- если пользователь чистил storage или браузер принудительно удалил данные, нужен повторный вход.

## 7) Управление сессиями (UI + backend)

`GET /api/v1/auth/sessions` возвращает список активных/недавно активных сессий:
- `session_id`, `client_type`, `device_label`, `ip_address`, `created_at`, `last_seen_at`, `is_current`.

Операции:
- `DELETE /api/v1/auth/sessions/{session_id}` -> завершает конкретную сессию.
- `POST /api/v1/auth/sessions/revoke-others` -> завершает все сессии текущего пользователя, кроме текущей.

Поведение:
- revoke проставляет `revoked_at`;
- refresh в revoked сессии невозможен;
- доступ по уже выданному access token прекращается максимум через его короткий TTL.

## 8) Где это лежит в монорепе

- ` apps/api/app/modules/auth/*` — core auth logic, providers, sessions, restore.
- `apps/api/app/modules/company/*` — switch active company.
- `packages/contracts/auth/*` — контракты auth/session endpoints.
- `apps/web/*` — web auth UI + session management UI.
- `apps/desktop/qt/*` — deep link handler, secure storage adapter, auth bootstrap.
- `apps/mobile/android/*` — WebView shell + native bridge к Keystore/deep link.

## 9) Непереговорные инварианты

1. Все entity key поля строго `<entity>_id uuid`.
2. OAuth state/PKCE валидация обязательна для native/web OAuth flows.
3. Любая клиентская сессия видна в `GET /auth/sessions`.
4. Пользователь всегда может завершить отдельную сессию и все остальные.
5. Удаленный revoke должен быть эффективен на всех платформах.
6. Auth изменения без обновления docs/05 и этого документа не принимаются.
