---
id: "interface.keyboard"
title: "Клавиатурная навигация"
section: "interface"
level: "required"
tags: ["keyboard"]
technologies: []
reviewed_at: "2026-11-09"
order: 53
related: ["interface.clear-actions", "interface.contrast"]
sources: ["https://www.w3.org/WAI/WCAG22/Understanding/keyboard.html", "https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html"]
schema_version: 1
---

# Клавиатурная навигация

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

## Человек

Определяет основные действия и ожидаемый порядок работы без мыши.

## Агент

Реализует компоненты и проверяет клавиатуру, узкий экран и доступные названия элементов.

Контроль результата:

- Пройдите страницу Tab, Shift+Tab, Enter и Escape.

## Источники

- [Understanding Success Criterion 2.1.1: Keyboard](https://www.w3.org/WAI/WCAG22/Understanding/keyboard.html)
- [Understanding Success Criterion 2.4.7: Focus Visible](https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html)
