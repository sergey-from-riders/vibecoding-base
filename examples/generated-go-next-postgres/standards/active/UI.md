<!-- Generated from registry/standards/ui/shadcn-compact@1.0.0. Update the registry standard, then regenerate. -->

# shadcn Compact UI Profile

This UI profile applies to web interfaces that choose compact, high-contrast, reusable shadcn-based UI.

It is a separate standard because UI policy is not the same thing as a frontend runtime. React, Next.js, Vue, Svelte or another frontend can adopt or ignore this profile explicitly through the active stack.

## shadcn-First Policy

1. `SHADCN_UI_FOR_INTERACTIVE_PRIMITIVES_PERCENT = 100`
2. `RAW_INTERACTIVE_HTML_TAGS_IN_FEATURE_CODE = 0`
3. `DIRECT_RADIX_IMPORTS_IN_FEATURE_CODE = 0`
4. `CUSTOM_UI_PRIMITIVE_WITHOUT_ADR = 0`

Interactive primitives in feature code use the local `components/ui` layer.

## Unified List Standard

All repeated list/table screens use one list kit:

1. `LIST_KIT_COUNT = 1`
2. `LIST_BASE_COMPONENT = DataList`
3. `LIST_TOOLBAR_COMPONENT = DataListToolbar`
4. `LIST_FILTERS_COMPONENT = DataListFilters`
5. `LIST_EMPTY_COMPONENT = DataListEmpty`
6. `LIST_SKELETON_COMPONENT = DataListSkeleton`
7. `LIST_ROW_LAYOUT_VARIANTS = 1`
8. `DUPLICATE_LIST_IMPLEMENTATIONS_ALLOWED = 0`

## Compact Density

1. `MOBILE_FIRST_BREAKPOINT_ORDER = base -> sm -> md -> lg -> xl`
2. `MIN_TOUCH_TARGET_PX = 36`
3. `DEFAULT_TOUCH_TARGET_PX = 40`
4. `MAX_PRIMARY_LAYOUT_GAP_PX = 8`
5. `MAX_CARD_PADDING_PX = 8`
6. `MAX_SECTION_MARGIN_BOTTOM_PX = 12`
7. `DEFAULT_LINE_HEIGHT_RATIO = 1.25`
8. `DENSITY_MODE_COUNT = 1`

## Visual Style

1. `TOTAL_PROJECT_COLORS_MAX = 5`
2. `ACCENT_COLOR_COUNT = 1`
3. `SHADOW_USAGE_COUNT = 0`
4. `BLACK_BORDER_USAGE_COUNT = 0`
5. `INLINE_STYLE_USAGE_COUNT = 0`
6. `RAW_HEX_IN_FEATURE_CODE_COUNT = 0`
7. `CONTRAST_REQUIRED_PERCENT = 100`

Baseline colors:

1. `#FFFFFF` background
2. `#F3F5F7` surface
3. `#101418` text
4. `#0A84FF` accent
5. `#D92D20` danger

## Motion

1. `LAYOUT_SHIFTING_ANIMATIONS_ALLOWED = 0`
2. `TRANSFORM_SHIFT_ANIMATIONS_ALLOWED = 0` except drag/reorder.
3. `TRANSITION_ALL_USAGE_COUNT = 0`
4. `DEFAULT_ANIMATION_DURATION_MS = 120`
5. `MAX_ANIMATION_DURATION_MS = 160`
6. Allowed transition properties: `color`, `background-color`, `border-color`, `opacity`.
7. `CLS_BUDGET = 0.1`

## Enforcement Reality

This profile is documented by default. It becomes linted/CI-blocking only when the generated project includes an actual UI lint check that scans feature code.
