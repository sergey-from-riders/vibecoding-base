---
id: "database.indexes"
title: "Индексы PostgreSQL"
section: "database"
level: "recommended"
tags: ["indexes", "PostgreSQL"]
technologies: ["PostgreSQL"]
reviewed_at: "2026-11-09"
order: 25
related: ["api.pagination", "database.foreign-keys"]
sources: ["https://www.postgresql.org/docs/18/indexes.html", "https://www.postgresql.org/docs/18/using-explain.html", "https://www.postgresql.org/docs/18/ddl-constraints.html#DDL-CONSTRAINTS-FK"]
schema_version: 1
---

# Индексы PostgreSQL

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

## Человек

Задаёт приоритетные запросы и допустимую стоимость записи.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- У индекса есть запрос и сравнение времени до и после?

## Источники

- [PostgreSQL: Documentation: 18: Chapter 11. Indexes](https://www.postgresql.org/docs/18/indexes.html)
- [PostgreSQL: Documentation: 18: 14.1. Using EXPLAIN](https://www.postgresql.org/docs/18/using-explain.html)
- [PostgreSQL: Documentation: 18: 5.5. Constraints](https://www.postgresql.org/docs/18/ddl-constraints.html#DDL-CONSTRAINTS-FK)
