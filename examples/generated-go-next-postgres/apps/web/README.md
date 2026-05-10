# apps/web

Next.js 16 web placeholder.

## Scope

- Minimal package metadata for the active stack.
- Target frontend architecture is documented in active standards.
- Auth UI and company switch UI are contract goals, not fully scaffolded runtime code in this starter template.

## Engineering Contract

- `standards/active/FRONTEND.md`
- `standards/active/UI.md`
- `standards/active/TESTING.md`

## Target Numeric Limits

1. `MAX_TS_FILE_LINES = 260`
2. `MAX_COMPONENT_LINES = 70`
3. `MAX_FUNCTION_LINES = 45`
4. `MAX_COMMENT_RATIO_PERCENT = 5`
5. `TOTAL_PROJECT_COLORS_MAX = 5`
6. `SHADOW_USAGE_COUNT = 0`
7. `BLACK_BORDER_USAGE_COUNT = 0`

## Policy When Runtime UI Is Added

1. Use the local `components/ui` layer for interactive primitives when shadcn is installed.
2. Use one unified list kit for repeated list/table screens.
3. Reuse repeatable UI and data patterns.
4. Keep layouts mobile-first and compact.
5. Avoid animation that creates layout shift.

This template is intentionally `partial`; it does not claim shadcn/Tailwind runtime setup until those files are added.
