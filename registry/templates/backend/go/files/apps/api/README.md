# apps/api

Go backend for the active `go-next-postgres` stack.

## Scope (current phase)
- Auth
- Switch Active Company

## Engineering contract
- `standards/active/BACKEND.md`
- `standards/active/TESTING.md`
- `standards/active/API.md`
- `standards/active/SECURITY.md`
- `standards/active/OBSERVABILITY.md`

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
4. Numeric hard limits from `standards/active/BACKEND.md` are required (file `250`, function `40`, handler `35`, routes `100`).
5. New backend behavior must ship with unit + integration tests.
