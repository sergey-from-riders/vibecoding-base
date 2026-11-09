---
id: "architecture.contract-first"
title: "Согласуйте границу до реализации"
section: "architecture"
level: "recommended"
tags: ["contract-first", "OpenAPI"]
technologies: ["OpenAPI"]
reviewed_at: "2026-11-09"
order: 3
related: ["architecture.scope", "architecture.one-source"]
sources: ["https://spec.openapis.org/oas/v3.2.0.html"]
schema_version: 1
---

# Согласуйте границу до реализации

## Коротко

Опишите вход, выход, ошибки и права, когда несколько частей системы взаимодействуют.

## Плохо

```text
Frontend ждёт price.
Backend отдаёт amount.
```

## Хорошо

```text
Контракт: amountMinor + currency.
Обе стороны проверяют один контракт.
```

## Почему

Несогласованные интерфейсы ломают интеграцию даже при работающих отдельных модулях.

## Когда применять

Для внешних границ и совместной разработки. Внутренней функции не всегда нужен OpenAPI.

## Как проверить

- Есть ли пример успешного ответа и ошибки?

## Источники

- [Первоисточник](https://spec.openapis.org/oas/v3.2.0.html)
