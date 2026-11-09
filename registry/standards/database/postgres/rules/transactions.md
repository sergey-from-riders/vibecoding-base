---
id: "database.transactions"
title: "Изменяйте связанные данные одной транзакцией"
section: "database"
level: "required"
tags: ["transactions", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 23
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl.html"]
schema_version: 1
---

# Изменяйте связанные данные одной транзакцией

## Коротко

Связанные операции должны завершиться вместе или вместе отмениться.

## Плохо

```sql
Списать остаток.
Сбой.
Заказ не создан.
```

## Хорошо

```sql
BEGIN;
-- Проверить и списать остаток.
-- Создать заказ.
COMMIT;
```

## Почему

Частичный результат нарушает бизнес-инвариант.

## Когда применять

Транзакция БД не включает внешний API; для внешних эффектов используйте outbox или сверку.

## Как проверить

- Остановите операцию между шагами и проверьте целостность.

## Источники

- [Первоисточник](https://www.postgresql.org/docs/18/ddl.html)
