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

PostgreSQL 18. `integer` допустим при доказанном диапазоне: максимум 2 147 483 647 минимальных единиц, то есть 21 474 836,47 RUB. `bigint` даёт больший запас, но тоже имеет предел. Для дробных тарифов, курсов и промежуточных расчётов подходит `numeric(p,s)` / `decimal(p,s)`; например, `numeric(20,6)` — только если хватает 14 целых и 6 дробных разрядов. Точность и округление задаёт предметная область.

В примере поддерживается только RUB. Для нескольких валют нужна проверяемая таблица валют и их разрядности: не у всех валют две цифры после запятой; API провайдера может иметь исключения. Отрицательные суммы разрешайте для проводок, если это требует модель. PostgreSQL `money` зависит от денежных настроек локали, поэтому для переносимого контракта предпочтительнее явно заданные единицы.

В JavaScript `Number` точно хранит целые только до 2^53 − 1. Большие `bigint` передавайте в JSON строкой; преобразование и арифметику выполняйте без промежуточного `float`.

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

- [Документация 1](https://www.postgresql.org/docs/18/datatype-numeric.html)
- [Документация 2](https://www.postgresql.org/docs/18/datatype-money.html)
- [Документация 3](https://docs.stripe.com/currencies)
- [Документация 4](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER)
