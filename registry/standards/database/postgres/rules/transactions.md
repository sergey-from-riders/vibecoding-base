---
id: "database.transactions"
title: "Транзакции"
section: "database"
level: "required"
tags: ["transactions", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 23
related: ["caching.outbox", "database.constraints"]
sources: ["https://www.postgresql.org/docs/18/tutorial-transactions.html"]
schema_version: 1
---

# Транзакции

## Коротко

Связанные операции должны завершиться вместе или вместе отмениться.

## Плохо

```text
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

## Человек

Определяет операции, которые должны выполняться целиком.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Остановите операцию между шагами и проверьте целостность.

## Источники

- [PostgreSQL: Documentation: 18: 3.4. Transactions](https://www.postgresql.org/docs/18/tutorial-transactions.html)
