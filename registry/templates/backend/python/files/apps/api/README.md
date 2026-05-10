# apps/api

Python backend for Python React Postgres Framework.

## Scope (current phase)
- Auth
- Switch Active Company

## Engineering contract
- `docs/18-PYTHON-BACKEND-ENGINEERING-STANDARD.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md`
- `docs/05-AUTH-COMPANY-SWITCH.md`
- `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`

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
4. Numeric hard limits from docs/18 are required (file `250`, function `45`, handler `35`, routes `120`).
5. New backend behavior must ship with unit + integration tests.
