---
id: "database.transactions"
title: "Транзакции"
section: "database"
level: "required"
tags: ["transactions", "SQL"]
technologies: ["SQL"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 23
related: ["caching.outbox", "database.constraints"]
sources: ["https://www.postgresql.org/docs/18/tutorial-transactions.html", "https://www.postgresql.org/docs/18/transaction-iso.html", "https://www.postgresql.org/docs/18/mvcc-serialization-failure-handling.html"]
schema_version: 1
---

# Транзакции

## Коротко

Группируйте связанные изменения в одну транзакцию и отдельно обеспечивайте инвариант при конкурентном выполнении. BEGIN/COMMIT сами по себе не предотвращают lost update или oversell.

## Плохо

```sql
-- Два клиента прочитали stock = 1, затем каждый создал заказ.
BEGIN;
UPDATE inventory SET stock = 0 WHERE sku = 'book';
INSERT INTO orders (sku) VALUES ('book');
COMMIT;
```

## Хорошо

```sql
-- Фрагмент: inventory.sku уникален, orders.order_id имеет DEFAULT.
BEGIN;
WITH reserved AS (
  UPDATE inventory SET stock = stock - 1
  WHERE sku = 'book' AND stock >= 1
  RETURNING sku
)
INSERT INTO orders (sku)
SELECT sku FROM reserved
RETURNING order_id;
COMMIT;
```

## Почему

Пример создает заказ только для успешно зарезервированного остатка: ноль возвращенных строк означает отсутствие запаса. При Read Committed PostgreSQL повторно проверяет WHERE после ожидания конкурентного UPDATE той же строки. Это конкретный однострочный инвариант; проверка нескольких строк/предикатов может требовать блокировок или Serializable. Ограничения БД остаются отдельной защитой.

## Когда применять

Для операций в одной БД. Проверяйте все ошибки и результат каждой команды; при ошибке завершайте rollback, а не продолжайте использовать прерванную транзакцию. Держите транзакцию короткой, установите бюджет ожидания/выполнения. Несколько объектов блокируйте в согласованном порядке.

Для SQLSTATE 40001 и выбранных deadlock-случаев повторяется вся транзакция вместе с вычислениями, с ограничением попыток/общего времени; постоянный 23505 нельзя повторять вслепую. При потере связи во время COMMIT исход неизвестен: сверяйте по стабильному ID операции до повторного эффекта. Внешний API не откатывается транзакцией БД; используйте outbox/идемпотентность и сверку. Пример не является готовой схемой заказа или полной обработкой ошибок клиента.

## Как проверить

1. stock = 1 → два одновременных заказа → ровно один создан, stock = 0 → результаты RETURNING и строки БД.

2. Сбой/constraint после уменьшения остатка до commit → rollback → нет заказа и списания → проверка обоих инвариантов.

3. 40001 → ограниченный повтор всей операции → согласованный результат; потеря ответа COMMIT → поиск по ID операции → нет повторной внешней оплаты → журнал попыток и сверки.

## Человек

Фиксирует инвариант, уровень изоляции и допустимую стратегию неизвестного COMMIT.

## Агент

Реализует атомарную запись и конкурентный контроль; воспроизводит гонку, rollback и повтор всей транзакции.

## Источники

- [PostgreSQL 18, §3.4: атомарность транзакции](https://www.postgresql.org/docs/18/tutorial-transactions.html)
- [PostgreSQL 18, §13.2.1: Read Committed и повторная проверка UPDATE](https://www.postgresql.org/docs/18/transaction-iso.html)
- [PostgreSQL 18, §13.5: 40001, deadlock и полный retry](https://www.postgresql.org/docs/18/mvcc-serialization-failure-handling.html)
