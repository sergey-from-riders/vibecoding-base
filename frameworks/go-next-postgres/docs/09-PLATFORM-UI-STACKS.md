# 09. Platform UI Stacks and Design Systems (2026)

## Decision matrix

### Web (including Telegram Mini App)
- Framework: Next.js 16 + React 19
- Component strategy: `shadcn/ui` (актуален, активно обновляется)
- Primitive layer: Radix UI (или Base UI через shadcn create)
- Styling: Tailwind CSS 4 + tokens
- Unified list policy: single shared list kit

Why:
- быстрый delivery;
- control over generated components;
- хорошая интеграция с token-driven theming.

### Telegram Mini App (Web Adapter)
- Runtime: тот же web bundle, запущенный в Telegram WebView
- Platform integration:
  - launch params (`tgWebApp*`)
  - theming (`tgWebAppThemeParams` / theme_changed)
  - viewport/safe area
  - init data validation на backend

Why:
- Telegram Mini Apps — это web apps внутри Telegram;
- отдельный стек не нужен, нужен adapter слой поверх web.

### Qt Desktop (macOS/Windows/Linux)
- Framework: Qt 6 + Qt Quick Controls
- Style policy:
  - Windows: FluentWinUI3 (если стабильно для конкретного экрана)
  - macOS: macOS style
  - Linux: Fusion/Material по UX-решению
- Theme from tokens + platform-specific mapping
- Memory safety and C++ toolchain policy: `docs/20-CPP-QT-MEMORY-SAFETY-STANDARD.md`

Why:
- нативная desktop-интеграция;
- контроль над cross-platform delivery;
- возможность платформенных style-overrides без смены архитектуры.

### Android (WebView-first)
- Framework: Kotlin native app shell + Android WebView
- UI source: shared web UI (Next.js app)
- Design mapping: DTCG tokens -> web theme -> rendered in WebView
- Optional future: selective native Android screens only when technically required

Why:
- максимальная скорость запуска и единообразие с web/telegram;
- один UI implementation для web + android container;
- нативный shell оставляет доступ к Android capabilities.

Engineering standard:
- `docs/24-ANDROID-ENGINEERING-STANDARD.md`

## shadcn/ui status
`shadcn/ui` остается актуальным в 2026:
- активный changelog;
- обновления по Radix/Base UI;
- mature CLI workflow.

Conclusion: оставляем `shadcn/ui` для web.
Дополнение: в feature-коде web используются только shadcn primitives для интерактивных элементов.
