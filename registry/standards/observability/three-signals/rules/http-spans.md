---
id: "operations.http-spans"
title: "Различайте HTTP-код и статус span"
section: "operations"
level: "recommended"
tags: ["http-spans", "OpenTelemetry"]
technologies: ["OpenTelemetry"]
reviewed_at: "2026-11-09"
order: 84
related: ["operations.correlation", "operations.signals"]
sources: ["https://opentelemetry.io/docs/specs/semconv/http/http-spans/"]
schema_version: 1
---

# Различайте HTTP-код и статус span

## Коротко

В OpenTelemetry успешный HTTP-ответ обычно оставляет статус span неустановленным.

## Плохо

```text
HTTP 200 → span OK
Любой HTTP 404 → span OK
```

## Хорошо

```text
HTTP 200 → Unset
HTTP 404, server → Unset
HTTP 404, client → Error по общему правилу
HTTP 500 → Error
```

## Почему

Клиент и сервер интерпретируют часть ошибок по-разному; сам HTTP-код сохраняется отдельно.

## Когда применять

Для стандартной HTTP-инструментации без дополнительного контекста. Сетевой сбой и явно ожидаемый результат могут уточнять классификацию.

## Как проверить

- Сверьте 2xx, 4xx, 5xx и сетевой сбой с semconv используемой версии.

## Источники

- [Первоисточник](https://opentelemetry.io/docs/specs/semconv/http/http-spans/)
