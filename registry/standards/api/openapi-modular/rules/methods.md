---
id: "api.methods"
title: "HTTP-методы"
section: "api"
level: "required"
tags: ["methods", "HTTP"]
technologies: ["HTTP"]
reviewed_at: "2026-11-09"
order: 30
related: ["api.http-status", "api.error-details"]
sources: ["https://www.rfc-editor.org/rfc/rfc9110.html#section-9", "https://www.rfc-editor.org/rfc/rfc5789.html"]
schema_version: 1
---

# HTTP-методы

## Коротко

GET и HEAD читают; изменение бизнес-состояния должно иметь соответствующий метод.

## Плохо

```http
GET /orders/42/delete
```

## Хорошо

```http
DELETE /orders/42
```

## Почему

Ссылку может заранее открыть браузер, робот или прокси.

## Когда применять

POST подходит для команд и создания, PUT — полного идемпотентного замещения, PATCH — частичного изменения. Семантику повторов PATCH нужно описывать.

## Как проверить

- Открытие обычной ссылки не удаляет и не оплачивает данные?

## Человек

Согласует назначение операции и последствия повторного запроса.

## Агент

Реализует серверный контракт и проверяет успешный запрос, неверный ввод и повторное обращение.

Контроль результата:

- Открытие обычной ссылки не удаляет и не оплачивает данные?

## Источники

- [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html#section-9)
- [rfc5789.html](https://www.rfc-editor.org/rfc/rfc5789.html)
