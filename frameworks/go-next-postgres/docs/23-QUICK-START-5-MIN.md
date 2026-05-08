# 23. Quick Start (5 Minutes)

Цель: поднять локальный контур с корректными env, БД-миграциями и базовой проверкой contracts.

Важно: репозиторий находится в фазе архитектурного foundation.
Если runtime-код API/Web еще не реализован, шаги запуска приложений могут быть placeholders, но env/db/contracts контур должен подниматься полностью.

## 1) Prerequisites

1. `git`
2. `bash`
3. `docker` + `docker compose`
4. `psql` client
5. `node >= 24` + `corepack` (`pnpm`)
6. `go >= 1.26` (для backend runtime, когда код готов)
7. `jq` (для contract scripts)
8. `rg` (для starter/static checks)

## 2) Clone

```bash
git clone <your-repo-url> ai-app
cd ai-app
```

## 3) Prepare env files

```bash
corepack enable
pnpm install

cp .env.example .env
cp apps/api/.env.example apps/api/.env
cp apps/web/.env.example apps/web/.env
cp apps/mobile/android/.env.example apps/mobile/android/.env
cp infra/docker/.env.example infra/docker/.env
```

Минимально проверьте значения:
1. `APP_API_PORT=18031`
2. `APP_WEB_PORT=18030`
3. `APP_DB_*` в `apps/api/.env`
4. `NEXT_PUBLIC_APP_API_BASE_URL=http://localhost:18031` в `apps/web/.env`

## 4) Start PostgreSQL 18 locally

```bash
docker run --name ai-app-pg \
  -e POSTGRES_DB=ai_app \
  -e POSTGRES_USER=ai_app \
  -e POSTGRES_PASSWORD=local_dev_password_only \
  -p 5432:5432 -d postgres:18
```

Проверка:

```bash
PGPASSWORD=local_dev_password_only psql -h 127.0.0.1 -U ai_app -d ai_app -c 'select 1;'
```

## 5) Apply migrations

```bash
set -euo pipefail
for f in db/migrations/*.up.sql; do
  echo "apply $f"
  PGPASSWORD=local_dev_password_only psql -h 127.0.0.1 -U ai_app -d ai_app -f "$f"
done
```

Проверка таблиц:

```bash
PGPASSWORD=local_dev_password_only psql -h 127.0.0.1 -U ai_app -d ai_app -c "\dt"
```

## 6) Validate API contracts (mandatory)

```bash
pnpm run verify:contracts
```

Ожидаемый результат:
1. bundle собирается в `packages/contracts/openapi/dist`
2. coverage check завершается без violations

## 7) Start API and Web (when runtime code exists)

### API

```bash
cd apps/api
go run ./cmd/api
```

### Web

```bash
cd ai-app
corepack enable
pnpm install
pnpm -C apps/web dev
```

## 8) Smoke checks

```bash
curl -i http://localhost:18031/api/v1/docs/openapi.json
curl -i http://localhost:18031/api/v1/docs/endpoints
curl -i http://localhost:18030
```

## 9) Common failures

1. `port already in use`:
- проверьте занятость `18030/18031/5432`.
2. `psql connection refused`:
- PostgreSQL контейнер не поднялся.
3. `OpenAPI coverage check failed`:
- endpoint есть в коде, но нет в `endpoints.inventory.tsv` или module OpenAPI.

## 10) Next mandatory reads

1. `docs/12-ENV-REPO-DEPLOY.md`
2. `docs/17-TESTING-TDD-QUALITY-GATES.md`
3. `docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md`
4. `docs/22-OBSERVABILITY-STANDARD.md`
5. `docs/27-STARTER-READINESS.md`

## 11) Offline starter check

Без установки contract tooling можно проверить структуру заготовки:

```bash
pnpm run verify:offline
```
