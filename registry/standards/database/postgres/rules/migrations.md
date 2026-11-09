---
id: "database.migrations"
title: "Миграции схемы"
section: "database"
level: "required"
tags: ["migrations", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 24
related: ["operations.rollback", "operations.restore"]
sources: ["https://www.postgresql.org/docs/18/sql-altertable.html", "https://www.prisma.io/docs/orm/prisma-migrate/workflows/customizing-migrations"]
schema_version: 1
---

# Миграции схемы

## Коротко

Выпускайте несовместимые изменения в несколько совместимых этапов.

## Плохо

```text
Удалить колонку → выпустить новый код.
```

## Хорошо

```text
Добавить новое поле → заполнить порциями →
переключить чтение → позже удалить старое.
```

## Почему

Во время выпуска старый и новый код могут работать одновременно.

## Когда применять

Для production с данными. Уже применённые миграции не переписываются; откат данных не всегда возможен через down.

## Как проверить

- Проверены блокировки, время заполнения и старый код на новой схеме?

## Человек

Согласует окно выпуска, совместимость и допустимые блокировки.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Проверены блокировки, время заполнения и старый код на новой схеме?

## Источники

- [PostgreSQL: Documentation: 18: ALTER TABLE](https://www.postgresql.org/docs/18/sql-altertable.html)
- [Editing a migration in Prisma ORM](https://www.prisma.io/docs/orm/prisma-migrate/workflows/customizing-migrations)
