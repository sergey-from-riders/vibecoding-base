---
schema_version: 1
id: "frameworks.sveltekit-conventions"
title: "SvelteKit: файлы маршрутов и контекст запроса"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["SvelteKit 2/3", "Svelte"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1212
related: ["frameworks.sveltekit-server", "frontend.server-client"]
sources: ["https://svelte.dev/docs/kit/project-structure", "https://svelte.dev/docs/kit/routing", "https://svelte.dev/docs/kit/state-management", "https://svelte.dev/docs/kit/migrating-to-sveltekit-3"]
---

# SvelteKit: файлы маршрутов и контекст запроса

## Коротко

Используйте специальные имена файлов SvelteKit по назначению: UI, универсальная загрузка, серверная загрузка и HTTP handler. Версию и aliases фиксируйте до генерации структуры; серверное состояние пользователя не храните в общем модуле.

## Плохо

```text
src/routes/orders/page.ts             ожидается автоматический маршрут
src/lib/current-user.ts              mutable singleton текущего пользователя
+page.ts импортирует БД
В одном приложении смешаны конфигурация/aliases SvelteKit 2 и 3.
```

## Хорошо

```text
src/routes/orders/+page.svelte        интерфейс /orders
src/routes/orders/+page.server.ts     серверная загрузка и допустимые actions
src/routes/api/orders/+server.ts      обработчики HTTP API
src/routes/+layout.svelte             общий layout
src/lib/components/OrderCard.svelte   повторно используемый UI
src/lib/server/orders.ts             серверная работа с данными
src/hooks.server.ts                  серверная подготовка request context
Сессия -> request locals -> ограниченные данные конкретного ответа.
```

## Почему

Файловый роутер распознает определенные имена, а универсальный load может выполняться на клиенте. Изменяемое состояние на уровне серверного модуля может пережить запрос и смешать пользователей.

## Когда применять

Файловый роутинг SvelteKit 2/3; пример показывает общие пути без version-specific imports. Зафиксируйте major и поддерживаемые версии Svelte/Vite/Node/adapter в приложении. В SvelteKit 2 стандартный alias — $lib, в SvelteKit 3 используется #lib через package imports; конфигурация и генерируемые типы также проверяются по migration guide. Не объявляйте один bootstrap универсальным.

+page.svelte и +layout.svelte содержат UI. +page.ts/+layout.ts — universal load; +page.server.ts/+layout.server.ts выполняют серверную загрузку. +server.ts экспортирует HTTP handlers, а не страницу. Form actions помещаются в server page по их контракту; API и action не дублируют одну бизнес-операцию несогласованно.

Имена собственных компонентов выбираются PascalCase, функций — по принятому JS/TS-профилю. Runes в Svelte 5 и legacy syntax не смешивают без причины; специальное имя файла важнее общей конвенции «назвать все PascalCase».

hooks.server формирует доверенный request context, но один guard в layout не заменяет проверку каждого закрытого API/action. Общий модуль может хранить неизменяемую конфигурацию или пул соединений; пользовательское mutable-состояние передается через locals/request. Static assets доступны публично, server-only код туда не кладут.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Чистая сборка и переход на /orders | Page обнаружена, server load не попадает в клиентский bundle | Build и HTTP/client navigation |
| Endpoint вызван напрямую без layout | Доступ проверен самим handler | Негативный HTTP-тест |
| Параллельные запросы двух пользователей | locals/ответы не смешиваются | Конкурентный тест |
| Изменена major-версия | Проверены aliases, config, generated types и adapter | Результат migration/build smoke |

Сходство имени файла с Next/Nuxt не делает его маршрутом SvelteKit.

## Человек

Выбирает major, adapter и область ответственности UI/load/action/API.

## Агент

Сверяет специальные имена и request context, не переносит конфигурацию из другого major и не создает server singleton пользователя.

## Источники

- [SvelteKit: project structure](https://svelte.dev/docs/kit/project-structure)
- [SvelteKit: routing](https://svelte.dev/docs/kit/routing)
- [SvelteKit: state management](https://svelte.dev/docs/kit/state-management)
- [SvelteKit 3: migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3)
