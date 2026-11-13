---
schema_version: 1
id: "frameworks.sveltekit-server"
title: "SvelteKit: server-only modules"
section: "frameworks"
level: "recommended"
tags: ["sveltekit-server", "SvelteKit", "TypeScript"]
technologies: ["SvelteKit", "TypeScript"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 115
related: ["security.secrets", "frontend.server-client"]
sources: ["https://svelte.dev/docs/kit/server-only-modules", "https://svelte.dev/docs/kit/load", "https://svelte.dev/docs/kit/migrating-to-sveltekit-3"]
---

# SvelteKit: server-only modules

## Коротко

БД и секреты импортируйте только в server-only код. В ответ load возвращайте явный набор разрешенных полей; серверное выполнение не делает результат приватным от браузера.

## Плохо

```typescript
// src/routes/orders/+page.ts: может выполняться в браузере.
import { db } from '$lib/db';
export const load = () => db.order.findMany();
```

## Хорошо

```typescript
// SvelteKit 2, src/routes/orders/+page.server.ts
import { error } from '@sveltejs/kit';
import { db } from '$lib/server/db';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
  if (!locals.user) error(401, 'Требуется вход');
  const orders = await db.order.findMany({
    where: { ownerId: locals.user.id },
    select: { id: true, title: true },
    orderBy: { id: 'asc' },
    take: 50,
  });
  return { orders };
};
```

## Почему

Server-only проверка защищает импортную границу, в том числе через промежуточный barrel. Данные, возвращенные из server load, сериализуются клиенту; поэтому даже допустимый серверный импорт не оправдывает возврат полной модели или секретов.

## Когда применять

Пример рассчитан на SvelteKit 2: alias `$lib` и генерируемый `./$types`. `db` — настроенный ORM-клиент приложения с указанными полями, не встроенный API SvelteKit. `locals.user` типизирован в проекте и заполнен серверной проверкой сессии, а не значением из тела запроса.

В SvelteKit 3 справочник изменил alias на `#lib` через package imports и схему некоторых генерируемых типов; не копируйте пути между major-версиями без проверки migration guide. Общая граница `src/lib/server` и server load сохраняет смысл, но синтаксис проекта определяется его версией.

В контракте ответа здесь только `orders[].id` и `orders[].title`. Лимит 50 — пример ограниченной первой страницы; большой список получает свой контракт пагинации. Не сериализуйте пароль, token, внутренние поля, ORM-ошибку или debug-объект. Проверяйте права и при последующих запросах: server-only не заменяет authorization.

Закрытые environment modules и `src/lib/server` не импортируются в универсальные load, компоненты или общий barrel. Build-проверка важна: unit-runner может отключать обнаружение недопустимых импортов при `TEST=true`.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Пользователь читает список | Только его id/title, ограниченный размер | HTML/payload и последующая client navigation |
| Нет сессии или попытка чтения чужого объекта | Согласованный отказ, чужие поля отсутствуют | HTTP-проверка и запрос БД |
| В общий barrel добавлен реэкспорт server-only модуля | Production build отклоняет клиентскую цепочку импорта | Негативная сборка вне TEST=true |
| ORM падает и включена обработка ошибок | Клиент не видит credentials, SQL или внутренний stack | Проверка error response и payload |

Проверка TypeScript без сборки не подтверждает границу серверного bundle.

## Человек

Утверждает поля клиентского ответа и модель доступа к записям.

## Агент

Сверяет major SvelteKit, imports и источник locals.user. Проверяет прямой и транзитивный импорт, а также сериализованные данные.

## Источники

- [SvelteKit: server-only modules](https://svelte.dev/docs/kit/server-only-modules)
- [SvelteKit: load](https://svelte.dev/docs/kit/load)
- [SvelteKit 3: migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3)
