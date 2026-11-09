---
id: "database.foreign-keys"
title: "Внешние ключи"
section: "database"
level: "recommended"
tags: ["foreign-keys", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 22
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl-constraints.html"]
schema_version: 1
---

# Внешние ключи

## Коротко

Внешний ключ не позволяет хранить ссылку на несуществующую запись.

## Плохо

```sql
user_id uuid -- связь известна только коду
```

## Хорошо

```sql
user_id uuid REFERENCES users(user_id)
  ON DELETE RESTRICT
```

## Почему

Без ограничения легко получить осиротевшие данные.

## Когда применять

CASCADE подходит только для действительно зависимых записей. В распределённом хранилище без FK нужен документированный контроль целостности.

## Как проверить

- Проверьте создание неверной ссылки и удаление родителя.

## Человек

Выбирает поведение связанных данных при удалении и переносе.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Проверьте создание неверной ссылки и удаление родителя.

## Источники

- [PostgreSQL: Documentation: 18: 5.5. Constraints](https://www.postgresql.org/docs/18/ddl-constraints.html)
