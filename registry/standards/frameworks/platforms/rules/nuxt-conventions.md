---
schema_version: 1
id: "frameworks.nuxt-conventions"
title: "Nuxt: структура app/server и правила регистрации"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["Nuxt 4", "Vue"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1211
related: ["frameworks.nuxt-ssr-data", "frameworks.vue-conventions"]
sources: ["https://nuxt.com/docs/4.x/directory-structure/app/pages", "https://nuxt.com/docs/4.x/directory-structure/server", "https://nuxt.com/docs/4.x/guide/going-further/runtime-config", "https://nuxt.com/docs/4.x/directory-structure/shared"]
---

# Nuxt: структура app/server и правила регистрации

## Коротко

Разделяйте приложение Vue, Nitro server и общий код по правилам версии Nuxt. Файловый маршрут, middleware и auto-import должны иметь понятную область; generated-файлы не являются местом ручной правки.

## Плохо

```text
Для Nuxt 4 скопирована структура Nuxt 2 с asyncData и старым runtime config.
Из app/composables импортируется server/db.
Секрет находится в runtimeConfig.public.
API защищено только клиентским route middleware.
```

## Хорошо

```text
Nuxt 4, стандартный srcDir:
app/app.vue                       оболочка с NuxtPage при использовании pages
app/pages/orders/[id].vue          страница /orders/:id
app/components/OrderCard.vue       компонент
app/composables/useOrders.ts       composable приложения
server/api/orders/[id].get.ts      GET /api/orders/:id, серверная авторизация
server/utils/orders.ts            серверная работа с данными
shared/types/order.ts             тип без runtime-зависимости от Vue/сервера
nuxt.config.ts                    конфигурация; private runtimeConfig отдельно
.nuxt/ и .output/                  генерируются, вручную не редактируются
```

## Почему

Nuxt создает маршруты и imports из структуры каталогов. Файл в неверной области может отсутствовать в приложении либо попасть в клиентскую сборку. Middleware навигации не заменяет проверку прямого вызова API.

## Когда применять

Nuxt 4.x. Пример использует стандартную структуру app; srcDir, layers и настройки auto-import могут менять пути. Зафиксируйте их в проекте. pages опционален: для одностраничной оболочки не создавайте пустые каталоги ради схемы.

Файлы pages дают маршруты UI, server/api — API с префиксом /api, server/routes — серверные маршруты без него. Суффикс .get/.post ограничивает HTTP-метод. Клиентский route middleware относится к навигации; сервер проверяет сессию/право при каждом чувствительном запросе.

app-композаблы используют Nuxt/Vue context; не импортируйте их в Nitro. shared содержит только подходящие обеим сторонам зависимости, не доступ к БД и не request state. Не считайте auto-import разрешением вызывать composable вне нужного lifecycle/context.

runtimeConfig.public включается в клиентский payload; секреты остаются в private части и читаются сервером. app.config также не место секретов. Проверяйте runtime environment отдельно от build environment. Новые имена компонентов/composables согласуйте с Vue-профилем, не маскируйте конфликт имени чужого auto-import.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Созданы page и GET API | Оба маршрута обнаружены, другой HTTP-метод обрабатывается по контракту | Production build и HTTP |
| Прямой вызов API без прохождения UI middleware | Сервер самостоятельно запрещает закрытую операцию | Отрицательный HTTP-тест |
| Секрет добавлен в runtimeConfig.public/shared import | Проверка выявляет утечку в payload/bundle | Поиск тестового маркера |
| Чистая сборка без старого .nuxt | Все типы/imports восстанавливаются штатно | Build из чистой копии |

Перенос каталога из Nuxt 2/3 требует отдельной проверки миграции, а не механической замены имени.

## Человек

Утверждает web/server границу, конфигурацию layers и доступные маршруты.

## Агент

Проверяет фактическую major-версию и auto-import, не редактирует generated output и проверяет серверный API напрямую.

## Источники

- [Nuxt 4: pages](https://nuxt.com/docs/4.x/directory-structure/app/pages)
- [Nuxt 4: server](https://nuxt.com/docs/4.x/directory-structure/server)
- [Nuxt 4: runtime config](https://nuxt.com/docs/4.x/guide/going-further/runtime-config)
- [Nuxt 4: shared directory](https://nuxt.com/docs/4.x/directory-structure/shared)
