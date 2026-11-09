---
id: "database.naming"
title: "Имена таблиц и полей"
section: "database"
level: "recommended"
tags: ["naming", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 20
related: ["database.identifiers", "database.constraints"]
sources: ["https://www.postgresql.org/docs/18/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS"]
schema_version: 1
---

# Имена таблиц и полей

## Коротко

Из имени поля должно быть понятно, какую связь оно хранит.

## Плохо

```sql
CREATE TABLE sessions (
  id uuid, ref uuid
);
```

## Хорошо

```sql
CREATE TABLE sessions (
  session_id uuid PRIMARY KEY,
  user_id uuid REFERENCES users(user_id)
);
```

## Почему

Явные имена помогают читать запросы с несколькими таблицами.

## Когда применять

snake_case и entity_id — соглашение этого справочника. Название id допустимо в другом последовательном соглашении; массовое переименование существующей БД не требуется.

## Как проверить

- Можно ли без комментария понять назначение ref?

## Человек

Согласует термины предметной области и существующие соглашения проекта.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Можно ли без комментария понять назначение ref?

## Источники

- [PostgreSQL: Documentation: 18: 4.1. Lexical Structure](https://www.postgresql.org/docs/18/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS)
