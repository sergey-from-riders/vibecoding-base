# 99. References (official sources)

Ниже источники, на основе которых обновлена архитектура и toolchain.

## Frameworks / Platform
- Next.js 16 release notes: https://nextjs.org/blog/next-16
- React 19 upgrade guide: https://react.dev/blog/2024/04/25/react-19-upgrade-guide
- Qt 6 documentation: https://doc.qt.io/qt-6/
- Android WebView guide: https://developer.android.com/develop/ui/views/layout/webapps/webview
- Embedding web content in Android apps: https://developer.android.com/develop/ui/views/layout/webapps/embed-web-content-in-app
- Web content in Android apps (overview): https://developer.android.com/develop/ui/views/layout/webapps
- Android WebView API reference: https://developer.android.com/reference/android/webkit/WebView
- Qt Quick Controls: https://doc.qt.io/qt-6/qtquickcontrols-index.html
- Qt Quick Controls styles: https://doc.qt.io/qt-6/qtquickcontrols-styles.html
- Qt Quick Controls Fluent WinUI 3 style: https://doc.qt.io/qt-6/qtquickcontrols-fluentwinui3.html

## Monorepo / Tooling
- pnpm workspaces: https://pnpm.io/workspaces
- pnpm catalogs: https://pnpm.io/catalogs
- Biome v2 announcement: https://biomejs.dev/blog/biome-v2/
- Biome monorepo docs: https://biomejs.dev/guides/big-projects/
- Playwright docs: https://playwright.dev/docs/intro

## API / Integration / Standards
- OpenAPI 3.2 release: https://www.openapis.org/blog/openapi-specification-3-2-released
- OpenAPI latest specification: https://spec.openapis.org/oas/latest.html
- OpenAPI format registry (latest): https://spec.openapis.org/registry/format/
- Model Context Protocol docs: https://modelcontextprotocol.io/docs/getting-started/intro
- DTCG specification drafts: https://www.designtokens.org/tr/drafts/
- Style Dictionary docs: https://styledictionary.com/getting-started/installation/

## HTTP and API semantics
- HTTP Semantics (RFC 9110): https://www.rfc-editor.org/rfc/rfc9110
- Problem Details for HTTP APIs (RFC 9457): https://www.rfc-editor.org/rfc/rfc9457
- HTTP Method Registry (IANA): https://www.iana.org/assignments/http-methods/http-methods.xhtml
- OpenAPI Path Item object: https://spec.openapis.org/oas/latest.html#path-item-object

## OpenAPI tooling (primary)
- Redocly CLI docs: https://redocly.com/docs/cli
- Redocly CLI bundle command: https://redocly.com/docs/cli/commands/bundle
- Redocly CLI lint command: https://redocly.com/docs/cli/commands/lint
- Redocly CLI build-docs command: https://redocly.com/docs/cli/commands/build-docs
- Swagger UI usage/config docs: https://swagger.io/docs/open-source-tools/swagger-ui/usage/configuration/

## Deployment / Ops
- Docker Compose docs: https://docs.docker.com/compose/
- Use Compose in production: https://docs.docker.com/compose/how-tos/production/
- Docker Compose CLI reference: https://docs.docker.com/reference/cli/docker/compose/
- Docker Compose plugin install (Linux): https://docs.docker.com/compose/install/linux/
- Install Docker Engine: https://docs.docker.com/engine/install/
- Kubernetes production environment guidance: https://kubernetes.io/docs/setup/production-environment/
- systemd unit files reference: https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html
- Nginx proxy module reference: https://nginx.org/en/docs/http/ngx_http_proxy_module.html

## Commit and release standards
- Conventional Commits 1.0.0: https://www.conventionalcommits.org/en/v1.0.0/
- Semantic Versioning 2.0.0: https://semver.org/spec/v2.0.0.html
- Keep a Changelog 1.1.0: https://keepachangelog.com/en/1.1.0/
- Git trailers format (interpret-trailers): https://git-scm.com/docs/git-interpret-trailers

## Testing / TDD / quality gates
- Go testing package: https://pkg.go.dev/testing
- Go test command: https://pkg.go.dev/cmd/go#hdr-Test_packages
- Testcontainers for Go: https://testcontainers.com/guides/getting-started-with-testcontainers-for-go/
- Playwright best practices: https://playwright.dev/docs/best-practices
- Testing Library guiding principles: https://testing-library.com/docs/guiding-principles

## Observability standards
- OpenTelemetry specification: https://opentelemetry.io/docs/specs/otel/
- OpenTelemetry semantic conventions: https://opentelemetry.io/docs/specs/semconv/
- W3C Trace Context: https://www.w3.org/TR/trace-context/
- Prometheus metric and label naming: https://prometheus.io/docs/practices/naming/

## Go backend standards (official)
- Go release history: https://go.dev/doc/devel/release
- Go 1.26 release notes: https://go.dev/doc/go1.26
- Effective Go: https://go.dev/doc/effective_go
- Code Review Comments: https://go.dev/wiki/CodeReviewComments
- Organizing a Go module: https://go.dev/doc/modules/layout
- `net/http` package docs (routing patterns): https://pkg.go.dev/net/http
- `log/slog` package docs: https://pkg.go.dev/log/slog
- `context` package docs: https://pkg.go.dev/context
- `database/sql` package docs: https://pkg.go.dev/database/sql
- `go vet` command docs: https://pkg.go.dev/cmd/vet
- OpenTelemetry Go instrumentation: https://opentelemetry.io/docs/languages/go/instrumentation/

## Next/Node frontend standards (official)
- Next.js 16 release notes: https://nextjs.org/blog/next-16
- Next.js App Router docs: https://nextjs.org/docs/app
- Next.js Client Components docs: https://nextjs.org/docs/app/building-your-application/rendering/client-components
- Next.js Server Components docs: https://nextjs.org/docs/app/building-your-application/rendering/server-components
- Next.js Route Handlers docs: https://nextjs.org/docs/app/building-your-application/routing/route-handlers
- Next.js production optimization docs: https://nextjs.org/docs/app/building-your-application/optimizing
- Node.js docs: https://nodejs.org/docs/latest/api/
- Node.js release schedule: https://github.com/nodejs/release#release-schedule
- shadcn/ui docs: https://ui.shadcn.com/docs
- shadcn/ui changelog: https://ui.shadcn.com/changelog
- web-vitals docs: https://web.dev/vitals/
- Cumulative Layout Shift guidance: https://web.dev/articles/cls
- INP guidance: https://web.dev/articles/inp

## C++/Qt memory safety and toolchain standards (official)
- C++ Core Guidelines: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines
- Guideline support library (GSL): https://github.com/microsoft/GSL
- C++ compiler support table: https://en.cppreference.com/w/cpp/compiler_support
- Qt object trees and ownership: https://doc.qt.io/qt-6/objecttrees.html
- QObject docs: https://doc.qt.io/qt-6/qobject.html
- QPointer docs: https://doc.qt.io/qt-6/qpointer.html
- QSharedPointer docs: https://doc.qt.io/qt-6/qsharedpointer.html
- Qt supported platforms (6.10): https://doc.qt.io/qt-6/supported-platforms.html
- Qt for Windows (compiler notes): https://doc.qt.io/qt-6/windows-building.html
- Qt for Linux/X11 requirements: https://doc.qt.io/qt-6/linux-requirements.html
- Qt for macOS requirements: https://doc.qt.io/qt-6/macos.html
- Clang AddressSanitizer: https://clang.llvm.org/docs/AddressSanitizer.html
- Clang UndefinedBehaviorSanitizer: https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
- Clang ThreadSanitizer: https://clang.llvm.org/docs/ThreadSanitizer.html
- Clang LeakSanitizer: https://clang.llvm.org/docs/LeakSanitizer.html
- Clang Safe Buffers: https://clang.llvm.org/docs/SafeBuffers.html
- Clang-Tidy docs: https://clang.llvm.org/extra/clang-tidy/
- clangd docs: https://clangd.llvm.org/
- CMake Presets: https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html

## AI agent stack
- OpenAI Agents SDK docs (Python): https://openai.github.io/openai-agents-python/

## Web in Telegram
- Telegram Mini Apps platform overview: https://docs.telegram-mini-apps.com/platform/about
- Telegram Mini Apps launch parameters: https://docs.telegram-mini-apps.com/platform/launch-parameters
- Telegram Mini Apps theming: https://docs.telegram-mini-apps.com/platform/theming
- Telegram Mini Apps viewport: https://docs.telegram-mini-apps.com/platform/viewport
- Init data validation: https://docs.telegram-mini-apps.com/platform/init-data

## Web component systems
- shadcn/ui docs: https://ui.shadcn.com/docs
- shadcn/ui changelog: https://ui.shadcn.com/changelog
