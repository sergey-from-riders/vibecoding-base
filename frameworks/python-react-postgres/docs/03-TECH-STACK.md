# 03. Технологический стек (modern 2026)

## Backend
- Python 3.14+
- FastAPI with explicit routers
- Pydantic 2 models for API input/output
- SQLAlchemy 2 / asyncpg with SQL migrations
- OpenTelemetry instrumentation
- Pytest + integration tests with PostgreSQL/Testcontainers

## Web
- React 19
- Vite or framework-neutral React adapter
- Node.js 24 LTS runtime
- TypeScript 6
- Biome 2.x (format/lint)
- Testing Library + Vitest for component/integration tests
- Playwright for e2e/regression smoke

## Desktop
- Qt 6 + CMake presets
- C++23 baseline
- Primary toolchain: Clang 18+ (Linux), MSVC 2022 (Windows), AppleClang Xcode 15+ (macOS)
- общий API-контракт с web

## Android (WebView-first)
- Kotlin app shell
- Android WebView as rendering layer for shared web UI
- optional gradual native screens later when needed

## Monorepo toolchain
- pnpm workspaces
- pnpm catalogs (единое управление версиями зависимостей)
- Nx/Turbo-style task graph + remote cache (choose by team ops constraints)

## API contracts
- OpenAPI 3.2
- Modular OpenAPI files per module
- Redocly CLI for lint/bundle/docs build
- generated SDKs (TS, Python)

## AI/Agent layer
- MCP-compatible integrations (`mcp/servers`)
- agent SDK-based automations for routine workflows

## Observability
- OpenTelemetry tracing
- structured JSON logs
- metrics for latency/error/session flows

## DB
- PostgreSQL 18+
- extensions: `pgcrypto`, `citext`
- migration-first

## Design system delivery
- DTCG design tokens as source of truth
- token transforms to web/qt/android-web themes
