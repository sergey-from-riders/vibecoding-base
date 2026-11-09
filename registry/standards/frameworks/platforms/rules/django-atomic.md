---
schema_version: 1
id: "frameworks.django-atomic"
title: "Django: atomic и on_commit"
section: "frameworks"
level: "recommended"
tags: ["django-atomic", "Django", "Python"]
technologies: ["Django", "Python"]
reviewed_at: "2026-11-09"
order: 110
related: ["database.transactions", "caching.outbox"]
sources: ["https://docs.djangoproject.com/en/5.2/topics/db/transactions/"]
---

# Django: atomic и on_commit

## Коротко

Сохранение связанных объектов выполняйте атомарно; зависимое внешнее действие запускайте после commit.

## Плохо

```python
order = Order.objects.create(**data)
notify(order.pk)
Item.objects.create(order=order, **item)
```

## Хорошо

```python
with transaction.atomic():
    order = Order.objects.create(**data)
    Item.objects.create(order=order, **item)
    transaction.on_commit(lambda: notify(order.pk))
```

## Почему

При ошибке создания позиции заказ не должен остаться частично сохранённым.

## Когда применять

Django 5.2 и транзакционная БД. Импорт: `from django.db import transaction`. Callback on_commit не является гарантированной очередью; для доставки после аварии нужен outbox.

## Человек

Определяет атомарность заказа и гарантию доставки уведомлений.

## Агент

Добавляет atomic, on_commit и проверку rollback; отделяет быстрый callback от фоновой обработки.

## Пример применения

Заказ и его позиции сохраняются вместе. В on_commit ставится задача уведомления; если уведомление нельзя потерять при аварии, намерение записывается в outbox внутри atomic.

## Как проверить

- Ошибка позиции откатывает заказ.
- После rollback callback не запускается.

## Источники

- [Database transactions](https://docs.djangoproject.com/en/5.2/topics/db/transactions/)
