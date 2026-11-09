---
id: "operations.correlation"
title: "Correlation ID"
section: "operations"
level: "recommended"
tags: ["correlation"]
technologies: []
reviewed_at: "2026-11-09"
order: 83
related: ["operations.http-spans", "operations.signals"]
sources: ["https://opentelemetry.io/docs/concepts/context-propagation/"]
schema_version: 1
---

# Correlation ID

## Коротко

Используйте идентификатор запроса и трассы, чтобы найти связанные события.

## Плохо

```text
Ошибка есть в логах, но непонятно, к какому запросу относится.
```

## Хорошо

```text
Ответ и логи связаны request_id.
Вызовы сервисов связаны trace_id.
```

## Почему

Поддержке легче восстановить последовательность без сбора лишних персональных данных.

## Когда применять

Входящий request_id проверяйте по размеру и формату. Трассировка и ID запроса имеют разные назначения.

## Как проверить

- По ID из ответа можно найти путь запроса?

## Человек

Определяет границы операции и доступ поддержки к диагностике.

## Агент

Готовит воспроизводимые команды, проверяет состояние сервисов и прикладывает фактический результат.

Контроль результата:

- По ID из ответа можно найти путь запроса?

## Источники

- [Context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)
