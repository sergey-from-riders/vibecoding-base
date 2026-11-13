---
schema_version: 1
id: "frameworks.django-atomic"
title: "Django: atomic и on_commit"
section: "frameworks"
level: "recommended"
tags: ["django-atomic", "Django", "Python"]
technologies: ["Django", "Python"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 110
related: ["database.transactions", "caching.outbox"]
sources: ["https://docs.djangoproject.com/en/5.2/topics/db/transactions/"]
---

# Django: atomic и on_commit

## Коротко

Связанные записи выполняйте через atomic на нужном alias БД. Действие, которому нужен подтвержденный commit, регистрируйте через on_commit; его ошибка уже не откатит записи.

## Плохо

```python
order = Order.objects.create(status="new")
notify(order.pk)
OrderItem.objects.create(order=order, sku=sku)
```

## Хорошо

```python
from django.db import transaction
from orders.models import Order, OrderItem
from orders.notifications import notify

alias = "default"
with transaction.atomic(using=alias):
    order = Order.objects.using(alias).create(status="new")
    OrderItem.objects.using(alias).create(order=order, sku=sku)
    transaction.on_commit(
        lambda order_id=order.pk: notify(order_id),
        using=alias,
    )
```

## Почему

atomic обеспечивает согласованность выбранной БД. on_commit не позволяет уведомить о записи, отмененной rollback, но callback не входит в завершенную транзакцию и не является устойчивой очередью.

## Когда применять

Django 5.2, транзакционная БД, autocommit и обычный atomic. Модели, sku и notify принадлежат приложению; callback не читает request после окончания его жизни. `using` у ORM и callback совпадает. Операции на разных alias не образуют общую транзакцию.

Вложенный atomic обычно создает savepoint: его успешный выход еще не означает commit внешней транзакции. Callback из внутреннего блока запускается после внешнего commit, если не было соответствующего rollback. Вне транзакции on_commit выполняет callback сразу.

При стандартном `robust=False` исключение callback распространяется и может остановить последующие callbacks; данные уже зафиксированы. `robust=True` позволяет продолжить другие callbacks и журналирует ошибку, но не обеспечивает доставку. Для обязательного уведомления используйте outbox; при ошибке после commit ответ клиенту не должен утверждать, что БД откатилась.

Перехватывайте DatabaseError вокруг atomic, а не скрывайте его внутри поврежденной транзакции. Для сложных вложений заранее определите, какую часть операции допустимо отменить отдельно.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Обе записи успешны и внешний atomic завершен | Заказ и позиция видны, notify вызван после commit | TransactionTestCase и второе соединение |
| Создание позиции падает | Нет обеих записей, notify не вызван | Проверка БД и callback |
| Внутренний atomic успешен, внешний откатывается | Callback не выполняется | Тест вложенности |
| notify выбрасывает исключение после commit | Записи остаются; ошибка отмечена отдельно, нет слепого повторного создания | БД и журнал ошибки |
| Выбран иной alias | Записи и callback относятся к одному alias | Тест конфигурации нескольких БД |

Django TestCase сам держит транзакцию и обычно не вызывает callbacks. `captureOnCommitCallbacks(execute=True)` проверяет их регистрацию и действие; реальный commit проверяют отдельно через TransactionTestCase.

## Человек

Определяет, какие данные атомарны и какая доставка требует outbox.

## Агент

Проверяет alias, внешнюю транзакцию и ошибку callback. Отличает эмуляцию callback от реального commit в тестах.

## Источники

- [Django 5.2: transactions](https://docs.djangoproject.com/en/5.2/topics/db/transactions/)
