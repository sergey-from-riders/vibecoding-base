# 12. Переменные Окружения, Репозиторий И Развертывание (Nginx + Разные Порты Приложений)

Этот документ фиксирует, где и как хранятся переменные окружения, как устроен репозиторий и как выполняется развертывание на удаленный сервер.

## 1) Репозиторий

### Приложения
- `apps/api` — серверная часть (Python), слушает `18031` внутри контейнера/на хосте
- `apps/web` — frontend (React), слушает `18030` внутри контейнера/на хосте
- `apps/mobile/android` — Android-приложение с WebView-оболочкой
- `apps/desktop/qt` — нативный desktop-клиент

### Инфраструктура
- `infra/docker/docker-compose.server.yml` — стек развертывания для сервера
- `infra/nginx/ai-app.conf.example` — шаблон конфигурации reverse proxy

## 2) Где лежат переменные окружения

### В репозитории (только шаблоны)
- `/.env.example` — глобальные переменные
- `/apps/api/.env.example`
- `/apps/web/.env.example`
- `/apps/mobile/android/.env.example`
- `/apps/desktop/qt/.env.example`
- `/infra/docker/.env.example`
- `/env/examples/testing.env.example` — шаблон переменных для CI/e2e

### На сервере (реальные значения)
- `/opt/ai-app/infra/docker/.env` — рабочие значения для Docker Compose
- секреты не коммитятся в Git

## 3) Соглашение по именам переменных
- backend и серверные переменные: `APP_*`
- переменные, доступные в браузере: только `NEXT_PUBLIC_APP_*`
- секреты (`DB password`, токены и т.п.) только в серверном `.env` или в менеджере секретов
- e2e/universal-account переменные: `APP_E2E_*` (только в CI secrets/test env, не в Git)

## 4) Портовая схема (обязательная)
- `web`: `127.0.0.1:18030`
- `api`: `127.0.0.1:18031`
- `nginx`: `:80`/`:443`

Трафик:
- `https://app.example.test/` -> web `18030`
- `https://app.example.test/api/` -> api `18031`

## 5) Nginx как reverse proxy
Файл-шаблон:
- `infra/nginx/ai-app.conf.example`

Обязательные заголовки:
- `Host`
- `X-Real-IP`
- `X-Forwarded-For`
- `X-Forwarded-Proto`

Для websocket/streaming на web:
- `Upgrade`
- `Connection: upgrade`

## 6) Процесс развертывания на удаленный сервер

### Предусловия
- Docker + плагин Docker Compose
- Nginx установлен и настроен
- директория проекта на сервере: `/opt/ai-app` (пример)
- в registry уже опубликованы образы `api` и `web`
- обязательные test gates уже пройдены в CI (`docs/17-TESTING-TDD-QUALITY-GATES.md`)

### Что именно доставляется на сервер
Мы используем image-based модель:
- на сервере не выполняется сборка исходного кода приложений;
- сервер скачивает готовые образы из registry;
- на сервер синхронизируются только deployment-манифесты (`infra/docker`, `infra/nginx`).

### Шаги
1. Убедиться, что CI stage `verify-*` и `build-images` завершены успешно.
2. Обновить теги образов в `/opt/ai-app/infra/docker/.env`:
   - `APP_API_IMAGE=...:tag`
   - `APP_WEB_IMAGE=...:tag`
3. Проверить/обновить `/opt/ai-app/infra/docker/.env`
4. Запустить:
   - `docker compose --env-file .env -f docker-compose.server.yml pull`
   - `docker compose --env-file .env -f docker-compose.server.yml up -d --remove-orphans`
5. Проверить `nginx -t && systemctl reload nginx`
6. Выполнить post-deploy smoke (api health + web health + auth smoke)
7. При fail smoke — откат к предыдущим image tags

Автоматизированный вариант:
- `tools/scripts/deploy_remote.sh` (синхронизирует `infra/docker` и `infra/nginx`, поднимает контейнеры)
- после изменения конфига Nginx на сервере обязательно: `nginx -t && systemctl reload nginx`

## 7) База данных и миграции
- Миграции находятся в `db/migrations`
- Применяются как отдельный шаг развертывания перед/во время обновления API
- Никаких ручных SQL-изменений в production

## 8) Telegram Mini App
- Web должен открываться как обычный сайт и внутри Telegram WebView.
- Для Telegram используются launch params/theme params, но backend URL остается тем же через Nginx (`/api`).

## 9) Что нельзя делать
- Нельзя публиковать api/web напрямую наружу, в обход Nginx.
- Нельзя хранить секреты в `.env.example`.
- Нельзя смешивать порты web и api на одном серверном порту.

## 10) Дополнительно
- Быстрый первый запуск: `docs/23-QUICK-START-5-MIN.md`
- Сравнение вариантов и обоснование: `docs/13-DEPLOYMENT-MODEL-OPTIONS.md`
- Политика тестирования и quality gates: `docs/17-TESTING-TDD-QUALITY-GATES.md`
