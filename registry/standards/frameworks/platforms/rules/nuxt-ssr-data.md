---
schema_version: 1
id: "frameworks.nuxt-ssr-data"
title: "Nuxt: useAsyncData и SSR"
section: "frameworks"
level: "recommended"
tags: ["nuxt-ssr-data", "Nuxt", "Vue", "TypeScript"]
technologies: ["Nuxt", "Vue", "TypeScript"]
reviewed_at: "2026-11-09"
order: 114
related: ["frontend.data-boundary", "caching.private-cache"]
sources: ["https://nuxt.com/docs/4.x/api/composables/use-async-data", "https://nuxt.com/docs/4.x/getting-started/data-fetching"]
---

# Nuxt: useAsyncData и SSR

## Коротко

Для данных страницы используйте SSR-aware composable с устойчивым ключом.

## Плохо

```typescript
// setup: запрос повторяется при гидратации
const products = await $fetch("/api/products");
```

## Хорошо

```typescript
const { data: products, status, error } =
  await useAsyncData("products", () => $fetch("/api/products"));
```

## Почему

useAsyncData передаёт серверный результат клиенту и согласует состояния запроса.

## Когда применять

Nuxt 4. Ключ должен учитывать параметры выдачи; один ключ с разными обработчиками недопустим. Для персональных данных отдельно проверяйте cookie, авторизацию и область кеша.

## Человек

Определяет публичность списка и требования к обновлению.

## Агент

Настраивает ключ, обработку status/error и проверяет SSR/гидратацию.

## Пример применения

Публичный каталог загружается через useAsyncData. При добавлении фильтра категории ключ включает её идентификатор; карточки показывают загрузку и ошибку.

## Как проверить

- При гидратации нет лишнего запроса того же результата.
- Смена фильтра меняет ключ или явно обновляет данные.

## Источники

- [useAsyncData · Nuxt Composables v4](https://nuxt.com/docs/4.x/api/composables/use-async-data)
- [Data Fetching · Get Started with Nuxt v4](https://nuxt.com/docs/4.x/getting-started/data-fetching)
