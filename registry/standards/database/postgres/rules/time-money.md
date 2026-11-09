---
id: "database.time-money"
title: "Дата и время: timestamptz"
section: "database"
level: "recommended"
tags: ["time", "даты", "timezone", "timestamptz"]
technologies: ["PostgreSQL"]
reviewed_at: "2026-11-09"
order: 26
related: ["database.money", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/datatype-datetime.html"]
schema_version: 1
---

# Дата и время: timestamptz

## Коротко

Момент времени и местное расписание — разные данные. PostgreSQL `timestamptz` хранит момент, но не исходное название часового пояса.

## Плохо

```sql
CREATE TABLE meeting (starts_at text);
-- '09.11.2026 10:00' без формата и часового пояса
```

## Хорошо

```sql
CREATE TABLE meeting (
  starts_at timestamptz NOT NULL,
  time_zone text NOT NULL
);
-- '2026-11-09T10:00:00+03:00', 'Europe/Moscow'
```

## Почему

Без зоны одна строка может означать разные моменты. Для будущего повторяющегося расписания нужен местный час и название зоны, а не только одна UTC-метка.

## Когда применять

PostgreSQL 18: `timestamptz` — события и аудит; `date` — календарная дата; `timestamp without time zone` вместе с зоной и правилом повтора — локальное расписание. Не добавляйте зону к дате рождения. Денежные типы вынесены в отдельное правило `database.money`.

## Как проверить

- Проверены преобразования UTC, разные зоны и переходы летнего времени?
- Различаются дата, момент и повторяющееся расписание?

## Человек

Определяет, хранится ли точный момент, местная дата или повторяющееся расписание.

## Агент

Выбирает типы по согласованной семантике, проверяет преобразования зон и неоднозначное местное время.

## Источники

- [PostgreSQL: Documentation: 18: 8.5. Date/Time Types](https://www.postgresql.org/docs/18/datatype-datetime.html)
