---
id: "frontend.server-client"
title: "Оставляйте на клиенте только нужную интерактивность"
section: "frontend"
level: "recommended"
tags: ["server-client", "Next.js", "React"]
technologies: ["Next.js", "React"]
reviewed_at: "2026-11-09"
order: 45
related: ["frontend.data-boundary", "frontend.derived-state"]
sources: ["https://nextjs.org/docs/app/getting-started/server-and-client-components"]
schema_version: 1
---

# Оставляйте на клиенте только нужную интерактивность

## Коротко

В Next.js загружайте серверные данные на сервере, а интерактивные части выделяйте отдельно.

## Плохо

```text
"use client" во всём дереве страниц, включая чтение секретов.
```

## Хорошо

```text
Server Component загружает данные.
Client Component управляет поиском и кнопками.
```

## Почему

Серверные секреты не должны попадать в браузер; лишний клиентский код увеличивает загрузку.

## Когда применять

Для App Router. В обычном React SPA серверных компонентов может не быть.

## Как проверить

- Нет ли секретов в клиентской сборке? Зачем компоненту use client?

## Источники

- [Первоисточник](https://nextjs.org/docs/app/getting-started/server-and-client-components)
