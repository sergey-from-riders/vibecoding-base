# apps/web

Next.js 16 web adapter.

## Scope
- auth UI
- switch company UI

## Mandatory engineering contract
- `docs/19-NEXT-NODE-FRONTEND-STANDARD.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `docs/08-UI-CROSS-PLATFORM-RULES.md`

## Hard numeric limits
1. `MAX_TS_FILE_LINES = 260`
2. `MAX_COMPONENT_LINES = 70`
3. `MAX_FUNCTION_LINES = 45`
4. `MAX_COMMENT_RATIO_PERCENT = 5`
5. `TOTAL_PROJECT_COLORS_MAX = 5`
6. `SHADOW_USAGE_COUNT = 0`
7. `BLACK_BORDER_USAGE_COUNT = 0`

## Mandatory frontend policy
1. `shadcn-only` interactive primitives.
2. Unified list kit only.
3. Reuse-first for all repeatable UI/data patterns.
4. Mobile-first compact layout.
5. Animation without layout shift by default.
