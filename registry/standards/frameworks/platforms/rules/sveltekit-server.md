---
schema_version: 1
id: "frameworks.sveltekit-server"
title: "SvelteKit: server-only modules"
section: "frameworks"
level: "recommended"
tags: ["sveltekit-server", "SvelteKit", "TypeScript"]
technologies: ["SvelteKit", "TypeScript"]
reviewed_at: "2026-11-09"
order: 115
related: ["security.secrets", "frontend.server-client"]
sources: ["https://svelte.dev/docs/kit/server-only-modules", "https://svelte.dev/docs/kit/load"]
---

# SvelteKit: server-only modules

## Коротко

Секреты и доступ к БД держите в серверных модулях; клиенту возвращайте только разрешённые поля.

## Плохо

```typescript
// +page.ts: универсальный load
import { db } from "$lib/db";
```

## Хорошо

```typescript
// +page.server.ts: только сервер
import { db } from "$lib/server/db";
export async function load() {
  return { products: await db.product.findMany({
    select: { id: true, title: true },
    orderBy: { id: "asc" }, take: 50
  }) };
}
```

## Почему

Универсальный код может попасть в клиентскую сборку. Серверная загрузка тоже передаёт возвращённые данные браузеру.

## Когда применять

SvelteKit 2; db — пример ORM-клиента проекта. В приватной выдаче добавьте проверку сессии и ограничение владельца. $lib/server и private env нельзя импортировать в клиентский код.

## Человек

Определяет, какие данные публичны.

## Агент

Размещает модуль на сервере, проверяет состав ответа и сборку.

## Пример применения

Каталог возвращает только id и title. Закупочная цена хранится в БД, но не включается в select и данные страницы.

## Как проверить

- Секреты отсутствуют в клиентской сборке.
- Ответ load не содержит закрытых полей.

## Источники

- [Server-only modules • SvelteKit Docs](https://svelte.dev/docs/kit/server-only-modules)
- [Loading data • SvelteKit Docs](https://svelte.dev/docs/kit/load)
