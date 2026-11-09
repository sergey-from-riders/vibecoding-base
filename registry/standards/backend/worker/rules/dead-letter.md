---
id: "caching.dead-letter"
title: "Отделяйте неисправимые сообщения от очереди"
section: "caching"
level: "recommended"
tags: ["dead-letter"]
technologies: []
reviewed_at: "2026-11-09"
order: 69
related: ["caching.source-of-truth", "caching.freshness"]
sources: ["https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/"]
schema_version: 1
---

# Отделяйте неисправимые сообщения от очереди

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

## Источники

- [Первоисточник](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
