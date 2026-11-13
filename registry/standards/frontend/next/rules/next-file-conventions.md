---
id: "frontend.next-file-conventions"
title: "Имена файлов и маршруты Next.js"
section: "frontend"
level: "required"
tags: ["nextjs", "routing", "naming"]
technologies: ["nextjs"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1112
related: ["frontend.component-naming", "frontend.server-client", "languages.javascript-naming"]
sources: ["https://nextjs.org/docs/app/getting-started/project-structure", "https://nextjs.org/docs/app/api-reference/file-conventions/route"]
schema_version: 1
---

# Имена файлов и маршруты Next.js

## Коротко

В Next.js App Router имена специальных файлов и каталогов являются контрактом маршрутизации: page, layout, loading, error, not-found, route и динамические сегменты имеют заданное значение.

## Плохо

```text
app/orders/Page.tsx          # переименован из page.tsx ради PascalCase
app/orders/Route.ts          # framework contract потерян
export function get() {}     # не экспорт HTTP GET в route.ts
```

## Хорошо

```text
app/orders/page.tsx: export default function OrdersPage() { ... }
app/orders/layout.tsx: export default function OrdersLayout({ children }) { ... }
app/api/orders/route.ts: export async function GET(request) { ... }
app/orders/[orderId]/page.tsx: динамический segment по контракту Next.js
Обычный компонент InvoiceCard: отдельный файл по соглашению проекта.
```

## Почему

Имена специальных файлов управляют обнаружением маршрутов; общий стиль идентификаторов не может менять API фреймворка.

## Когда применять

Next.js App Router 16.x; документация структуры с отображаемой версией 16.4.6 проверена 2026-11-13. Примеры — схема размещения, многоточия не являются готовым TSX. Pages Router и предыдущие версии имеют свои conventions; это правило не требует мигрировать существующее приложение.

### Подробные условия

Сохраняй их написание и поддерживаемое расширение; PascalCase применяется к имени компонента, а не к замене page.tsx на Page.tsx.

Обычные файлы организуй по принятому соглашению; не создавай специальные файлы, пока они не нужны маршруту. Для route.ts имена HTTP-методов экспортируются по API Next.js; обычные внутренние функции остаются camelCase. Учитывай версию: в 16.x используется convention proxy, а перенос старого middleware выполняется по руководству миграции и проверкам поведения, не простым массовым переименованием.

## Как проверить

- page.tsx с OrdersPage → собрать и запросить маршрут → страница обнаружена.
- Файл заменен на Page.tsx либо get вместо GET → проверить маршрут → ошибка выявлена до публикации.
- Переход с предыдущей версии → проверить руководства и маршрутные проверки → поддерживаемые имена и поведение подтверждены без слепой замены.

## Человек

Выбирает структуру обычных файлов и принимает миграцию версии.

## Агент

Сверяет специальные имена с установленной Next.js, сохраняет PascalCase символов и проверяет обнаружение маршрута сборкой/запросом.

## Источники

- [Next.js App Router: Project Structure](https://nextjs.org/docs/app/getting-started/project-structure) — Routing files and organization; fixed names are framework contracts.
- [Next.js App Router: Route Handlers](https://nextjs.org/docs/app/api-reference/file-conventions/route) — HTTP method exports, route file convention and version history.
