---
id: "database.jsonb"
title: "JSONB и реляционные поля"
section: "database"
level: "contextual"
tags: ["jsonb", "PostgreSQL"]
technologies: ["PostgreSQL"]
reviewed_at: "2026-11-09"
order: 27
related: ["database.constraints", "security.object-access"]
sources: ["https://www.postgresql.org/docs/18/datatype-json.html"]
schema_version: 1
---

# JSONB и реляционные поля

## Коротко

Поля, участвующие в доступе, связях и частом поиске, нуждаются в явной модели.

## Плохо

```text
Весь заказ — один JSON без ограничений.
```

## Хорошо

```text
order_id, tenant_id, total_minor — колонки.
provider_snapshot — JSONB.
```

## Почему

Гибкое поле не отменяет проверку структуры и прав.

## Когда применять

JSONB полезен для внешних снимков и разреженных настроек; запросы внутри JSONB тоже можно индексировать.

## Как проверить

- Какие поля нужны для связей, прав и отчётов?

## Человек

Определяет стабильные бизнес-поля и изменяемые метаданные.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Какие поля нужны для связей, прав и отчётов?

## Источники

- [PostgreSQL: Documentation: 18: 8.14. JSON Types](https://www.postgresql.org/docs/18/datatype-json.html)
