# apps/api

Go backend placeholder for the active `go-next-postgres` stack.

## Scope

- Minimal package metadata and entrypoint.
- Target backend architecture is documented in active standards.
- Auth and company modules are contract goals, not fully scaffolded runtime code in this starter template.

## Engineering Contract

- `standards/active/BACKEND.md`
- `standards/active/TESTING.md`
- `standards/active/API.md`
- `standards/active/SECURITY.md`
- `standards/active/OBSERVABILITY.md`

## Target Package Layout

```text
cmd/api/main.go
internal/platform/httpserver/router.go
internal/modules/auth/transport/http/routes.go
internal/modules/auth/transport/http/<endpoint>_handler.go
internal/modules/company/transport/http/routes.go
internal/modules/company/transport/http/<endpoint>_handler.go
```

Create this layout as soon as backend behavior is implemented. Until then this template is intentionally `partial`.

## Rules When Runtime Code Is Added

1. One endpoint = one handler file.
2. Module routes live in module folders, not in a global giant router.
3. Business logic lives in services.
4. Numeric limits from `standards/active/BACKEND.md` apply when a real checker exists or during review.
5. New backend behavior ships with unit and integration tests.
