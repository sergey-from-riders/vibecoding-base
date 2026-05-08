# vibecoding-base 🧱✨

Готовые копируемые AI-native фреймворки репозиториев для разработки с coding agents.

Если совсем просто: `vibecoding-base` — это библиотека заготовок репозиториев. Ты выбираешь стек, копируешь папку, переименовываешь под свой продукт и начинаешь разрабатывать с AI-агентом, у которого уже есть правила, контракты, проверки и ограничения.

Это не магия. Это не готовое приложение. Это нормальная база, чтобы агент не превращал пустой репозиторий в кашу из случайных файлов.

## Главная Идея 🧠

Coding agents работают быстро. Очень быстро. Но если в репозитории нет структуры, агент начинает угадывать:

- куда класть backend;
- как описывать API;
- как менять базу данных;
- какие тесты нужны;
- что нельзя коммитить;
- что значит "готово";
- когда нужен человеческий review.

Угадывание — это место, где начинается хаос.

`vibecoding-base` дает агенту карту до того, как он начнет писать код.

Карта выглядит так:

```text
правила -> контракты -> тесты -> реализация -> документация -> проверки -> review
```

Вот в этом вся идея.

## Что Внутри? 📦

Этот репозиторий — каталог. Каждый элемент каталога — полноценный framework репозитория.

В каждом framework обычно есть:

- `AGENTS.md` — правила для AI coding agents;
- `FRAMEWORK.md` — как людям и агентам работать в этом репозитории;
- `README.md` — инструкция конкретного framework;
- OpenAPI contracts;
- inventory endpoint-ов;
- миграции базы данных;
- примеры env-файлов;
- security policy;
- contribution policy;
- CI workflow;
- локальные quality gates;
- проверка чистоты шаблона;
- playbooks для agentic delivery;
- docs и ADR.

То есть вместо того, чтобы дать агенту пустую папку и сказать "сделай приложение", ты даешь ему репозиторий, который уже говорит:

> "Вот как тут принято работать. Следуй правилам."

## Доступные Frameworks 🚀

| Framework | Stack | Когда Брать |
| --- | --- | --- |
| [`go-next-postgres`](frameworks/go-next-postgres) | Go + Next.js + PostgreSQL | Нужен строгий backend service layer, contract-first API и full-stack web база. |
| [`python-react-postgres`](frameworks/python-react-postgres) | Python/FastAPI + React + PostgreSQL | Нужен Python backend, React frontend и такая же дисциплина для AI-разработки. |

Позже можно добавлять новые:

```text
node-react-postgres
rust-react-postgres
php-laravel-inertia
python-next-postgres
go-react-postgres
```

## Чем Это Не Является 🚫

Это не готовый продукт.

Тут нет:

- готового SaaS-приложения;
- готового красивого auth UI;
- production runtime-кода;
- реальных deploy credentials;
- настоящих env-значений;
- уже поднятой облачной базы данных.

Тут есть фундамент проекта. Сам продукт все равно нужно строить.

Разница в том, что ты строишь не с пустого места, а на понятных рельсах.

## Для Кого Это? 👥

Используй `vibecoding-base`, если:

- ты работаешь с ChatGPT, Codex, Claude Code, Copilot, Cursor или другими coding agents;
- хочешь, чтобы агент следовал правилам репозитория, а не придумывал архитектуру на ходу;
- хочешь contract-first API;
- хочешь миграции базы с первого дня;
- не хочешь случайно закоммитить секреты;
- хочешь повторяемые проверки;
- хочешь starter серьезнее, чем "hello world";
- хочешь делать несколько проектов в одном стиле.

Не используй, если:

- тебе нужно сразу увидеть готовую визуальную аппку после clone;
- тебе не нужны docs и процесс;
- ты делаешь быстрый одноразовый прототип без контрактов;
- ты хочешь, чтобы AI принимал все архитектурные решения сам.

## Быстрый Старт 🏁

Склонируй каталог:

```bash
git clone <repo-url> vibecoding-base
cd vibecoding-base
```

Проверь весь каталог:

```bash
tools/scripts/check_frameworks.sh
```

Выбери framework:

```bash
cp -a frameworks/go-next-postgres ../my-product
cd ../my-product
```

Или Python/React:

```bash
cp -a frameworks/python-react-postgres ../my-product
cd ../my-product
```

Поставь зависимости:

```bash
pnpm install
```

Запусти проверки:

```bash
pnpm run verify:offline
pnpm run verify:contracts
pnpm run template:check
```

Если все прошло — framework чистый и готов становиться твоим продуктовым репозиторием.

## Что Переименовать После Копирования ✍️

После копирования framework в новый репозиторий переименуй очевидные вещи:

1. `package.json`
   - поменяй `name`;
   - поменяй `description`;
   - оставь `"private": true`, если это не npm package.

2. `README.md`
   - замени название framework на название продукта;
   - оставь секции с командами;
   - оставь security notes.

3. `packages/contracts/openapi/openapi.root.yaml`
   - поменяй title API;
   - поменяй summary;
   - оставь `example.test`, пока нет реального публичного домена.

4. Env examples
   - оставь `APP_*`;
   - оставь `NEXT_PUBLIC_APP_*`;
   - не коммить реальные `.env`.

5. Настройки GitHub
   - включи template repository, если хочешь, чтобы другие копировали;
   - включи security advisories, если хостинг поддерживает;
   - не выключай CI.

## Как Должен Работать Агент 🤖

Агент не должен сразу прыгать в файлы.

Для серьезных задач скажи ему сначала прочитать:

- `AGENTS.md`;
- `FRAMEWORK.md`;
- нужные docs в `docs/`;
- нужный playbook в `agents/playbooks/`.

Хороший prompt:

```text
Read AGENTS.md and FRAMEWORK.md first.

Task:
Implement the login backend vertical slice.

Scope:
apps/api, packages/contracts, db/migrations, docs.

Non-goals:
No UI, no OAuth providers, no Android/Qt changes.

Required docs:
docs/17-TESTING-TDD-QUALITY-GATES.md
docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md
docs/22-OBSERVABILITY-STANDARD.md

Validation:
pnpm run verify:offline
pnpm run verify:contracts

Output:
- changed files
- validation results
- unresolved risks
```

Плохой prompt:

```text
сделай все приложение
```

Такой prompt дает агенту слишком много свободы. Слишком много свободы часто рождает случайную архитектуру.

## Основной Workflow 🔁

Любая нормальная feature должна идти так:

```text
Scope
  -> Contract
  -> Tests
  -> Implementation
  -> Observability
  -> Docs
  -> Checks
  -> Review
```

По-человечески:

1. **Scope**
   Решаем, что входит в задачу, а что не входит.

2. **Contract**
   Сначала OpenAPI и миграции, потом runtime-код.

3. **Tests**
   Добавляем падающие тесты или фиксируем, какая проверка должна падать до исправления.

4. **Implementation**
   Делаем минимальный полезный vertical slice.

5. **Observability**
   Добавляем request id, logs, traces, metrics и правила скрытия секретов.

6. **Docs**
   Обновляем документацию в том же изменении.

7. **Checks**
   Запускаем локальные проверки и CI.

8. **Review**
   Человек смотрит результат, особенно если есть auth, данные, deploy или security.

## Что Такое Vertical Slice? 🍰

Vertical slice — это один полностью рабочий путь через систему.

Например:

```text
OpenAPI login endpoint
  -> поля в базе
  -> backend service
  -> HTTP handler
  -> tests
  -> logs/traces
  -> docs
```

Это лучше, чем сделать 50 пустых файлов "на будущее".

Vertical slice доказывает, что система реально работает.

## Зачем OpenAPI? 📜

OpenAPI — это контракт API. Он говорит людям, агентам, тестам и будущим SDK, как API должен себя вести.

В каждом framework:

```text
packages/contracts/openapi/
```

Важные файлы:

- `openapi.root.yaml` — главный контракт;
- `modules/*.yaml` — группы endpoint-ов;
- `components/schemas/*.yaml` — общие схемы;
- `endpoints.inventory.tsv` — список endpoint-ов для проверок;
- `dist/` — сгенерированные артефакты.

Если меняешь endpoint — сначала меняй контракт.

## Зачем Миграции Базы? 🗄️

Структура базы — это не побочный эффект. Это часть продуктового контракта.

Миграции тут:

```text
db/migrations/
```

Правила:

- миграции только append-only;
- up/down парами;
- UUID для domain entities;
- не использовать generic `id`;
- токены и парольный материал хранить только как hash;
- версионировать business entities, если это требуется стандартом framework.

## Зачем Столько Проверок? ✅

Потому что агенты достаточно быстрые, чтобы быстро наделать много ошибок.

Проверки — это дешевые тормоза.

Обычные команды внутри framework:

```bash
pnpm run verify:offline
pnpm run verify:contracts
pnpm run template:check
```

Что они ловят:

- отсутствующие обязательные файлы;
- сломанные DB contracts;
- слишком большие файлы/функции;
- отсутствующие OpenAPI examples;
- отсутствующие строки в endpoint inventory;
- остатки старого проекта;
- типичные формы секретов;
- небезопасные leftovers в template.

## Тур По Папкам 🧭

Корень каталога:

```text
vibecoding-base/
├─ README.md              # выбор языка
├─ README.en.md           # документация на английском
├─ README.ru.md           # документация на русском
├─ FRAMEWORK.md           # модель всего каталога
├─ catalog.json           # машинно-читаемый каталог frameworks
├─ frameworks/            # копируемые frameworks
└─ tools/scripts/         # проверки каталога
```

Внутри framework:

```text
framework/
├─ AGENTS.md              # правила для coding agents
├─ FRAMEWORK.md           # delivery model конкретного framework
├─ README.md              # документация framework
├─ docs/                  # standards, architecture, ADR
├─ agents/playbooks/      # пошаговые agent workflows
├─ apps/                  # будущие runtime apps
├─ packages/contracts/    # OpenAPI contracts
├─ db/migrations/         # SQL migrations
├─ infra/                 # Docker, Nginx, CI examples
└─ tools/scripts/         # checks and helper scripts
```

## Каталог Frameworks 🗂️

Каталог лежит тут:

```text
catalog.json
```

Там указаны:

- framework id;
- человекочитаемое имя;
- path;
- status;
- backend;
- frontend;
- database;
- best use cases.

Если добавляешь новый framework — добавь его в `catalog.json`.

## Как Добавить Новый Framework 🧩

Создай папку:

```text
frameworks/<language>-<frontend>-<database>/
```

Примеры:

```text
frameworks/node-react-postgres/
frameworks/rust-react-postgres/
frameworks/php-laravel-inertia/
```

Минимально нужны:

- `README.md`;
- `FRAMEWORK.md`;
- `AGENTS.md`;
- `LICENSE`;
- `SECURITY.md`;
- `CONTRIBUTING.md`;
- `package.json` или другой понятный command manifest;
- `tools/scripts/check_starter_integrity.sh`;
- `tools/scripts/check_template_clean.sh`;
- OpenAPI baseline;
- env examples;
- CI workflow или CI example.

Потом запускай:

```bash
tools/scripts/check_frameworks.sh
```

Если проверка падает — framework еще не готов.

## Checklist Перед Публикацией 🚢

Перед публикацией каталога:

```bash
tools/scripts/check_frameworks.sh
```

Потом руками проверь:

- нет `node_modules`;
- нет `.venv`;
- нет реальных `.env`;
- нет приватных IP;
- нет путей с реальных серверов;
- нет настоящих tokens/API keys;
- `catalog.json` совпадает с папками;
- у каждого framework есть docs;
- каждый framework проходит свои локальные проверки.

## FAQ 🙋

### Это boilerplate?

Не совсем. Boilerplate обычно дает код приложения. Это дает operating model репозитория.

### Можно из этого сделать реальное приложение?

Да. Копируешь framework и начинаешь реализовывать vertical slices.

### Почему просто не попросить AI создать все?

Можно. Но без правил результат менее предсказуемый. Этот проект дает AI стабильную форму, которой нужно следовать.

### Почему некоторые app-папки пустые?

Потому что это foundation. Runtime-код должен добавляться маленькими scoped vertical slices, а не большим хаотичным комком.

### Почему в `package.json` стоит `private: true`?

Чтобы случайно не опубликовать это в npm. GitHub-репозиторий при этом может быть публичным.

### Можно удалить Android или Qt?

Да. Если продукту они не нужны, удали папки и документы вместе. Не оставляй мертвые правила, которым агент будет пытаться следовать.

### Можно использовать другой стек?

Да. Добавь новый framework в `frameworks/`.

## License 📄

MIT. Смотри [LICENSE](LICENSE).
