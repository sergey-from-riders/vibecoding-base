---
id: "interface.contrast"
title: "Контраст и цвет"
section: "interface"
level: "required"
tags: ["contrast"]
technologies: []
reviewed_at: "2026-11-09"
order: 54
related: ["interface.clear-actions", "interface.keyboard"]
sources: ["https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html", "https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html"]
schema_version: 1
---

# Контраст и цвет

## Коротко

Подпись, значок и достаточный контраст должны сохранять смысл без различения цветов.

## Плохо

```text
Красный блок и зелёный блок без подписей.
```

## Хорошо

```text
✕ Плохо: ошибка скрыта.
✓ Хорошо: ошибка объяснена.
```

## Почему

Не все пользователи одинаково воспринимают цвет.

## Когда применять

Целевой уровень — WCAG 2.2 AA; для обычного текста минимальный контраст 4.5:1 с предусмотренными стандартом исключениями.

## Как проверить

- Понятны ли состояния в чёрно-белом виде и при увеличении?

## Человек

Выбирает палитру и подтверждает читаемость значимых состояний.

## Агент

Реализует компоненты и проверяет клавиатуру, узкий экран и доступные названия элементов.

Контроль результата:

- Понятны ли состояния в чёрно-белом виде и при увеличении?

## Источники

- [Understanding Success Criterion 1.4.3: Contrast (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)
- [Understanding Success Criterion 1.4.1: Use of Color](https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html)
