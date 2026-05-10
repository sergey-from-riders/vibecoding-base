<!-- Generated from registry/standards/backend/python@1.0.0. Update the registry standard, then regenerate. -->

# 18. Python Backend Engineering Standard (Strict Numeric Rules)

Этот стандарт обязателен для `apps/api`.

## 1) Каноническая структура

```text
apps/api/
├─ pyproject.toml
├─ app/
│  ├─ main.py
│  ├─ platform/
│  │  ├─ http/router.py
│  │  ├─ http/middleware/*.py
│  │  ├─ problem/writer.py
│  │  └─ db/*.py
│  └─ modules/
│     ├─ auth/
│     │  ├─ router.py
│     │  ├─ handlers/*_handler.py
│     │  ├─ service/*.py
│     │  └─ repository/*.py
│     └─ company/
│        ├─ router.py
│        ├─ handlers/*_handler.py
│        ├─ service/*.py
│        └─ repository/*.py
└─ tests/
   ├─ unit/
   └─ integration/
```

## 2) Числовые лимиты (обязательные)

1. `MAX_PY_FILE_LINES = 250`
2. `MAX_FUNCTION_LINES = 45`
3. `MAX_HANDLER_LINES = 35`
4. `MAX_ROUTES_FILE_LINES = 120`
5. `MAX_FUNCTION_PARAMS = 5`
6. `MAX_NESTING_DEPTH = 3`
7. `MAX_CYCLOMATIC_COMPLEXITY = 10`
8. `MAX_HANDLER_DB_CALLS = 0`
9. `MAX_HANDLER_REPOSITORY_CALLS = 0`
10. `MAX_HANDLER_SERVICE_CALLS = 1`
11. `MAX_MODULE_ROUTES_PER_FILE = 12`
12. `MAX_COMMENT_RATIO_PERCENT = 8`
13. `MAX_GLOBAL_MUTABLE_STATE = 0`
14. `MAX_TODO_IN_MAIN_BRANCH = 0`
15. `MAX_UNTESTED_CHANGED_FILES = 0`

## 3) FastAPI router decomposition rules

1. `GLOBAL_ROUTER_FILES = 1` (`app/platform/http/router.py`)
2. `MODULE_ROUTER_FILES_MIN = 1` на каждый модуль
3. `ENDPOINTS_PER_HANDLER_FILE = 1`
4. `HANDLER_FILES_PER_MODULE_MIN = 1`
5. `ROUTES_WITHOUT_MODULE_OWNER = 0`

## 4) Handler contract rules

1. Parse input: `1`
2. Validate input through Pydantic models: `1`
3. Service call: `1`
4. Error mapping: `1`
5. Response write: `1`

Запрещено в handler:

1. SQL calls: `0`
2. Repository orchestration: `0`
3. Domain policy branches: `0`
4. Transaction control: `0`

## 5) Service contract rules

1. FastAPI imports in service package: `0`
2. DB driver imports in service package: `0`
3. Repository Protocols per service file: `<= 4`
4. Unit tests required per public service method: `>= 1`

## 6) Repository contract rules

1. Async DB boundary is explicit: `100%`
2. Non-UUID domain IDs: `0`
3. Direct FastAPI dependency in repository: `0`
4. Integration tests per repository method: `>= 1`

## 7) Team-readability rules

1. Dependency injection through constructors/factories: `1`
2. Hidden singleton mutable state: `0`
3. Public symbol count per file: `<= 12`
4. Distinct responsibilities per file: `1`

## 8) Test gates for backend module

1. Unit suite pass rate: `100%`
2. Integration suite pass rate: `100%`
3. Contract checks pass rate: `100%`
4. Migration up/down checks: `100%`
5. Critical auth/session/security tests pass: `100%`

## 9) Merge gate

Фича не принимается при любом нарушении:

1. Любой лимит из раздела 2: `> 0` нарушений
2. Любой пропущенный test gate: `> 0`
3. Любой giant router/handler file: `> 0`

## 10) Автоматическая проверка

1. Скрипт: `tools/scripts/check_python_limits.sh`
2. Команда: `tools/scripts/check_python_limits.sh apps/api`
3. Допустимое число нарушений: `0`
4. Код возврата при нарушениях: `1`

## 11) Связанные документы

1. `docs/17-TESTING-TDD-QUALITY-GATES.md`
2. `docs/05-AUTH-COMPANY-SWITCH.md`
3. `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`
4. `docs/07-DB-NAMING-CONVENTIONS.md`
5. `docs/99-REFERENCES.md`
