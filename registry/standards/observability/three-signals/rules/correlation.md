---
id: "operations.correlation"
title: "Связывайте события одной операции"
section: "operations"
level: "recommended"
tags: ["correlation"]
technologies: []
reviewed_at: "2026-11-09"
order: 83
related: ["operations.http-spans", "operations.signals"]
sources: ["https://opentelemetry.io/docs/specs/semconv/http/http-spans/"]
schema_version: 1
---

# Связывайте события одной операции

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

## Источники

- [Первоисточник](https://opentelemetry.io/docs/specs/semconv/http/http-spans/)
