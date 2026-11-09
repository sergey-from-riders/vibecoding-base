---
id: "database.jsonb"
title: "Отделяйте бизнес-поля от гибких метаданных"
section: "database"
level: "contextual"
tags: ["jsonb", "PostgreSQL"]
technologies: ["PostgreSQL"]
reviewed_at: "2026-11-09"
order: 27
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl.html"]
schema_version: 1
---

# Отделяйте бизнес-поля от гибких метаданных

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

## Источники

- [Первоисточник](https://www.postgresql.org/docs/18/ddl.html)
