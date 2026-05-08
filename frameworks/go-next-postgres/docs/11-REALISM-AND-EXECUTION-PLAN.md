# 11. Realism and Execution Plan

## Реалистичность идеи
Идея реалистична, но важно понимать границы:

1. Единый UI-код для web+android(WebView) — реалистично.
2. Qt остается отдельным нативным desktop-клиентом, но под теми же правилами и токенами.
3. Единые правила, токены, UX-сценарии и API-контракт — реалистично и целесообразно.

## Что реально унифицировать на 100%
- доменная терминология;
- user flows;
- API contracts;
- design tokens;
- accessibility baseline;
- observability conventions.

Обязательные companion docs:
- `docs/22-OBSERVABILITY-STANDARD.md`
- `docs/24-ANDROID-ENGINEERING-STANDARD.md`
- `docs/25-MCP-AGENTS-OPERATIONS-STANDARD.md`

## Что будет различаться
- конкретные widget primitives;
- navigation patterns по платформенным ожиданиям;
- микродетали motion/gestures/controls.

## Риски
- переоценка скорости при одновременном старте web+telegram+qt+android-shell;
- drift между платформами без token governance;
- Telegram WebView edge-cases (viewport, safe-area, feature parity).

## Практичный план
Phase 1:
- web + telegram adapter + api (auth/switch)
- tokens pipeline v1

Phase 2:
- qt desktop (auth/switch)

Phase 3:
- android WebView shell hardening (auth/switch, device integration)

Phase 4:
- cross-platform hardening, visual diff and a11y audits
