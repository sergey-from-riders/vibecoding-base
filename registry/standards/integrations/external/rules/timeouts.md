---
id: "integrations.timeouts"
title: "Ограничивайте время внешнего запроса"
section: "integrations"
level: "required"
tags: ["timeouts"]
technologies: []
reviewed_at: "2026-11-09"
order: 58
related: ["integrations.retries", "integrations.oauth"]
sources: ["https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/"]
schema_version: 1
---

# Ограничивайте время внешнего запроса

## Коротко

У каждого сетевого вызова должен быть срок ожидания и понятный результат при сбое.

## Плохо

```text
Ждать ответа провайдера бесконечно.
```

## Хорошо

```text
Тайм-аут по бюджету операции.
Понятная ошибка или повтор по правилам.
```

## Почему

Зависший провайдер не должен занимать все ресурсы приложения.

## Когда применять

Различайте тайм-аут соединения и всей операции. Значения выбираются по измерениям.

## Как проверить

- Смоделируйте зависание и медленное чтение ответа.

## Источники

- [Первоисточник](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
