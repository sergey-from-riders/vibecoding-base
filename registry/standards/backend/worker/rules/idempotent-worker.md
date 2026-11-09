---
id: "caching.idempotent-worker"
title: "Идемпотентность worker"
section: "caching"
level: "required"
tags: ["idempotent-worker"]
technologies: []
reviewed_at: "2026-11-09"
order: 67
related: ["caching.source-of-truth", "caching.freshness"]
sources: ["https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html"]
schema_version: 1
---

# Идемпотентность worker

## Коротко

Повтор сообщения не должен повторять необратимый эффект.

## Плохо

```text
Одно сообщение пришло дважды → отправлены два заказа.
```

## Хорошо

```text
message_id проверяется транзакционно.
Повтор возвращает уже сохранённый результат.
```

## Почему

Успешная обработка и подтверждение доставки могут разделиться сетевым сбоем.

## Когда применять

Не обещайте exactly-once без доказанной модели всей цепочки, включая внешние эффекты.

## Как проверить

- Завершите процесс после эффекта, но до подтверждения сообщения.

## Человек

Определяет уникальность задания и допустимые последствия повторов.

## Агент

Реализует восстановление и обработку повторов, проверяет сбой зависимости и возвращение в рабочее состояние.

Контроль результата:

- Завершите процесс после эффекта, но до подтверждения сообщения.

## Источники

- [Amazon SQS at-least-once delivery - Amazon Simple Queue Service](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html)
