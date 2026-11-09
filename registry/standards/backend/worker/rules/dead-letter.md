---
id: "caching.dead-letter"
title: "Dead-letter queue"
section: "caching"
level: "recommended"
tags: ["dead-letter"]
technologies: []
reviewed_at: "2026-11-09"
order: 69
related: ["integrations.retries", "caching.idempotent-worker"]
sources: ["https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html"]
schema_version: 1
---

# Dead-letter queue

## Коротко

После ограниченных попыток сохраняйте причину и возможность безопасного разбора.

## Плохо

```text
Одно повреждённое сообщение бесконечно блокирует очередь.
```

## Хорошо

```text
Ограниченные повторы → очередь разбора.
Причина, попытки, безопасный повтор после исправления.
```

## Почему

Остальные задания должны продолжать выполняться.

## Когда применять

В записи ошибки не должно быть секретов; повтор выполняется с исходной идентичностью операции.

## Как проверить

- Проверьте повреждённое сообщение, восстановление и повтор.

## Человек

Определяет ответственного за неисправимые сообщения и порядок повторного запуска.

## Агент

Реализует восстановление и обработку повторов, проверяет сбой зависимости и возвращение в рабочее состояние.

Контроль результата:

- Проверьте повреждённое сообщение, восстановление и повтор.

## Источники

- [Using dead-letter queues in Amazon SQS - Amazon Simple Queue Service](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html)
