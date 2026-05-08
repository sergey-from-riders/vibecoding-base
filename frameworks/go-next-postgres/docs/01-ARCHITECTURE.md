# 01. Архитектура

## High-level

```text
Clients/Adapters
├─ Web (Next.js 16)
├─ Desktop (Qt 6)
└─ Agent tools / MCP clients
        ↓
API Gateway / HTTP Layer (Go)
        ↓
Service Layer
├─ Auth Service
└─ Company Context Service
        ↓
Repository Layer
        ↓
PostgreSQL 18
```

## Architectural principles
1. `Contract-first` — API contract before implementation.
2. `Thin adapters` — web/desktop делают только presentation + orchestration.
3. `Policy in backend` — все проверки доступа и tenant context на сервере.
4. `Observable by default` — trace/log/metrics обязательны.
5. `AI-ready` — MCP/agent integration предусмотрены в структуре репозитория.

Observability standard:
- `docs/22-OBSERVABILITY-STANDARD.md`

## Runtime boundaries
- `Auth Service`: identity, credentials, session lifecycle.
- `Company Context Service`: company membership and active-company switching.
- Других сервисов в текущем этапе нет.

## Security model (MVP)
- session token хранится только как hash;
- soft-delete пользователей;
- explicit membership check при каждом switch компании;
- request correlation через request_id.
