---
id: "caching.outbox"
title: "Transactional outbox"
section: "caching"
level: "contextual"
tags: ["outbox"]
technologies: []
reviewed_at: "2026-11-09"
order: 68
related: ["database.transactions", "caching.idempotent-worker"]
sources: ["https://learn.microsoft.com/en-us/power-platform/architecture/reference-architectures/transactional-outbox-pattern"]
schema_version: 1
---

# Transactional outbox

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

## Человек

Определяет требуемую гарантию доставки и процедуру сверки.

## Агент

Реализует восстановление и обработку повторов, проверяет сбой зависимости и возвращение в рабочее состояние.

Контроль результата:

- После аварии событие доставляется без второго бизнес-эффекта?

## Источники

- [Implement the Transactional Outbox pattern with Dataverse - Power Platform](https://learn.microsoft.com/en-us/power-platform/architecture/reference-architectures/transactional-outbox-pattern)
