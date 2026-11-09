---
id: "database.identifiers"
title: "Выбирайте тип идентификатора под задачу"
section: "database"
level: "contextual"
tags: ["identifiers", "PostgreSQL", "SQL"]
technologies: ["PostgreSQL", "SQL"]
reviewed_at: "2026-11-09"
order: 19
related: ["database.naming", "database.constraints"]
sources: ["https://www.postgresql.org/docs/18/functions-uuid.html"]
schema_version: 1
---

# Выбирайте тип идентификатора под задачу

## Коротко

UUID удобен для независимого создания записей и публичных идентификаторов. Имя поля и его тип — разные решения.

## Плохо

```sql
CREATE TABLE orders (
  order_id bigint PRIMARY KEY
);
-- Два независимых сервиса выдали order_id = 42.
```

## Хорошо

```sql
CREATE TABLE orders (
  order_id uuid PRIMARY KEY DEFAULT uuidv7()
);
-- PostgreSQL 18: генерация без общего счётчика.
```

## Почему

UUID уменьшает зависимость от единого генератора. Он не заменяет проверку доступа; UUIDv7 раскрывает временную составляющую.

## Когда применять

Числовой identity допустим в централизованной БД. UUIDv7 есть в PostgreSQL 18; UUIDv4 через gen_random_uuid() подходит там, где v7 недоступен.

## Как проверить

- Где создаётся идентификатор? Нужен ли единый счётчик? Проверяется ли доступ независимо от UUID?

## Источники

- [Первоисточник](https://www.postgresql.org/docs/18/functions-uuid.html)
