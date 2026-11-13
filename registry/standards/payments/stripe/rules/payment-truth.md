---
id: "payments.payment-truth"
title: "Подтверждение оплаты"
section: "payments"
level: "required"
tags: ["payment-truth", "Stripe"]
technologies: ["Stripe"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 96
related: ["payments.payment-events", "payments.reconciliation", "payments.test-live", "caching.outbox", "security.object-access"]
sources: ["https://docs.stripe.com/payments/payment-intents/verifying-status", "https://docs.stripe.com/checkout/fulfillment.md?ui=full-page"]
schema_version: 1
---

# Подтверждение оплаты

## Коротко

Выдача оплаченного товара запускается серверной проверкой платежа, связанного с локальным заказом. Redirect и клиентский флаг не подтверждают получение денег.

## Плохо

```text
GET /success?paid=true&order_id=42 → order.paid = true → выдать товар.
```

## Хорошо

```text
Сервер: получить связанный PaymentIntent в нужном Stripe account/mode.
Сверить order, currency, ожидаемую и полученную сумму.
requires_action / processing / requires_capture → не считать оплатой.
succeeded → единая операция fulfill(order_id, payment_id).
Уникальный ключ выдачи + локальный эффект фиксируются атомарно.
```

## Почему

Authorization резервирует возможность capture; processing еще может завершиться неуспехом. Для описанного профиля разовой оплаты основание выдачи — succeeded и совпадение платежных реквизитов. Этот статус не означает невозможность будущего refund/dispute: их учет отделен от факта успешной оплаты.

## Когда применять

Для автоматической выдачи разовых покупок через PaymentIntents или Checkout mode=payment. Подписки, рассрочка, частичный capture и разрешенная выдача до оплаты требуют собственной таблицы состояний и отдельного критерия исполнения. Checkout completed не равно оплачено при delayed methods; проверяйте payment_status и async-события. Бесплатный заказ/no_payment_required разрешается отдельной серверной политикой, а не обходом проверки суммы.

Храните серверную связь order → Stripe account, live/sandbox, Session/PaymentIntent и доверенную итоговую сумму/валюту. Если Checkout может изменить количество, налоги или скидку, сверяйте результат с разрешенным расчетом и составом заказа. Не принимайте чужой payment_id из браузера как эту связь. Проверяйте право пользователя видеть заказ независимо от оплаты.

Webhook, серверное чтение после redirect и reconciliation вызывают одну идемпотентную операцию исполнения. Для локальных изменений используйте транзакцию и UNIQUE на бизнес-ключе выдачи; внешняя отгрузка требует outbox/идемпотентности получателя. При несовпадении account/mode/суммы/валюты выдача блокируется и создается диагностируемое расхождение. Webhook остается независимым каналом: уход клиента не должен мешать исполнению.

## Как проверить

1. Подтвержденный связанный succeeded с верной суммой → webhook одновременно с серверной сверкой → один эффект выдачи → UNIQUE/история операции.

2. Redirect paid=true, чужой payment_id либо неверные mode/account/currency/amount → проверка → выдачи нет → запись безопасного кода расхождения.

3. processing или requires_capture → сначала ожидание; затем succeeded → выдача один раз → последовательность состояний; последующий refund учитывается отдельно.

## Человек

Определяет критерий оплаченности для методов оплаты, допустимость предоплатной выдачи и владельца финансовых расхождений.

## Агент

Сверяет серверную привязку, сумму и состояние; связывает все три триггера с одной идемпотентной выдачей.

## Источники

- [Stripe Payment status updates: PaymentIntent states и последующие Charge changes](https://docs.stripe.com/payments/payment-intents/verifying-status)
- [Stripe Checkout fulfillment: server function, concurrent calls, delayed payments](https://docs.stripe.com/checkout/fulfillment.md?ui=full-page)
