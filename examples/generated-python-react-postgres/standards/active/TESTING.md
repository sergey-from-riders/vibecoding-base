<!-- Generated from registry/standards/testing/tdd-strict@1.0.1. Update the registry standard, then regenerate. -->

# 17. Testing, TDD and Quality Gates (Mandatory)

Этот документ обязателен для всех изменений в generated project.

Главный принцип: **фича не считается принятой, пока не написаны и не пройдены тесты**.

## 1) Vibe Coding Through Testing

Для каждой задачи применяется цикл `Red -> Green -> Refactor`:

1. `Red`: сначала пишем тесты под новый сценарий и убеждаемся, что они падают.
2. `Green`: реализуем минимальный код, чтобы тесты стали зелеными.
3. `Refactor`: улучшаем код без изменения поведения и снова прогоняем тесты.
4. Обновляем документацию и фиксируем evidence (какие наборы тестов прошли).

Без этого цикла задача не закрывается.

## 2) Обязательный тестовый минимум для backend

Каждый backend-модуль (`apps/api/internal/<module>`) обязан иметь:

1. Unit tests:
- service layer;
- бизнес-правила;
- обработку ошибок и валидацию.

2. Integration tests (реальные, не мокнутые end-to-end внутри backend):
- HTTP handler -> service -> repository -> PostgreSQL;
- проверка миграций и ограничений схемы;
- проверка security-инвариантов (auth/session/revoke/switch company).

3. Regression cases:
- каждый баг фиксируется тестом, который падал до исправления;
- каждый новый endpoint имеет как минимум happy-path + negative-path интеграционные сценарии.

## 3) Обязательный тестовый минимум для frontend (web)

Каждая frontend-фича обязана иметь:

1. Component/unit tests:
- рендеринг состояния;
- ветки UI-логики;
- обработку ошибок/пустых состояний.

2. Integration tests:
- взаимодействие страниц/виджетов;
- контракты с API (через тестовый backend или контрактные моки);
- критические сценарии auth/sessions/company switch.

3. E2E smoke + feature flow:
- Playwright-сценарий на ключевой путь фичи;
- обязательный smoke на login -> me -> switch company -> sessions UI;
- отдельный прогон в Telegram-совместимом web-режиме для web-клиента.

## 4) Универсальный тестовый аккаунт (обязательный)

Для межфичевого regression используется единый seed-аккаунт в test/stage окружениях.

Назначение:
- после каждой фичи прогонять сквозной сценарий "все основные темы";
- проверять, что новые изменения не ломают старые auth/session/company сценарии.

Минимальный профиль universal account:
- активированный пользователь;
- membership минимум в 2 компаниях;
- привязанные identity: `password`, `telegram`, `google` (и другие провайдеры по мере подключения);
- несколько активных сессий (для проверки revoke-one/revoke-others).

Правила:
- только non-production окружения;
- учетные данные хранятся в secrets manager/CI secrets;
- plaintext пароли в репозиторий не коммитятся.

## 5) CI/CD quality gates (без исключений)

Пайплайн обязателен в таком порядке:

1. `verify-backend`
- lint/static checks;
- go limits check (`tools/scripts/check_go_limits.sh apps/api`);
- unit tests;
- integration tests с PostgreSQL.

2. `verify-frontend`
- typecheck/lint;
- web limits check (`tools/scripts/check_web_limits.sh apps/web`);
- component/integration tests;
- Playwright e2e (минимум smoke + измененная фича).

3. `verify-db`
- миграции `up/down` в тестовой БД;
- static DB contract check (`tools/scripts/check_db_contract.sh db/migrations`);
- проверки naming/versioning-контрактов.

4. `verify-contracts`
- OpenAPI bundle build (`tools/scripts/build_openapi_bundle.sh`);
- OpenAPI coverage check (`tools/scripts/check_openapi_coverage.sh`).

5. `verify-desktop-qt`
- c++ limits check (`tools/scripts/check_cpp_limits.sh apps/desktop/qt`);
- sanitizer/static-analysis/test набор для desktop модулей.

6. `build-images`
- выполняется только после успешных verify jobs.

7. `deploy`
- выполняется только после успешной сборки;
- после деплоя запускается post-deploy smoke.

Если любой verify/job падает, deploy блокируется.

## 6) Gate для merge и приемки задачи

Feature branch не может быть принята, если:
- нет новых/обновленных тестов под измененное поведение;
- не пройден backend integration для затронутых модулей;
- не пройден frontend e2e для затронутых пользовательских сценариев;
- не пройден universal-account regression pack.

## 7) Definition of Done для фичи

Фича считается готовой только когда одновременно выполнено:

1. Контракт и код синхронизированы.
2. Тесты написаны до финального кода (TDD-процесс соблюден).
3. Все обязательные тестовые наборы зеленые локально и в CI.
4. Build и deploy не обошли test gates.
5. Документация обновлена в том же изменении.
