---
id: "caching.private-cache"
title: "Разделяйте публичный и персональный кеш"
section: "caching"
level: "required"
tags: ["private-cache", "HTTP"]
technologies: ["HTTP"]
reviewed_at: "2026-11-09"
order: 66
related: ["caching.source-of-truth", "caching.freshness"]
sources: ["https://www.rfc-editor.org/rfc/rfc9111.html"]
schema_version: 1
---

# Разделяйте публичный и персональный кеш

## Коротко

Ключ кеша и HTTP-политика должны учитывать пользователя, организацию и права.

## Плохо

```text
/profile закеширован одинаково для всех.
```

## Хорошо

```text
Персональный ответ: private или no-store.
При серверном кеше учитывается контекст доступа.
```

## Почему

Общий кеш может показать данные одного человека другому.

## Когда применять

Выбор private/no-store зависит от чувствительности; no-cache означает проверку свежести, а не запрет хранения.

## Как проверить

- Последовательно запросите данные двух разных пользователей.

## Источники

- [Первоисточник](https://www.rfc-editor.org/rfc/rfc9111.html)
