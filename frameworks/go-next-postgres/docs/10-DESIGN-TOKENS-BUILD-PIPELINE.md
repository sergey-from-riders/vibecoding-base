# 10. Design Tokens Build Pipeline

## Goal
Один источник design decisions -> платформенные артефакты для web/qt/android-webview.

## Source of truth
- `packages/tokens/tokens.json` (DTCG format)

## Build steps
1. Validate tokens schema (DTCG format check).
2. Transform tokens into platform outputs (Style Dictionary or equivalent):
- Web: CSS variables / Tailwind theme extension
- Android WebView: shared web theme package for embedded app
- Qt: QML singleton / palette map
3. Run visual smoke snapshots on each client.
4. Publish versioned token package.

## Mapping policy
- Semantic tokens map to platform-native roles.
- Raw hex usage in feature code is forbidden.
- Platform may add local aliases, but base token keys are immutable.
- Total project color tokens for frontend baseline: `5`.
- Compact spacing baseline is mandatory (dense information layout).
- Motion tokens must not introduce layout shift by default.

## Telegram-specific layer
- On Telegram launch, web adapter applies `tgWebAppThemeParams` as runtime overrides for compatible semantic roles.
- Fallback to base tokens when Telegram params absent.
