---
id: "frontend.server-client"
title: "Server и Client Components"
section: "frontend"
level: "recommended"
tags: ["server-client", "Next.js", "React"]
technologies: ["Next.js", "React"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 45
related: ["frontend.data-boundary", "frontend.hooks", "frontend.next-file-conventions", "security.object-access"]
sources: ["https://nextjs.org/docs/app/getting-started/server-and-client-components", "https://nextjs.org/docs/app/guides/data-security"]
schema_version: 1
---

# Server и Client Components

## Коротко

В Next.js App Router держи секреты, доступ к БД и проверку объектных прав в серверном коде.

## Плохо

```text
Верхний layout: use client; он импортирует модуль БД с credentials.
Клиенту передается полная запись пользователя.
Server Action доверяет userId из формы, потому что страницу защитили.
```

## Хорошо

```text
Server Component → server-only чтение с проверкой session/объекта.
DTO: только нужные поля → Client Component с интерактивной кнопкой.
Server Action: заново проверяет сессию, вход и объектные права.
Проверка: прямой вызов без прав отклонен; секретов в client output нет.
```

## Почему

Место исполнения и сериализация определяют доступный код и данные, но не доказывают авторизацию конкретного запроса.

## Когда применять

Next.js App Router 16.x; на 2026-11-13 проверена документация, показывающая 16.4.6. Для Pages Router и другой версии проверь применимые механизмы отдельно. Не требуй client-boundary вокруг статического UI и не обещай, что серверные компоненты вообще не передают данные браузеру.

### Подробные условия

Клиентская граница нужна для интерактивности, browser API и клиентских hooks. Директива `use client` задает границу графа импортов: ее зависимости попадают в клиентскую часть, даже если файл не содержит директиву. Переданный как children серверный результат не равен импорту серверного модуля клиентом.

Используй `server-only` для модулей, которым нельзя попасть в клиентский граф, и проверь фактическую сборку. Props на этой границе должны быть поддержаны сериализацией React и содержать только разрешенные клиенту данные. Скрытие кнопки, page-level auth и непредсказуемый ID Server Action не заменяют проверку пользователя и прав непосредственно при чтении/изменении. Вход Server Action недоверен; рассматривай доступное action как вызываемую напрямую HTTP-операцию.

## Как проверить

- Интерактивный дочерний компонент → собрать → клиентский граф содержит нужную логику без server-only зависимости.
- Попытка импортировать server-only модуль из client graph → собрать → инструмент сообщает нарушение; в артефакт не принимается секрет.
- Прямой вызов action с чужим object ID → выполнить интеграционную проверку → отказ независимо от видимости кнопки.

## Человек

Определяет допустимый DTO и серверную политику доступа.

## Агент

Проверяет граф импортов и сериализацию, авторизует каждую серверную границу и не переносит весь layout в клиент ради одного обработчика.

## Пример применения

Страница может читать разрешенную запись на сервере и передавать интерактивному компоненту ее ID и отображаемое имя. Сам факт передачи ID не дает права на будущую операцию: обработчик повторно устанавливает пользователя и доступ к этому объекту.

## Источники

- [Next.js App Router: Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components) — Client module graph, serializable props and server-only modules.
- [Next.js App Router: Data Security](https://nextjs.org/docs/app/guides/data-security) — Data access approaches, authorization, client input and Server Actions.
