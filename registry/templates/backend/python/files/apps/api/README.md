# apps/api

Python/FastAPI backend placeholder for the active `python-react-postgres` stack.

## Scope

- Minimal package metadata and FastAPI app entrypoint.
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
pyproject.toml
app/main.py
app/platform/http/router.py
app/modules/auth/router.py
app/modules/auth/handlers/<endpoint>_handler.py
app/modules/company/router.py
app/modules/company/handlers/<endpoint>_handler.py
```

Create this layout as soon as backend behavior is implemented. Until then this template is intentionally `partial`.

## Rules When Runtime Code Is Added

1. One endpoint = one handler file.
2. Module routes live in module folders, not in a global giant router.
3. Business logic lives in services.
4. Numeric limits from `standards/active/BACKEND.md` apply when a real checker exists or during review.
5. New backend behavior ships with unit and integration tests.
