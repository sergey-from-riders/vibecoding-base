---
id: "interface.keyboard"
title: "Сделайте основные действия доступными с клавиатуры"
section: "interface"
level: "required"
tags: ["keyboard"]
technologies: []
reviewed_at: "2026-11-09"
order: 53
related: ["interface.clear-actions", "interface.contrast"]
sources: ["https://www.w3.org/TR/WCAG22/"]
schema_version: 1
---

# Сделайте основные действия доступными с клавиатуры

## Коротко

Используйте семантические элементы и видимый фокус.

## Плохо

```html
<div onclick="save()">Сохранить</div>
```

## Хорошо

```html
<button type="submit">Сохранить</button>
```

## Почему

Кликабельный блок без семантики недоступен многим пользователям и вспомогательным средствам.

## Когда применять

Библиотека компонентов полезна, но не обязательна. Качественный нативный HTML допустим.

## Как проверить

- Пройдите страницу Tab, Shift+Tab, Enter и Escape.

## Источники

- [Первоисточник](https://www.w3.org/TR/WCAG22/)
