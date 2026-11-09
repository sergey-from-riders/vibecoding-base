---
id: "caching.outbox"
title: "Сохраняйте намерение внешнего действия вместе с данными"
section: "caching"
level: "contextual"
tags: ["outbox"]
technologies: []
reviewed_at: "2026-11-09"
order: 68
related: ["caching.source-of-truth", "caching.freshness"]
sources: ["https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/"]
schema_version: 1
---

# Сохраняйте намерение внешнего действия вместе с данными

## Коротко

Свяжите запись бизнеса и событие, чтобы сбой не потерял отправку.

## Плохо

```text
Заказ сохранён. Сбой перед публикацией события.
```

## Хорошо

```text
Транзакция: заказ + запись outbox.
Worker доставляет событие и отмечает результат.
```

## Почему

Outbox закрывает разрыв между сохранением БД и последующей отправкой.

## Когда применять

Доставка всё равно может повториться; получатель должен поддерживать дедупликацию.

## Как проверить

- После аварии событие доставляется без второго бизнес-эффекта?

## Источники

- [Первоисточник](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
