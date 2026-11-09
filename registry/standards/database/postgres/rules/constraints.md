---
id: "database.constraints"
title: "Ограничения целостности"
section: "database"
level: "required"
tags: ["constraints", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 21
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl-constraints.html"]
schema_version: 1
---

# Ограничения целостности

## Коротко

Проверка в приложении не защищает от конкурирующих запросов и другого клиента БД.

## Плохо

```javascript
if (!emailExists(email)) {
  insertUser(email);
}
```

## Хорошо

```sql
CREATE UNIQUE INDEX users_email_unique
  ON users (email);
```

## Почему

Два запроса могут одновременно пройти проверку отсутствия записи.

## Когда применять

Способ нормализации email и состав уникальности, включая tenant, определяет продукт.

## Как проверить

- Попробуйте два одновременных создания одной сущности.

## Человек

Определяет инварианты данных и допустимые исключения.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Попробуйте два одновременных создания одной сущности.

## Источники

- [PostgreSQL: Documentation: 18: 5.5. Constraints](https://www.postgresql.org/docs/18/ddl-constraints.html)
