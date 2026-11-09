---
id: "frontend.url-state"
title: "Сохраняйте общие фильтры в адресе страницы"
section: "frontend"
level: "recommended"
tags: ["url-state", "React"]
technologies: ["React"]
reviewed_at: "2026-11-09"
order: 49
related: ["frontend.server-client", "frontend.data-boundary"]
sources: ["https://www.rfc-editor.org/rfc/rfc9110.html"]
schema_version: 1
---

# Сохраняйте общие фильтры в адресе страницы

## Коротко

Поиск и фильтры, которыми делятся, должны восстанавливаться по ссылке.

## Плохо

```text
После обновления страницы поиск пропал.
```

## Хорошо

```text
/standards/?q=uuid&level=contextual
```

## Почему

Ссылка становится воспроизводимым описанием того, что видит пользователь.

## Когда применять

Не помещайте в URL секреты или чувствительные данные. Временное состояние открытого меню не обязано попадать в адрес.

## Как проверить

- Откройте ссылку в новой вкладке и нажмите «Назад».

## Источники

- [Первоисточник](https://www.rfc-editor.org/rfc/rfc9110.html)
