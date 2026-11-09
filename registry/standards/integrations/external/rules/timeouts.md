---
id: "integrations.timeouts"
title: "Тайм-ауты интеграций"
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

# Тайм-ауты интеграций

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

## Человек

Задаёт общий бюджет ожидания и поведение при недоступности сервиса.

## Агент

Реализует интеграцию по документации установленной версии и проверяет отказ, тайм-аут и повтор.

Контроль результата:

- Смоделируйте зависание и медленное чтение ответа.

## Источники

- [Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
