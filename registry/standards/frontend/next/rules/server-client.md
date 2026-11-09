---
id: "frontend.server-client"
title: "Server и Client Components"
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

# Server и Client Components

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

## Человек

Определяет нужную интерактивность и границы доступа к данным.

## Агент

Реализует поведение компонентов и проверяет изменение данных, загрузку и ошибку в браузере.

Контроль результата:

- Нет ли секретов в клиентской сборке? Зачем компоненту use client?

## Пример применения

Страница заказа загружает разрешённые данные на сервере. Кнопка изменения количества — небольшой Client Component; строка подключения к БД не передаётся в props.

## Источники

- [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components)
