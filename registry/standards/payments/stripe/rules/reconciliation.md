---
id: "payments.reconciliation"
title: "Платёжная сверка"
section: "payments"
level: "recommended"
tags: ["reconciliation", "Stripe"]
technologies: ["Stripe"]
reviewed_at: "2026-11-09"
order: 99
related: ["payments.payment-events", "database.money"]
sources: ["https://docs.stripe.com/payments/payment-intents/verifying-status", "https://docs.stripe.com/refunds"]
schema_version: 1
---

# Платёжная сверка

## Коротко

Периодически находите несовпадения между локальной системой и провайдером.

## Плохо

```text
Вебхук потерян; оплаченный заказ навсегда остался pending.
```

## Хорошо

```text
Сверка неопределённых платежей.
Расхождение попадает на разбор с историей.
```

## Почему

Одного канала уведомлений недостаточно для контроля состояния денег.

## Когда применять

Частота зависит от объёма и допустимой задержки. Возвраты и споры включаются в ту же модель.

## Как проверить

- Есть ли проверка потерянного события и частичного возврата?

## Человек

Определяет период сверки и ответственного за расхождения.

## Агент

Реализует серверную обработку событий и проверяет дубликат, ошибку и сверку в тестовом окружении.

Контроль результата:

- Есть ли проверка потерянного события и частичного возврата?

## Источники

- [Payment status updates](https://docs.stripe.com/payments/payment-intents/verifying-status)
- [Refund and cancel payments](https://docs.stripe.com/refunds)
