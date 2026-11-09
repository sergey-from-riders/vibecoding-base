---
id: "integrations.retries"
title: "Повторяйте только безопасные временные ошибки"
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

# Повторяйте только безопасные временные ошибки

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

## Источники

- [Первоисточник](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
