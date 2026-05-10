# 18. Go Backend Engineering Standard (Strict Numeric Rules)

Этот стандарт обязателен для `apps/api`.

## 1) Каноническая структура

```text
apps/api/
├─ cmd/api/main.go
├─ internal/platform/httpserver/router.go
├─ internal/platform/httpserver/middleware/*.go
├─ internal/platform/problem/writer.go
├─ internal/platform/db/*.go
├─ internal/modules/auth/module.go
├─ internal/modules/auth/transport/http/routes.go
├─ internal/modules/auth/transport/http/*_handler.go
├─ internal/modules/auth/service/*.go
├─ internal/modules/auth/repository/*.go
├─ internal/modules/company/module.go
├─ internal/modules/company/transport/http/routes.go
├─ internal/modules/company/transport/http/*_handler.go
├─ internal/modules/company/service/*.go
└─ internal/modules/company/repository/*.go
```

## 2) Числовые лимиты (обязательные)

1. `MAX_GO_FILE_LINES = 250`
2. `MAX_FUNCTION_LINES = 40`
3. `MAX_HANDLER_LINES = 35`
4. `MAX_ROUTES_FILE_LINES = 100`
5. `MAX_FUNCTION_PARAMS = 4`
6. `MAX_FUNCTION_RETURNS = 3`
7. `MAX_NESTING_DEPTH = 3`
8. `MAX_SWITCH_CASES = 7`
9. `MAX_CYCLOMATIC_COMPLEXITY = 10`
10. `MAX_HANDLER_DB_CALLS = 0`
11. `MAX_HANDLER_REPOSITORY_CALLS = 0`
12. `MAX_HANDLER_SERVICE_CALLS = 1`
13. `MAX_HANDLER_RESPONSE_WRITES = 1`
14. `MAX_MODULE_ROUTES_PER_FILE = 12`
15. `MAX_MIDDLEWARE_PER_ROUTE = 6`
16. `MAX_COMMENT_RATIO_PERCENT = 5`
17. `MAX_PANIC_IN_REQUEST_PATH = 0`
18. `MAX_GLOBAL_MUTABLE_STATE = 0`
19. `MAX_TODO_IN_MAIN_BRANCH = 0`
20. `MAX_UNTESTED_CHANGED_FILES = 0`

## 3) Router decomposition rules

1. `GLOBAL_ROUTER_FILES = 1` (`internal/platform/httpserver/router.go`)
2. `MODULE_ROUTER_FILES_MIN = 1` на каждый модуль
3. `ENDPOINTS_PER_HANDLER_FILE = 1`
4. `HANDLER_FILES_PER_MODULE_MIN = 1`
5. `ROUTES_WITHOUT_MODULE_OWNER = 0`

## 4) Handler contract rules

1. Parse input: `1`
2. Validate input: `1`
3. Service call: `1`
4. Error mapping: `1`
5. Response write: `1`

Запрещено в handler:
1. SQL calls: `0`
2. Repository orchestration: `0`
3. Domain policy branches: `0`
4. Transaction control: `0`

## 5) Service contract rules

1. HTTP imports in service package: `0`
2. DB driver imports in service package: `0`
3. Repository interfaces per service file: `<= 4`
4. Unit tests required per public service method: `>= 1`

## 6) Repository contract rules

1. `context.Context` in public methods: `100%`
2. Non-UUID domain IDs: `0`
3. Direct HTTP dependency in repository: `0`
4. Integration tests per repository method: `>= 1`

## 7) Team-readability rules

1. Constructor per component: `1`
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
2. Любой пропущенный тест gate: `> 0`
3. Любой giant router/handler file: `> 0`

## 10) Автоматическая проверка

1. Скрипт: `tools/scripts/check_go_limits.sh`
2. Команда: `tools/scripts/check_go_limits.sh apps/api`
3. Допустимое число нарушений: `0`
4. Код возврата при нарушениях: `1`

## 11) Связанные документы

1. `standards/active/TESTING.md`
2. `standards/active/API.md`
3. `standards/active/DATABASE.md`
4. `standards/active/SECURITY.md`
5. `standards/active/OBSERVABILITY.md`
