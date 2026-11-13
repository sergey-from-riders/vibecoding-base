---
schema_version: 1
id: "database.money"
title: "Деньги: bigint, numeric и валюта"
section: "database"
level: "recommended"
tags: ["money", "PostgreSQL", "SQL"]
technologies: ["PostgreSQL", "SQL"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 101
related: ["database.constraints", "payments.reconciliation"]
sources: ["https://www.postgresql.org/docs/18/datatype-numeric.html", "https://www.postgresql.org/docs/18/datatype-money.html", "https://docs.stripe.com/currencies", "https://tc39.es/ecma262/multipage/numbers-and-dates.html#sec-number.max_safe_integer"]
---

# Деньги: bigint, numeric и валюта

## Коротко

Храните сумму с валютой и единицей. Используйте целые минимальные единицы или точный decimal; определите диапазон, округление и сериализацию до расчета.

## Плохо

```sql
CREATE TABLE price (amount double precision);
-- Не определены валюта, единица и округление.
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

Float не гарантирует точные десятичные дроби. PostgreSQL integer ограничен 2 147 483 647, bigint тоже конечен; numeric(p,s) хранит точные десятичные значения с заданной точностью. money зависит от lc_monetary и не задает явный переносимый валютный контракт. Пример — цена только в RUB, не универсальная модель проводки.

## Когда применять

Для PostgreSQL 18 и денежных данных. Integer допустим при доказанном диапазоне; bigint — когда нужен больший. numeric(20,6) дает 14 целых и 6 дробных разрядов и подходит для выбранных дробных тарифов/курсов. Установите этап и правило округления; приведение к numeric со scale само может округлить. Не проходите через float. Для numeric явно исключите NaN и, у unconstrained numeric, бесконечности: одного CHECK (amount >= 0) недостаточно, поскольку PostgreSQL сравнивает NaN как больше любого обычного числа. Конечные нижняя и верхняя границы по бизнес-модели вместе с NOT NULL закрывают этот случай.

Разрядность и исключения проверяйте по конкретной валюте и операции провайдера: не все валюты двухзначные, правила charge и payout могут различаться. Суммы разных валют не складываются без явной конверсии с зафиксированными курсом и округлением. Для распределения остатка задайте детерминированный порядок: например, 100 единиц на три позиции дает 34/33/33, сумма сохраняется. Отрицательные проводки допустимы по отдельной модели, а отрицательная цена может быть запрещена.

Если JSON читает JavaScript Number, целые вне ±(2^53−1) передавайте согласованной десятичной строкой. Тип и единица остаются частью API-контракта; замена числа строкой требует проверки потребителей.

## Как проверить

1. 12345 RUB minor → форматирование и обратное чтение → ровно 12345 → сравнение целых без float.

2. Значение за пределом типа, запрещенный знак или другая валюта → запись/расчет → явный отказ по модели → constraint/валидация; проводка с разрешенным знаком проходит отдельно.

3. 100 minor делится на три части; большое целое проходит JSON → сумма частей 100 и цифры сохранены → арифметический тест, round-trip и выбранное округление.

## Человек

Определяет валюты, допустимые знаки, максимумы, округление и распределение остатков.

## Агент

Проверяет типы БД и API, точность вычислений и единицы конкретного provider endpoint; не переносит правила RUB на все валюты.

## Источники

- [PostgreSQL 18, §8.1: диапазоны, numeric и округление](https://www.postgresql.org/docs/18/datatype-numeric.html)
- [PostgreSQL 18, §8.2: money и lc_monetary](https://www.postgresql.org/docs/18/datatype-money.html)
- [Stripe: minor units и special currency cases](https://docs.stripe.com/currencies)
- [ECMAScript: Number.MAX_SAFE_INTEGER](https://tc39.es/ecma262/multipage/numbers-and-dates.html#sec-number.max_safe_integer)
