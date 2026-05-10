# React Frontend Engineering Standard

This standard applies to `apps/web` when the active stack uses React without the Next.js app runtime.

UI density, shadcn usage, color policy and compact layout rules live in `ui/shadcn-compact`. Keep this standard focused on React architecture, state ownership, contracts and testability.

## Stack Contract

1. `REACT_MAJOR = 19`
2. `NODE_MAJOR = 24`
3. `TYPESCRIPT_MAJOR = 5`
4. `BUNDLER_ABSTRACTION_COUNT = 1`
5. `ROUTE_LEVEL_CODE_SPLITTING_PERCENT = 100`

## React Boundaries

1. Components render UI and delegate side effects to hooks or services.
2. Feature state must have one explicit owner.
3. Shared data fetching goes through the typed API client.
4. Cross-feature state requires a documented owner and tests.
5. Runtime configuration is read through a typed config module only.

## Contract-First Frontend

1. API calls go through a shared typed client generated or maintained from OpenAPI.
2. Feature code must not invent hidden response shapes.
3. Error states use the shared problem/error model.
4. Request IDs from API responses must remain visible to observability and support flows.

## Reuse-First Rules

1. `REUSE_REQUIRED_PERCENT = 100` for repeated UI patterns.
2. `DUPLICATE_FEATURE_COMPONENTS_ALLOWED = 0`.
3. `DIRECT_FETCH_OUTSIDE_SHARED_API_CLIENT = 0`.
4. `CLIENT_STATE_WITHOUT_OWNER = 0`.

## File And Component Limits

1. `MAX_TS_FILE_LINES = 260`
2. `MAX_COMPONENT_LINES = 70`
3. `MAX_FUNCTION_LINES = 45`
4. `MAX_HOOK_LINES = 55`
5. `MAX_COMPONENT_PROPS = 10`
6. `MAX_FUNCTION_PARAMS = 4`
7. `MAX_NESTING_DEPTH = 3`
8. `MAX_CYCLOMATIC_COMPLEXITY = 10`
9. `MAX_COMMENT_RATIO_PERCENT = 5`
10. `MAX_UNTESTED_CHANGED_FILES = 0`

## Performance Budgets

1. `WEB_VITALS_LCP_MS_P75_MAX = 2500`
2. `WEB_VITALS_INP_MS_P75_MAX = 200`
3. `WEB_VITALS_CLS_P75_MAX = 0.1`
4. `JS_PAYLOAD_KB_GZIP_INITIAL_MAX = 170`
5. `CRITICAL_CSS_KB_MAX = 35`
6. `ABOVE_THE_FOLD_IMAGE_LAZYLOAD = 0`
7. `NON_CRITICAL_IMAGE_LAZYLOAD = 100%`

## Test Gates

1. Unit/component pass rate: `100%`.
2. Integration pass rate: `100%`.
3. E2E smoke pass rate: `100%`.
4. Contract compatibility check pass rate: `100%`.
5. Performance budget check pass rate: `100%`.

## Automated Checks

1. `scripts/check.sh` must call the active frontend checks when the project has runnable frontend code.
2. Until runtime checks exist, enforcement must be marked as documented only.
