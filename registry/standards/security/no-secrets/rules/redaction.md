---
id: "security.redaction"
title: "Удаляйте секреты из логов до записи"
section: "security"
level: "required"
tags: ["redaction"]
technologies: []
reviewed_at: "2026-11-09"
order: 74
related: ["security.object-access", "security.secrets"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html"]
schema_version: 1
---

# Удаляйте секреты из логов до записи

## Коротко

Записывайте идентификаторы операций и безопасные признаки вместо полного содержимого.

## Плохо

```text
log(request.headers, request.body)
```

## Хорошо

```text
log({request_id, route, status, duration_ms})
```

## Почему

Логи часто доступны большему числу систем, чем исходные данные.

## Когда применять

Персональные сведения допускаются только при обоснованной необходимости, ограничениях доступа и сроке хранения.

## Как проверить

- Нет ли Authorization, cookie, OAuth-кодов и платёжных данных в логах?

## Источники

- [Первоисточник](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
