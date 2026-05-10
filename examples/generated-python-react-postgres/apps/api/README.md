# apps/api

Python/FastAPI backend for the active `python-react-postgres` stack.

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
pyproject.toml
app/main.py
app/platform/http/router.py
app/modules/auth/router.py
app/modules/auth/handlers/<endpoint>_handler.py
app/modules/company/router.py
app/modules/company/handlers/<endpoint>_handler.py
```

## Mandatory rules
1. One endpoint = one handler file.
2. Module routes live in module folder, not in global giant router.
3. Business logic lives in service layer only.
4. Numeric hard limits from `standards/active/BACKEND.md` are required (file `250`, function `45`, handler `35`, routes `120`).
5. New backend behavior must ship with unit + integration tests.
