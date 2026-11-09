---
schema_version: 1
id: "frameworks.laravel-jobs"
title: "Laravel: транзакция и afterCommit"
section: "frameworks"
level: "recommended"
tags: ["laravel-jobs", "Laravel", "PHP"]
technologies: ["Laravel", "PHP"]
reviewed_at: "2026-11-09"
order: 103
related: ["caching.outbox", "caching.idempotent-worker"]
sources: ["https://laravel.com/docs/12.x/queues", "https://laravel.com/docs/12.x/database#database-transactions"]
---

# Laravel: транзакция и afterCommit

## Коротко

Задание, которое читает новую запись, отправляйте после фиксации транзакции.

## Плохо

```php
DB::transaction(function () use ($data) {
  $order = Order::create($data);
  SendReceipt::dispatch($order->id);
});
```

## Хорошо

```php
DB::transaction(function () use ($data) {
  $order = Order::create($data);
  SendReceipt::dispatch($order->id)->afterCommit();
});
```

## Почему

Worker может начать работу до commit. При rollback уведомление о несуществующем заказе не должно отправиться.

## Когда применять

Laravel 12.x и асинхронная очередь. Плохой пример предполагает `after_commit=false` в конфигурации соединения. При `after_commit=true` Laravel уже откладывает отправку до commit; явный `afterCommit()` тогда не обязателен. `afterCommit()` не гарантирует доставку при падении процесса между commit и отправкой; для такой гарантии нужен outbox. Обработчик всё равно должен переносить повторы.

## Человек

Определяет необходимую гарантию доставки и срок уведомления.

## Агент

Настраивает afterCommit, идемпотентность и проверку rollback; для надёжной доставки реализует outbox.

## Пример применения

После создания заказа квитанция ставится в очередь. Её ключ уникальности — идентификатор заказа и тип уведомления; временная ошибка почты допускает повтор.

## Как проверить

- Rollback не создаёт отправку.
- Повтор задания не отправляет вторую квитанцию.

## Источники

- [Queues](https://laravel.com/docs/12.x/queues)
- [Database: Getting Started](https://laravel.com/docs/12.x/database#database-transactions)
