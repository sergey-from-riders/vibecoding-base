# 19. Next + Node Frontend Engineering Standard (Strict Numeric + Design Code)

Этот стандарт обязателен для `apps/web`.

## 1) Stack contract

1. `NEXT_MAJOR = 16`
2. `REACT_MAJOR = 19`
3. `NODE_MAJOR = 24`
4. `TYPESCRIPT_MAJOR = 5`
5. `SHADCN_UI_FOR_INTERACTIVE_PRIMITIVES_PERCENT = 100`

## 2) Reuse-first contract

1. `REUSE_REQUIRED_PERCENT = 100` для повторяемого UI.
2. `DUPLICATE_FEATURE_COMPONENTS_ALLOWED = 0`.
3. `DIRECT_FETCH_OUTSIDE_SHARED_API_CLIENT = 0`.
4. `FEATURE_LOCAL_COLOR_LITERALS_ALLOWED = 0`.
5. `FEATURE_LOCAL_SPACING_SYSTEMS_ALLOWED = 0`.

## 3) Unified list standard

Все списки в web обязаны использовать `1` формат и `1` набор компонентов:

1. `LIST_KIT_COUNT = 1`
2. `LIST_BASE_COMPONENT = DataList`
3. `LIST_TOOLBAR_COMPONENT = DataListToolbar`
4. `LIST_FILTERS_COMPONENT = DataListFilters`
5. `LIST_EMPTY_COMPONENT = DataListEmpty`
6. `LIST_SKELETON_COMPONENT = DataListSkeleton`
7. `LIST_ROW_LAYOUT_VARIANTS = 1`
8. `LIST_PAGINATION_PATTERN_COUNT = 1`
9. `LIST_FILTER_MODEL_COUNT_PER_ENTITY = 1`
10. `DUPLICATE_LIST_IMPLEMENTATIONS_ALLOWED = 0`

## 4) File/function/component hard limits

1. `MAX_TS_FILE_LINES = 260`
2. `MAX_COMPONENT_LINES = 70`
3. `MAX_FUNCTION_LINES = 45`
4. `MAX_HOOK_LINES = 55`
5. `MAX_PAGE_FILE_LINES = 120`
6. `MAX_SERVER_ACTION_LINES = 60`
7. `MAX_COMPONENT_PROPS = 10`
8. `MAX_FUNCTION_PARAMS = 4`
9. `MAX_NESTING_DEPTH = 3`
10. `MAX_CYCLOMATIC_COMPLEXITY = 10`
11. `MAX_COMMENT_RATIO_PERCENT = 5`
12. `MAX_UNTESTED_CHANGED_FILES = 0`

## 5) shadcn-only UI policy

1. `RAW_INTERACTIVE_HTML_TAGS_IN_FEATURE_CODE = 0`
2. `DIRECT_RADIX_IMPORTS_IN_FEATURE_CODE = 0`
3. `CUSTOM_UI_PRIMITIVE_WITHOUT_ADR = 0`
4. Интерактивные примитивы (`button`, `input`, `select`, `textarea`, `dialog`, `table`) в feature-коде: только `components/ui` (shadcn layer).

## 6) Mobile-first density policy

1. `MOBILE_FIRST_BREAKPOINT_ORDER = base -> sm -> md -> lg -> xl`
2. `MIN_TOUCH_TARGET_PX = 36`
3. `DEFAULT_TOUCH_TARGET_PX = 40`
4. `MAX_PRIMARY_LAYOUT_GAP_PX = 8`
5. `MAX_CARD_PADDING_PX = 8`
6. `MAX_SECTION_MARGIN_BOTTOM_PX = 12`
7. `DEFAULT_LINE_HEIGHT_RATIO = 1.25`
8. `DENSITY_MODE_COUNT = 1` (compact-first)
9. `INFO_DENSITY_PRIORITY = 1` (максимум данных на единицу площади)

## 7) Visual style policy (high contrast, no visual noise)

1. `TOTAL_PROJECT_COLORS_MAX = 5`
2. `ACCENT_COLOR_COUNT = 1`
3. `SHADOW_USAGE_COUNT = 0`
4. `BLACK_BORDER_USAGE_COUNT = 0`
5. `BORDER_BLACK_HEX_USAGE_COUNT = 0`
6. `INLINE_STYLE_USAGE_COUNT = 0`
7. `RAW_HEX_IN_FEATURE_CODE_COUNT = 0`
8. `CONTRAST_REQUIRED_PERCENT = 100`

Разрешенные `5` цветов проекта:
1. `#FFFFFF` (background)
2. `#F3F5F7` (surface)
3. `#101418` (text)
4. `#0A84FF` (accent)
5. `#D92D20` (danger)

## 8) Animation policy (no layout shift)

1. `LAYOUT_SHIFTING_ANIMATIONS_ALLOWED = 0`
2. `TRANSFORM_SHIFT_ANIMATIONS_ALLOWED = 0` (кроме drag/reorder сценариев)
3. `TRANSITION_ALL_USAGE_COUNT = 0`
4. `DEFAULT_ANIMATION_DURATION_MS = 120`
5. `MAX_ANIMATION_DURATION_MS = 160`
6. `ALLOWED_TRANSITIONS = color, background-color, border-color, opacity`
7. `ANIMATION_FOR_DRAG_REORDER_ALLOWED = 1`
8. `CLS_BUDGET = 0.1`

## 9) Performance-first budgets

1. `WEB_VITALS_LCP_MS_P75_MAX = 2500`
2. `WEB_VITALS_INP_MS_P75_MAX = 200`
3. `WEB_VITALS_CLS_P75_MAX = 0.1`
4. `JS_PAYLOAD_KB_GZIP_INITIAL_MAX = 170`
5. `CRITICAL_CSS_KB_MAX = 35`
6. `ABOVE_THE_FOLD_IMAGE_LAZYLOAD = 0`
7. `NON_CRITICAL_IMAGE_LAZYLOAD = 100%`
8. `SERVER_COMPONENT_DEFAULT_PERCENT = 100`
9. `USE_CLIENT_WITHOUT_REASON = 0`

## 10) Node runtime rules for Next (`src/server`)

1. `PROCESS_ENV_DIRECT_ACCESS_OUTSIDE_CONFIG = 0`
2. `IMPORT_TIME_SIDE_EFFECTS = 0`
3. `INPUT_VALIDATION_COVERAGE_PERCENT = 100`
4. `TYPED_RESULT_CONTRACT_COVERAGE_PERCENT = 100`
5. `UNHANDLED_PROMISE_REJECTION_PATHS = 0`
6. `SHARED_API_CLIENT_USAGE_PERCENT = 100`

## 11) Design code (copy-paste baseline)

### 11.1 CSS variables (`apps/web/src/styles/tokens.css`)

```css
:root {
  --app-bg: #ffffff;
  --app-surface: #f3f5f7;
  --app-text: #101418;
  --app-accent: #0a84ff;
  --app-danger: #d92d20;

  --app-gap-1: 2px;
  --app-gap-2: 4px;
  --app-gap-3: 6px;
  --app-gap-4: 8px;
  --app-gap-5: 12px;

  --app-radius-1: 4px;
  --app-radius-2: 6px;
  --app-radius-3: 8px;

  --app-duration-fast: 120ms;
  --app-duration-max: 160ms;
}
```

### 11.2 shadcn style invariants

```css
/* global.css */
* {
  box-shadow: none !important;
}

.border,
[class*="border-"] {
  border-color: color-mix(in srgb, var(--app-text) 16%, transparent) !important;
}

[class*="transition-all"] {
  transition: none !important;
}

.motion-safe {
  transition-property: color, background-color, border-color, opacity;
  transition-duration: var(--app-duration-fast);
}
```

### 11.3 Unified list markup contract

```tsx
<DataList>
  <DataListToolbar />
  <DataListFilters />
  <DataListRows />
  <DataListPagination />
</DataList>
```

## 12) Frontend test gates

1. `UNIT_COMPONENT_PASS_RATE = 100%`
2. `INTEGRATION_PASS_RATE = 100%`
3. `E2E_SMOKE_PASS_RATE = 100%`
4. `FEATURE_E2E_PASS_RATE = 100%`
5. `TELEGRAM_WEBVIEW_SMOKE_PASS_RATE = 100%`
6. `PERFORMANCE_BUDGET_CHECK_PASS_RATE = 100%`

## 13) Merge gate

Фича не принимается при любом нарушении:
1. Любой лимит из разделов `2-12`: `> 0`.
2. Любой bypass unified list kit: `> 0`.
3. Любой bypass shadcn-only policy: `> 0`.

## 14) Automated checks

1. `tools/scripts/check_web_limits.sh apps/web`
2. Допустимое число нарушений: `0`
3. Код возврата при нарушениях: `1`

## 15) Related docs

1. `docs/08-UI-CROSS-PLATFORM-RULES.md`
2. `docs/09-PLATFORM-UI-STACKS.md`
3. `docs/10-DESIGN-TOKENS-BUILD-PIPELINE.md`
4. `docs/17-TESTING-TDD-QUALITY-GATES.md`
5. `docs/99-REFERENCES.md`
