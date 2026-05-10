# vibecoding-base 🧱✨

`vibecoding-base` — это composable registry для AI-native проектов.

Если по-человечески: это не папка "скопируй весь фреймворк". Это библиотека стандартов, stack profiles, templates и checks. Ты выбираешь стек, а в проект попадает только активный контекст. Все отключенное остается в registry и не захламляет проект.

## Зачем Это Нужно

Coding agents быстрые. Но без правил они быстро делают хаос:

- случайные папки;
- дубли стандартов;
- разные правила для почти одинаковых стеков;
- незаметный drift между framework-ами;
- стандарты, которые страшно обновлять;
- обещания "ready", хотя на самом деле готовы только docs.

Идея простая:

> Registry содержит все. Проект содержит только выбранный активный стек.

## Что Генерируется

Команда:

```bash
node tools/vibe.mjs use go-next-postgres --project ../my-app
```

создает:

```text
apps/api
apps/web
contracts/openapi
db/migrations
standards/active
scripts/check.sh
README.md
AGENTS.md
.vibe/profile.yaml
.vibe/enabled.yaml
.vibe/registry.lock
```

В проект не попадают отключенные части:

```text
mobile
desktop
worker
admin
payments
queue
ai
```

Они есть только в `registry`, пока ты явно их не включишь.

## Основные Команды

```bash
# Сгенерировать проект
node tools/vibe.mjs use go-next-postgres --project ../my-app

# Проверить registry и examples
node tools/vibe.mjs verify

# Посмотреть стандарты
node tools/vibe.mjs standards list

# Объяснить стандарт
node tools/vibe.mjs standards explain backend/go

# Включить опциональные части
node tools/vibe.mjs enable worker --project ../my-app
node tools/vibe.mjs enable mobile react-native --project ../my-app
node tools/vibe.mjs enable payments stripe --project ../my-app

# Отключить часть
node tools/vibe.mjs disable mobile --project ../my-app
```

## Структура Репозитория

```text
registry/
  standards/      версионируемые стандарты
  stacks/         YAML stack profiles
  templates/      части генерируемого проекта
  checks/         проверки registry и generated projects
  schemas/        schemas для standards, stacks и profiles
tools/
  vibe.mjs        минимальный CLI
examples/
  generated-go-next-postgres
  generated-python-react-postgres
docs/
  architecture.md
  contributing-standards.md
  stack-profiles.md
  standards-versioning.md
```

## Stack Profiles

Сейчас есть:

- `go-next-postgres`: Go API, Next.js web, PostgreSQL, OpenAPI.
- `python-react-postgres`: Python/FastAPI API, React web, PostgreSQL, OpenAPI.

Stack profile — это YAML-композиция:

```yaml
components:
  backend: go
  frontend: next
  database: postgres
  contracts: openapi
standards:
  - backend/go@^1.0.0
templates:
  - backend/go
checks:
  - check_structure
```

## Standards

Каждый standard — отдельная версионируемая единица:

```text
registry/standards/backend/go/
  standard.yaml
  standard.md
  checks.yaml
  CHANGELOG.md
  README.md
```

`standard.yaml` хранит owners, SemVer version, dependencies, enforcement reality и совместимые stacks.

Enforcement честный:

```yaml
enforcement:
  documented: true
  linted: false
  tested: false
  ci_blocking: false
```

Если правило только описано, так и пишем. Не притворяемся, что оно enforced.

## Status Matrix

У stack profile есть отдельная готовность:

- `template`: файлы генерируются.
- `runtime`: насколько готов runnable runtime.
- `checks`: насколько готовы автоматические проверки.
- `docs`: насколько готовы docs.

Так мы не называем стек "готовым", если реально готовы только документы.

## Для Контрибьюторов

Читать:

- [`docs/contributing-standards.md`](docs/contributing-standards.md)
- [`docs/standards-versioning.md`](docs/standards-versioning.md)
- [`docs/stack-profiles.md`](docs/stack-profiles.md)
