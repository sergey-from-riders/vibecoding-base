# apps/api

Go backend for Go Next Postgres Framework.

## Scope (current phase)
- Auth
- Switch Active Company

## Engineering contract
- `docs/18-GO-BACKEND-ENGINEERING-STANDARD.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md`
- `docs/05-AUTH-COMPANY-SWITCH.md`
- `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`

## Target package layout
```text
cmd/api/main.go
internal/platform/httpserver/router.go
internal/modules/auth/transport/http/routes.go
internal/modules/auth/transport/http/<endpoint>_handler.go
internal/modules/company/transport/http/routes.go
internal/modules/company/transport/http/<endpoint>_handler.go
```

## Mandatory rules
1. One endpoint = one handler file.
2. Module routes live in module folder, not in global giant router.
3. Business logic lives in service layer only.
4. Numeric hard limits from docs/18 are required (file `250`, function `40`, handler `35`, routes `100`).
5. New backend behavior must ship with unit + integration tests.
