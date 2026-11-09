---
id: "integrations.retries"
title: "Retry и backoff"
section: "integrations"
level: "recommended"
tags: ["retries"]
technologies: []
reviewed_at: "2026-11-09"
order: 59
related: ["integrations.timeouts", "integrations.oauth"]
sources: ["https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/"]
schema_version: 1
---

# Retry и backoff

## Коротко

Повторы ограничиваются числом попыток, общим временем и возможностью дублирования действия.

## Плохо

```text
Любая ошибка → бесконечный повтор каждую секунду.
```

## Хорошо

```text
Временная ошибка → пауза с разбросом →
ограниченный повтор с тем же ключом операции.
```

## Почему

Одновременные повторы многих клиентов усиливают перегрузку.

## Когда применять

Учитывайте Retry-After. Неверный пароль или недопустимые данные обычно не исправляются повтором.

## Как проверить

- Проверьте 429, 503, тайм-аут и постоянную ошибку.

## Человек

Определяет допустимое число повторов и последствия дубликатов.

## Агент

Реализует интеграцию по документации установленной версии и проверяет отказ, тайм-аут и повтор.

Контроль результата:

- Проверьте 429, 503, тайм-аут и постоянную ошибку.

## Источники

- [Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
