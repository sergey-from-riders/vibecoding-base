---
id: "operations.signals"
title: "Observability"
section: "operations"
level: "recommended"
tags: ["signals"]
technologies: []
reviewed_at: "2026-11-09"
order: 85
related: ["operations.correlation", "operations.http-spans"]
sources: ["https://opentelemetry.io/docs/concepts/signals/", "https://prometheus.io/docs/practices/naming/"]
schema_version: 1
---

# Observability

## Коротко

Каждый сигнал должен помогать обнаружить или объяснить проблему.

## Плохо

```text
Много логов, но неизвестно, сколько запросов падает.
```

## Хорошо

```text
Метрика показывает рост ошибок.
Трасса находит медленный вызов.
Лог объясняет событие.
```

## Почему

Сигналы дополняют друг друга, но их объём и стоимость нужно ограничивать.

## Когда применять

Набор сигналов соразмерен системе. Не используйте user_id или полный URL как неограниченные метки метрик.

## Как проверить

- Есть ли контроль числа ошибок, задержек и потерь телеметрии?

## Человек

Выбирает вопросы, на которые должны отвечать логи, метрики и трассы.

## Агент

Готовит воспроизводимые команды, проверяет состояние сервисов и прикладывает фактический результат.

Контроль результата:

- Есть ли контроль числа ошибок, задержек и потерь телеметрии?

## Источники

- [Signals](https://opentelemetry.io/docs/concepts/signals/)
- [Metric and label naming](https://prometheus.io/docs/practices/naming/)
