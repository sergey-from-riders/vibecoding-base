---
id: "api.error-details"
title: "Problem Details"
section: "api"
level: "recommended"
tags: ["error-details", "HTTP"]
technologies: ["HTTP"]
reviewed_at: "2026-11-09"
order: 31
related: ["api.http-status", "api.methods"]
sources: ["https://www.rfc-editor.org/rfc/rfc9457.html"]
schema_version: 1
---

# Problem Details

## Коротко

Ошибка должна помогать исправить запрос без раскрытия внутреннего устройства сервера.

## Плохо

```json
{"error":"SQL exception at /private/app/main.go:42"}
```

## Хорошо

```json
{"type":"https://example.com/problems/validation",
 "title":"Проверьте поля", "status":422,
 "errors":[{"field":"email","message":"Неверный формат"}]}
```

## Почему

Стек вызовов и SQL не помогают пользователю и могут раскрыть лишние сведения.

## Когда применять

Problem Details задаёт общую основу; errors и request_id — документируемые расширения, а не обязательные поля RFC.

## Как проверить

- Можно ли понять ошибку? Нет ли секретов и внутренних путей?

## Человек

Определяет понятные пользователю коды ошибок и допустимые детали ответа.

## Агент

Реализует серверный контракт и проверяет успешный запрос, неверный ввод и повторное обращение.

Контроль результата:

- Можно ли понять ошибку? Нет ли секретов и внутренних путей?

## Источники

- [RFC 9457: Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html)
