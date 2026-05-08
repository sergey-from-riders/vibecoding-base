# 02. Структура монорепозитория

## Целевая структура
```text
ai-app/
├─ apps/
│  ├─ api/                     # Go backend
│  ├─ web/                     # Next.js 16 web app
│  ├─ mobile/
│  │  └─ android/              # Android WebView shell app
│  └─ desktop/
│     ├─ qt/                   # shared Qt app code
│     └─ installers/           # platform packages (mac/win/linux)
├─ packages/
│  ├─ contracts/               # OpenAPI + JSON Schema
│  ├─ tokens/                  # design tokens source of truth (DTCG)
│  ├─ sdk-ts/                  # generated TS SDK
│  ├─ sdk-go/                  # Go SDK/client helpers
│  ├─ ui/                      # shared web UI primitives
│  └─ config/                  # shared lint/build presets (planned)
├─ db/
│  ├─ migrations/              # SQL up/down migrations
│  └─ seeds/                   # deterministic seeds
├─ mcp/
│  └─ servers/                 # MCP server configs and adapters
├─ agents/
│  ├─ profiles/                # reusable agent instructions
│  ├─ playbooks/               # step-by-step execution playbooks
│  └─ tasks/                   # task logs for major changes
├─ infra/
│  ├─ docker/
│  ├─ nginx/                  # reverse proxy config (ai-app.conf.example)
│  └─ ci/
├─ tools/
│  └─ scripts/
└─ docs/
```

## Desktop layout rule
`apps/desktop/qt` — единый код для macOS/Windows/Linux.
Платформенные различия только в `apps/desktop/installers`.

## Shared contract rule
`packages/contracts` — source of truth для API.
`packages/sdk-ts` и `packages/sdk-go` синхронизируются оттуда.
