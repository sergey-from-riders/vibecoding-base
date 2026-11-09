---
id: "caching.idempotent-worker"
title: "Считайте повторную доставку обычным сценарием"
section: "caching"
level: "required"
tags: ["idempotent-worker"]
technologies: []
reviewed_at: "2026-11-09"
order: 67
related: ["caching.source-of-truth", "caching.freshness"]
sources: ["https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/"]
schema_version: 1
---

# Считайте повторную доставку обычным сценарием

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

## Источники

- [Первоисточник](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
