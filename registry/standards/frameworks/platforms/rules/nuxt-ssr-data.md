---
schema_version: 1
id: "frameworks.nuxt-ssr-data"
title: "Nuxt: useAsyncData и SSR"
section: "frameworks"
level: "recommended"
tags: ["nuxt-ssr-data", "Nuxt", "Vue", "TypeScript"]
technologies: ["Nuxt", "Vue", "TypeScript"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 114
related: ["frontend.data-boundary", "caching.private-cache"]
sources: ["https://nuxt.com/docs/4.x/api/composables/use-async-data", "https://nuxt.com/docs/4.x/getting-started/data-fetching", "https://nuxt.com/docs/4.x/api/composables/use-request-fetch"]
---

# Nuxt: useAsyncData и SSR

## Коротко

Для данных страницы используйте SSR-aware useAsyncData/useFetch с согласованным ключом и возвращаемым результатом. Персональная загрузка должна использовать контекст текущего запроса и очищаться при смене сессии.

## Плохо

```vue
<script setup lang="ts">
const profile = await $fetch('/api/me');
// Сам по себе $fetch не передает результат через SSR payload
// и не обещает передачу cookies текущего пользователя на сервере.
</script>
```

## Хорошо

```vue
<script setup lang="ts">
const requestFetch = useRequestFetch();
const { data: profile, error, clear } = await useAsyncData(
  'session-profile',
  (_nuxtApp, { signal }) => requestFetch<{ displayName: string }>('/api/me', { signal })
);
// /api/me аутентифицирует пользователя и возвращает только displayName.
// Обработчик выхода/смены аккаунта вызывает clear до загрузки новой сессии.
</script>
```

## Почему

SSR payload позволяет использовать уже полученные данные при гидратации. Но один ключ означает общее состояние внутри приложения: несогласованная схема или незавершенная загрузка старой сессии могут показать неподходящий результат.

## Когда применять

Nuxt 4.x. Пример использует относительный endpoint того же приложения; `useRequestFetch` переносит поддерживаемый контекст SSR-запроса. `useFetch` для относительного URL уже использует такой механизм. Не пересылайте cookies и заголовки пользователя произвольному внешнему URL.

`/api/me` проверяет сессию на сервере, возвращает ограниченный объект либо согласованную ошибку и не сохраняет персональный ответ в общем prerender/CDN/server cache. В примере profile — состояние текущей сессии; при logout/смене пользователя очистите его, отмените незавершенный запрос и не допускайте повторного отображения старого результата. Это обязанность auth-flow, не автоматический эффект имени ключа.

Handler должен возвращать определенный truthy-результат, например объект или массив, а не undefined/null; иначе возможен повтор на клиенте. Он не выполняет бизнес-операцию с побочным эффектом. Для меняющихся параметров используйте реактивный key либо явный watch, например ключ, включающий проверенный ID категории.

При одном ключе согласуйте handler, deep, transform, pick, getCachedData, default и массив middleware, если он поддерживается установленной версией. Не все опции обязаны совпадать: server/lazy/immediate и другие разрешенные документацией настройки могут различаться. Проверяйте список для установленной minor-версии.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| SSR страницы и первая гидратация без изменения параметров | Используется payload; нет повторного запроса из-за потерянного результата | Серверный счетчик и browser network |
| Handler возвращает пустой массив; отдельно undefined | Массив сохраняется корректно; недопустимый undefined выявлен тестом | Сценарий payload/hydration |
| Одновременные SSR-запросы двух пользователей | Каждый получает только свой профиль | Два cookie-контекста и ответы |
| Выход или смена аккаунта во время запроса | Старые данные очищены, поздний ответ не возвращает старый профиль | Проверка гонки и интерфейса |
| Параметр категории/ID изменился; тот же key использован с другой схемой | Параметр вызывает нужную загрузку; конфликт key не остается незамеченным | Тест маршрута и предупреждений |

Само отсутствие второго сетевого запроса не доказывает изоляцию персонального кеша.

## Человек

Определяет публичность данных, форму результата и жизненный цикл сессии.

## Агент

Проверяет cookies на SSR, payload и смену аккаунта, а не только happy path в браузере. Не считает ключ авторизацией.

## Источники

- [Nuxt 4: useAsyncData](https://nuxt.com/docs/4.x/api/composables/use-async-data)
- [Nuxt 4: data fetching](https://nuxt.com/docs/4.x/getting-started/data-fetching)
- [Nuxt 4: useRequestFetch](https://nuxt.com/docs/4.x/api/composables/use-request-fetch)
