---
schema_version: 1
id: "database.money"
title: "Деньги: bigint, numeric и валюта"
section: "database"
level: "recommended"
tags: ["money", "PostgreSQL", "SQL"]
technologies: ["PostgreSQL", "SQL"]
reviewed_at: "2026-11-09"
order: 101
related: ["database.constraints", "payments.reconciliation"]
sources: ["https://www.postgresql.org/docs/18/datatype-numeric.html", "https://www.postgresql.org/docs/18/datatype-money.html", "https://docs.stripe.com/currencies", "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER"]
---

# Деньги: bigint, numeric и валюта

## Коротко

Сумма хранится вместе с валютой и единицей измерения. Для расчётов используйте целые минимальные единицы или точный десятичный тип.

## Плохо

```sql
CREATE TABLE price (amount double precision);
-- 123.45: неизвестны валюта и политика округления
```

## Хорошо

```sql
CREATE TABLE price (
  amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
  currency text NOT NULL CHECK (currency = 'RUB')
);
INSERT INTO price VALUES (12345, 'RUB'); -- 123 руб. 45 коп.
```

## Почему

`float`, `real` и `double precision` не гарантируют точное представление десятичных денежных дробей. Проверка в БД удерживает формат даже при записи другим сервисом.

## Когда применять

PostgreSQL 18. Тип выбирается по единице измерения и максимальной сумме:

- `integer` / `int`: целые минимальные единицы в доказанном диапазоне. Максимум 2 147 483 647, то есть 21 474 836,47 RUB при хранении копеек.
- `bigint`: целые минимальные единицы, если диапазона `integer` недостаточно. У него тоже есть предел; это не бесконечный тип.
- `numeric(p,s)` / `decimal(p,s)`: точные десятичные суммы, дробные тарифы и курсы. `numeric(20,6)` допускает 14 целых и 6 дробных разрядов. Точность и округление задаёт предметная область.

В примере поддерживается только RUB. Для нескольких валют нужна проверяемая таблица валют и их разрядности: не у всех валют две цифры после запятой; API провайдера может иметь исключения. Отрицательные суммы разрешайте для проводок, если это требует модель. PostgreSQL `money` зависит от денежных настроек локали, поэтому для переносимого контракта предпочтительнее явно заданные единицы.

В JavaScript `Number` гарантирует точность целых только в безопасном диапазоне от −(2^53 − 1) до 2^53 − 1. Большие `bigint` передавайте в JSON строкой; преобразование и арифметику выполняйте без промежуточного `float`.

## Человек

Определяет валюты, максимальные суммы, точность тарифов и правила округления/возвратов.

## Агент

Готовит поля БД, ограничения и сериализацию. Проверяет точность на граничных суммах и сверяет единицы платёжного API.

## Пример применения

Магазин принимает RUB: цена 1999,90 ₽ хранится как `199990` в `amount_minor bigint`. Комиссия рассчитывается десятичной арифметикой, округляется по согласованному правилу до копеек и только затем сохраняется. Для бухгалтерских проводок создаётся отдельная модель с допустимым отрицательным знаком.

## Как проверить

- 12345 минимальных единиц RUB преобразуются в 123,45 ₽ и обратно без потери копеек.
- Проверены предел типа, отрицательные значения, дробное деление и округление.
- В API описаны валюта, единица и строковый формат больших целых.

## Источники

- [PostgreSQL: Documentation: 18: 8.1. Numeric Types](https://www.postgresql.org/docs/18/datatype-numeric.html)
- [PostgreSQL: Documentation: 18: 8.2. Monetary Types](https://www.postgresql.org/docs/18/datatype-money.html)
- [Supported currencies](https://docs.stripe.com/currencies)
- [Number.MAX_SAFE_INTEGER - JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER)
