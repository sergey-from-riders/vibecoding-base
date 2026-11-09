---
id: "api.pagination"
title: "Пагинация"
section: "api"
level: "recommended"
tags: ["pagination", "HTTP"]
technologies: ["HTTP"]
reviewed_at: "2026-11-09"
order: 35
related: ["database.indexes", "security.resource-limits"]
sources: ["https://www.postgresql.org/docs/18/queries-limit.html", "https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/"]
schema_version: 1
---

# Пагинация

## Коротко

Договоритесь о размере страницы, сортировке, фильтрах и продолжении списка.

## Плохо

```text
GET /users → вся таблица без лимита.
```

## Хорошо

```text
GET /users?limit=50&cursor=...
Ответ: items и next_cursor.
```

## Почему

Неограниченная выдача расходует память и делает время ответа непредсказуемым.

## Когда применять

Cursor удобен для меняющихся списков; offset допустим для небольших стабильных выборок. Порядок должен иметь уникальный tie-breaker.

## Как проверить

- Проверьте предел размера и повторяющиеся значения сортировки.

## Человек

Определяет порядок списка, лимит страницы и требования к стабильности выдачи.

## Агент

Реализует серверный контракт и проверяет успешный запрос, неверный ввод и повторное обращение.

Контроль результата:

- Проверьте предел размера и повторяющиеся значения сортировки.

## Источники

- [PostgreSQL: Documentation: 18: 7.6. LIMIT and OFFSET](https://www.postgresql.org/docs/18/queries-limit.html)
- [API4:2023 Unrestricted Resource Consumption - OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/)
