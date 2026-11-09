---
id: "integrations.mcp"
title: "Проверяйте доступ при каждом вызове MCP-инструмента"
section: "integrations"
level: "required"
tags: ["mcp", "MCP"]
technologies: ["MCP"]
reviewed_at: "2026-11-09"
order: 62
related: ["integrations.timeouts", "integrations.retries"]
sources: ["https://modelcontextprotocol.io/docs/2025-11-25/tutorials/security/security_best_practices"]
schema_version: 1
---

# Проверяйте доступ при каждом вызове MCP-инструмента

## Коротко

Описание инструмента помогает модели, но разрешение операции проверяет сервер.

## Плохо

```text
Модель видит инструмент — значит ей разрешена запись.
```

## Хорошо

```text
Сервер проверяет пользователя, scopes, объект
и допустимость конкретного действия.
```

## Почему

Скрытая кнопка и описание инструмента не являются контролем доступа.

## Когда применять

Выбирайте совместимую версию протокола. Не передавайте токены через чужие серверы без проверки аудитории.

## Как проверить

- Отозванный доступ перестаёт работать при следующем вызове?

## Источники

- [Первоисточник](https://modelcontextprotocol.io/docs/2025-11-25/tutorials/security/security_best_practices)
