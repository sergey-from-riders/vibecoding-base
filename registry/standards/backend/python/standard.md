# Python Backend Engineering Standard

This standard applies to `apps/api` when the active stack uses Python/FastAPI.

## May 2026 Baseline

1. Python baseline: `3.14.x`.
2. FastAPI projects use Pydantic v2 style models.
3. Prefer `uv` or another lockfile-producing workflow for reproducible installs.
4. Type checking is required when the project has runtime checks.
5. Free-threaded Python support means code must not rely on hidden mutable global state.

## Canonical Structure

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

## Numeric Limits

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

These limits are documented unless the generated project includes a real limits checker.

## FastAPI Router Decomposition

1. `GLOBAL_ROUTER_FILES = 1` (`app/platform/http/router.py`)
2. `MODULE_ROUTER_FILES_MIN = 1` per module
3. `ENDPOINTS_PER_HANDLER_FILE = 1`
4. `HANDLER_FILES_PER_MODULE_MIN = 1`
5. `ROUTES_WITHOUT_MODULE_OWNER = 0`

## Handler Contract

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

Handlers translate HTTP to application calls. Business policy lives in services.

## Service Contract

1. FastAPI imports in service package: `0`
2. DB driver imports in service package: `0`
3. Repository Protocols per service file: `<= 4`
4. Unit tests required per public service method: `>= 1`
5. Import-time I/O: `0`
6. Mutable module-level state: `0`
7. Domain exceptions have stable error codes.

Use explicit dependency injection through constructors/factories. Avoid magic globals and framework reach-through.

## Repository Contract

1. Async DB boundary is explicit: `100%`
2. Non-UUID domain IDs: `0`
3. Direct FastAPI dependency in repository: `0`
4. Integration tests per repository method: `>= 1`
5. SQL is parameterized: `100%`
6. Transactions are explicit and owned above repository methods unless the repository represents a single atomic operation.

## Runtime And Async Rules

1. No blocking network or DB calls inside async handlers.
2. Timeouts are explicit for outbound calls.
3. Background tasks have an owner, retry policy and observability.
4. Application startup/shutdown uses FastAPI lifespan patterns.
5. Settings are typed and loaded through one config module.
6. Secrets are never read directly in feature code.

## Type And Tooling Expectations

Recommended gates when runtime checks exist:

1. `ruff format` or equivalent formatter;
2. `ruff check` or equivalent lint;
3. `pyright`, `basedpyright` or `mypy` with strict project choices documented;
4. `pytest`;
5. dependency audit through the project package manager.

Do not mark these as enforced unless the generated project actually runs them.

## Team Readability

1. Dependency injection through constructors/factories: `1`
2. Hidden singleton mutable state: `0`
3. Public symbol count per file: `<= 12`
4. Distinct responsibilities per file: `1`
5. Typed public function signatures: `100%`

## Test Gates

1. Unit suite pass rate: `100%`
2. Integration suite pass rate: `100%`
3. Contract checks pass rate: `100%`
4. Migration up/down checks: `100%`
5. Critical auth/session/security tests pass: `100%`

## Merge Gate

Feature work is not accepted when:

1. documented limits are knowingly violated without an ADR;
2. changed behavior has no test evidence;
3. handlers bypass services/repositories;
4. contract and runtime disagree;
5. secrets or unsafe logs are introduced.

## Enforcement Reality

This standard is documented by default. It becomes linted/tested/CI-blocking only when the generated project includes real Python checks.

## Related Standards

1. `standards/active/TESTING.md`
2. `standards/active/API.md`
3. `standards/active/DATABASE.md`
4. `standards/active/SECURITY.md`
5. `standards/active/OBSERVABILITY.md`
