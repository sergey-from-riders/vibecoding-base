---
id: "ai-agents.least-privilege"
title: "Выдавайте агенту только нужные полномочия"
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

# Выдавайте агенту только нужные полномочия

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

## Источники

- [Первоисточник](https://modelcontextprotocol.io/docs/2025-11-25/tutorials/security/security_best_practices)
