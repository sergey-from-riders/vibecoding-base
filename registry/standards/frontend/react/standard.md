# React Frontend Engineering Standard

This standard applies to `apps/web` when the active stack uses React without the Next.js app runtime.

UI density, shadcn usage, color policy and compact layout rules live in `ui/shadcn-compact`. Keep this standard focused on React architecture, state ownership, contracts and testability.

## May 2026 Baseline

1. React baseline: `19.2.x`.
2. Vite baseline: `8.x`.
3. Node.js production baseline: `24.x LTS`.
4. TypeScript baseline: `6.0.x`.
5. ESLint baseline: `10.x`.

## Stack Contract

1. `REACT_MAJOR = 19`
2. `NODE_MAJOR = 24`
3. `TYPESCRIPT_MAJOR = 6`
4. `VITE_MAJOR = 8`
5. `BUNDLER_ABSTRACTION_COUNT = 1`
6. `ROUTE_LEVEL_CODE_SPLITTING_PERCENT = 100`

## React Boundaries

1. Components render UI and delegate side effects to hooks or services.
2. Feature state must have one explicit owner.
3. Shared data fetching goes through the typed API client.
4. Cross-feature state requires a documented owner and tests.
5. Runtime configuration is read through a typed config module only.
6. Effects are synchronization points, not a general business logic layer.
7. Error boundaries exist around route-level flows.
8. Suspense boundaries are placed where loading states are useful to users.

## React 19 Usage

1. Use `useEffectEvent` for non-reactive effect logic when it avoids stale closures.
2. Use optimistic UI only with rollback behavior and user-visible failure states.
3. Do not add manual memoization everywhere; prefer measured fixes and compiler-compatible code.
4. Server-only React APIs are not used in a pure client React stack unless a framework runtime is added.

## Contract-First Frontend

1. API calls go through a shared typed client generated or maintained from OpenAPI.
2. Feature code must not invent hidden response shapes.
3. Error states use the shared problem/error model.
4. Request IDs from API responses must remain visible to observability and support flows.
5. Generated clients are regenerated when OpenAPI changes.
6. Frontend validation mirrors API constraints but does not replace backend validation.

## State And Data

1. Server state and client state are separated.
2. Remote cache ownership is explicit.
3. Do not copy remote data into local state unless editing a draft.
4. Forms own draft state and submit through typed API calls.
5. URL state is used for shareable filters and pagination.

## Reuse-First Rules

1. `REUSE_REQUIRED_PERCENT = 100` for repeated UI patterns.
2. `DUPLICATE_FEATURE_COMPONENTS_ALLOWED = 0`.
3. `DIRECT_FETCH_OUTSIDE_SHARED_API_CLIENT = 0`.
4. `CLIENT_STATE_WITHOUT_OWNER = 0`.
5. `DUPLICATE_REMOTE_CACHE_LAYERS = 0`.

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
8. Route chunks must stay explainable.
9. Expensive lists need virtualization or pagination.
10. Runtime errors must be visible during local development.

## Accessibility

1. WCAG 2.2 AA is the target.
2. Keyboard operation is required for interactive flows.
3. Focus states must be visible and not obscured.
4. Form errors must be programmatically associated with fields.
5. Drag actions need non-drag alternatives.

## Test Gates

1. Unit/component pass rate: `100%`.
2. Integration pass rate: `100%`.
3. E2E smoke pass rate: `100%`.
4. Contract compatibility check pass rate: `100%`.
5. Performance budget check pass rate: `100%`.

## Automated Checks

1. `scripts/check.sh` must call the active frontend checks when the project has runnable frontend code.
2. Until runtime checks exist, enforcement must be marked as documented only.

## Enforcement Reality

This standard is documented by default. It becomes linted/tested/CI-blocking only when the generated project includes real React, Vite, ESLint, typecheck, component, e2e and performance checks.
