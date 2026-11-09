---
id: "ai-agents.least-privilege"
title: "Минимальные привилегии"
section: "ai-agents"
level: "required"
tags: ["least-privilege"]
technologies: []
reviewed_at: "2026-11-09"
order: 9
related: ["ai-agents.context", "ai-agents.untrusted-input"]
sources: ["https://modelcontextprotocol.io/docs/2025-11-25/tutorials/security/security_best_practices"]
schema_version: 1
---

# Минимальные привилегии

## Коротко

Разрешения инструмента должны соответствовать действию, которое поручил пользователь.

## Плохо

```text
Для чтения каталога выдан ключ администратора.
```

## Хорошо

```text
Для чтения каталога — read-only доступ.
Для записи — ограниченные операции.
```

## Почему

Ошибка агента не должна открывать доступ ко всей системе.

## Когда применять

Для подключённых сервисов и выполнения команд; полномочия проверяет сервер.

## Как проверить

- Можно ли тем же ключом выполнить лишнее действие?

## Человек

Выдаёт доступы нужного уровня и определяет срок их действия.

## Агент

Соблюдает выданные полномочия, проверяет результат инструментов и явно сообщает о недоступных проверках.

Контроль результата:

- Можно ли тем же ключом выполнить лишнее действие?

## Источники

- [Security Best Practices - Model Context Protocol](https://modelcontextprotocol.io/docs/2025-11-25/tutorials/security/security_best_practices)
