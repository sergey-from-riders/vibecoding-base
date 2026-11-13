---
id: "caching.idempotent-worker"
title: "Идемпотентность worker"
section: "caching"
level: "required"
tags: ["idempotent-worker"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 67
related: ["api.idempotency", "caching.outbox", "integrations.retries"]
sources: ["https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html", "https://www.postgresql.org/docs/18/tutorial-transactions.html"]
schema_version: 1
---

# Идемпотентность worker

## Коротко

Worker должен переживать повтор и конкурирующую доставку без второго необратимого эффекта. Подтверждайте сообщение только после устойчивого результата или передачи в устойчивое восстановление.

## Плохо

```text
Проверили message_id → эффект → отдельно сохранили done.
Сбой между шагами повторяет эффект; ранний done теряет работу.
```

## Хорошо

```text
Локальная БД: одна транзакция — уникальный operation_key + эффект + done.
COMMIT → ACK; повтор completed возвращает сохраненный результат.
Внешний API: устойчивый pending + прежний provider key.
Сбой после API → сверка/возобновление, затем done и ACK.
```

## Почему

At-least-once может повторить сообщение после успешной обработки, если ACK потерян. Транспортный message_id может измениться при повторной публикации: бизнес-ключ соответствует одной операции, например выдаче одного заказа. Уникальность должна действовать в нужной области потребителя/tenant и проверяться атомарно.

## Когда применять

Для очередей с повторной доставкой и задач с внешним эффектом. В локальной транзакции проигравший конкурент не выполняет эффект; rollback отменяет и отметку дедупликации, и изменение. Для внешнего эффекта локальная отметка не образует с провайдером общую транзакцию: необходимы поддерживаемый provider key, поиск результата или компенсирующий процесс.

Сохраняйте состояния pending/completed/failed, payload fingerprint при необходимости и срок дедупликации не короче окна replay/redrive. Lease/visibility timeout позволяют восстановить зависшее выполнение, но сами не запрещают старому worker продолжать работу; нужны проверка владения/версии и идемпотентный внешний эффект. Не обещайте exactly-once всей цепочки только из-за FIFO или таблицы message_id.

## Как проверить

1. Две доставки одной бизнес-операции, в том числе с разными message_id → worker → один эффект → уникальный operation_key и итог.

2. Сбой до commit либо после commit до ACK → redelivery → первый случай выполняется, второй не дублируется → состояние БД и счетчик эффекта.

3. Внешний эффект прошел, done не записан → истечение lease и restart → сверка по прежнему ключу, без нового эффекта → provider ID и переход pending → completed.

## Человек

Определяет идентичность операции, окно replay и разрешение неопределенного внешнего результата.

## Агент

Проверяет atomic dedupe/effect, ACK после устойчивого результата и конкурирующих владельцев; воспроизводит оба crash window.

## Источники

- [Amazon SQS: at-least-once и повтор после удаления копии](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html)
- [PostgreSQL 18, §3.4: локальная атомарность](https://www.postgresql.org/docs/18/tutorial-transactions.html)
