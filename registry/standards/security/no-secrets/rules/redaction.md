---
id: "security.redaction"
title: "Маскирование секретов в логах"
section: "security"
level: "required"
tags: ["redaction"]
technologies: []
reviewed_at: "2026-11-09"
order: 74
related: ["operations.correlation", "security.secrets"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html"]
schema_version: 1
---

# Маскирование секретов в логах

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

## Человек

Определяет чувствительные поля и требования к диагностике.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- Нет ли Authorization, cookie, OAuth-кодов и платёжных данных в логах?

## Источники

- [Logging - OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)
