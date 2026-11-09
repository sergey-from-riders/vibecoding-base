---
id: "database.indexes"
title: "Создавайте индекс под реальный запрос"
section: "database"
level: "recommended"
tags: ["indexes", "PostgreSQL"]
technologies: ["PostgreSQL"]
reviewed_at: "2026-11-09"
order: 25
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl-constraints.html"]
schema_version: 1
---

# Создавайте индекс под реальный запрос

## Коротко

Индекс ускоряет выбранное чтение и увеличивает стоимость записи.

## Плохо

```text
Создать индекс на каждой колонке.
```

## Хорошо

```text
Найти медленный запрос → EXPLAIN →
добавить подходящий индекс → измерить.
```

## Почему

Лишние индексы расходуют место и замедляют обновления.

## Когда применять

Индексы FK на стороне ссылки не создаются PostgreSQL автоматически. Для связей и фильтров учитывайте объём и план запроса.

## Как проверить

- У индекса есть запрос и сравнение времени до и после?

## Источники

- [Первоисточник](https://www.postgresql.org/docs/18/ddl-constraints.html)
