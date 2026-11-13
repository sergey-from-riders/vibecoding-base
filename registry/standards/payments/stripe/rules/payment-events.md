---
id: "payments.payment-events"
title: "Платежные события"
section: "payments"
level: "required"
tags: ["payment-events", "Stripe"]
technologies: ["Stripe"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 97
related: ["integrations.webhooks", "payments.payment-truth", "payments.reconciliation", "payments.test-live", "caching.idempotent-worker"]
sources: ["https://docs.stripe.com/webhooks", "https://docs.stripe.com/payments/payment-intents/verifying-status"]
schema_version: 1
---

# Платежные события

## Коротко

Платежное событие принимается после проверки подлинности, а его эффект выполняется идемпотентно. Не присваивайте статус заказа последнему доставленному событию.

## Плохо

```text
Любой checkout.session.completed → order.status = paid.
Любой payment_failed → order.status = failed, даже после выдачи/возврата.
```

## Хорошо

```text
Подпись + account/mode → durable inbox pending → 2xx.
Worker: event_id дедупликация, business payment/fulfillment key.
processing → ожидание; succeeded + сверка → paid/выдача один раз.
Поздний payment_failed → не откатывает доказанную оплату.
refund/dispute → отдельная запись и политика доступа, не новый fulfillment.
```

## Почему

Stripe не гарантирует порядок доставки, а несколько событий могут иметь одинаковый created. Дедупликация event_id устраняет повтор доставки, но сама по себе не предотвращает второй бизнес-эффект от другого события или reconciliation. Обновление одного поля статусом последнего сообщения смешивает платеж, исполнение, возврат и спор.

## Когда применять

Для Stripe webhook. Обязательные предусловия приема — integrations.webhooks и payments.test-live: raw body, подпись/допустимый срок, endpoint secret и доверенный account/mode. Подтверждайте 2xx после устойчивого inbox/очереди; ошибка сохранения требует retryable non-2xx. Сбой worker оставляет pending для восстановления.

Для профиля разовой покупки таблица переходов такова: requires_action/requires_payment_method/requires_confirmation — незавершенная попытка; processing — ожидание; requires_capture — авторизация; succeeded после сверки — факт оплаты; canceled — отмененный intent без выдачи. Уже подтвержденную оплату не понижайте из-за старого снимка. Refund и dispute ведите отдельно; поздний succeeded после refund не выдает товар повторно. Несовместимые свидетельства направляйте на серверное чтение и разбор, а не выбирайте «самое новое» по event.created.

Зафиксируйте формат event destination: snapshot содержит снимок в data.object, thin требует предусмотренного SDK получения связанных данных. Не применяйте один парсер к обоим форматам. Бизнес-ключ зависит от операции: выдача заказа, конкретный refund, invoice/период подписки; нельзя навсегда дедуплицировать все updates одним object_id+type. Локальный эффект и completed атомарны; внешний эффект следует правилам outbox/получателя.

## Как проверить

1. Одинаковый event_id доставлен повторно/параллельно → обработка → один эффект и completed → inbox и запись выдачи.

2. Сначала succeeded, затем старый payment_failed либо succeeded после refund → обработка → оплаченный факт/возврат сохранены, повторной выдачи нет → модель состояний.

3. Неверная подпись либо отказ inbox; сбой после приема → запрос/restart → без подписи эффекта нет, неустойчивый прием не подтвержден, pending восстанавливается → HTTP и журнал состояний.

## Человек

Определяет таблицу платежных состояний, политику refund/dispute и бизнес-ключ каждого эффекта.

## Агент

Реализует проверку приема, durable pending/completed и отрицательные сценарии порядка/конкуренции.

## Источники

- [Stripe Webhooks: verification, formats, duplicates, order, quick response](https://docs.stripe.com/webhooks)
- [Stripe Payment status updates: state semantics и refund/dispute на Charge](https://docs.stripe.com/payments/payment-intents/verifying-status)
