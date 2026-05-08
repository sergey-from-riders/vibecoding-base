# 05. Модуль Auth + Switch Company

Этот документ фиксирует рабочий API-контракт MVP.
Полная архитектура, deep link и long-lived restore описаны в:
[16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md](16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md).

## API (v1)

### Auth core
- `POST /api/v1/auth/register`
- `POST /api/v1/auth/activate`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/logout`
- `POST /api/v1/auth/refresh`
- `GET /api/v1/auth/me`

### OAuth / social auth
- `GET /api/v1/auth/oauth/{provider}/start`
- `GET /api/v1/auth/oauth/{provider}/callback`
- `POST /api/v1/auth/telegram/miniapp`
- `POST /api/v1/auth/native/exchange` (Qt/Android deep link exchange)

### Session management
- `GET /api/v1/auth/sessions`
- `DELETE /api/v1/auth/sessions/{session_id}`
- `POST /api/v1/auth/sessions/revoke-others`

### Recovery
- `POST /api/v1/auth/password-reset/request`
- `POST /api/v1/auth/password-reset/confirm`

### Company context
- `GET /api/v1/companies`
- `POST /api/v1/companies`
- `POST /api/v1/companies/{company_id}/switch`

### API docs and testing assets
- `GET /api/v1/docs/openapi.json`
- `GET /api/v1/docs/openapi.yaml`
- `GET /api/v1/docs/endpoints`
- `GET /api/v1/docs/testing/postman`

## Auth flow (canonical)
1. Login/password или OAuth/social провайдер.
2. Backend находит/создает `users` + `auth_identities`.
3. Backend создает `sessions` запись.
4. Клиент получает auth state и запрашивает `me`.
5. `me` возвращает профиль + `current_company_id`.

## Session rules
- токены на сервере хранятся только в hash;
- у сессии есть TTL и revoke-механика;
- revoke одной сессии и revoke всех, кроме текущей, обязательны;
- список сессий обязателен (`GET /api/v1/auth/sessions`);
- expired/revoked session не может быть использована для refresh/доступа.

## Switch company flow
1. Client sends `POST /companies/{company_id}/switch`.
2. Backend validates membership/ownership.
3. Backend writes `users.current_company_id = {company_id}`.
4. Client refreshes `me` and invalidates company-scoped cache.

## Error model
Flat Problem payload:
- `status`, `title`, `detail`, `action`, `validate`, `request_id`

Mandatory response headers:
- `X-Request-Id`
- `X-App-Result` (`ok|fix_required|error`)
- `X-App-Action`
- `X-App-Validate`
- `Content-Language`

Typical statuses:
- `400` malformed auth payload or provider callback error
- `401` unauthenticated
- `403` no membership / forbidden provider operation
- `404` company or session not found
- `409` identity/link conflict
- `422` validation

## Test baseline
- Unit: auth service, provider adapters, company switch service
- Integration: auth endpoints + session management + switch endpoint
- Security: foreign company switch denied, revoked session denied, PKCE/state validation

## Incident companion
- `docs/26-SECURITY-INCIDENT-RUNBOOK.md`
