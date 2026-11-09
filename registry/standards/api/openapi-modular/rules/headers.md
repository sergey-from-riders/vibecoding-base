---
id: "api.headers"
title: "HTTP-заголовки"
section: "api"
level: "recommended"
tags: ["headers", "HTTP"]
technologies: ["HTTP"]
reviewed_at: "2026-11-09"
order: 37
related: ["api.http-status", "api.methods"]
sources: ["https://www.rfc-editor.org/rfc/rfc9110.html"]
schema_version: 1
---

# HTTP-заголовки

## Коротко

Статус, формат содержимого и кеширование описываются стандартными средствами HTTP.

## Плохо

```http
HTTP 200
X-App-Result: error
```

## Хорошо

```http
HTTP 503 Service Unavailable
Retry-After: 30
Content-Type: application/problem+json
```

## Почему

Собственный заголовок не заменяет стандартную семантику.

## Когда применять

X-Request-Id полезен для поддержки, если согласован. X-App-Result, X-App-Action и X-App-Validate не обязательны для всех API. Content-Language указывают по смыслу представления.

## Как проверить

- Работает ли обычный HTTP-клиент без знания собственных заголовков?

## Человек

Согласует требования клиентов, прокси и трассировки.

## Агент

Реализует серверный контракт и проверяет успешный запрос, неверный ввод и повторное обращение.

Контроль результата:

- Работает ли обычный HTTP-клиент без знания собственных заголовков?

## Источники

- [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html)
