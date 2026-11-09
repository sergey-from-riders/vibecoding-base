---
id: "interface.consistent-components"
title: "Design system"
section: "interface"
level: "recommended"
tags: ["consistent-components"]
technologies: []
reviewed_at: "2026-11-09"
order: 57
related: ["interface.clear-actions", "interface.keyboard"]
sources: ["https://www.w3.org/WAI/WCAG22/Understanding/consistent-identification.html", "https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html"]
schema_version: 1
---

# Design system

## Коротко

Одинаковые действия должны выглядеть и вести себя одинаково во всех разделах.

## Плохо

```text
Три разных поведения фильтра в трёх списках.
```

## Хорошо

```text
Общий фильтр, пустое состояние и пагинация.
```

## Почему

Последовательность снижает количество действий, которые нужно изучить.

## Когда применять

shadcn — один из вариантов. Плотность, интервалы и число цветов выбираются по задаче, без универсального лимита 8px.

## Как проверить

- Кнопка не меняет размер при загрузке? Цели нажатия удобны?

## Человек

Определяет общие компоненты и визуальные соглашения.

## Агент

Реализует компоненты и проверяет клавиатуру, узкий экран и доступные названия элементов.

Контроль результата:

- Кнопка не меняет размер при загрузке? Цели нажатия удобны?

## Источники

- [Understanding Success Criterion 3.2.4: Consistent Identification](https://www.w3.org/WAI/WCAG22/Understanding/consistent-identification.html)
- [Understanding Success Criterion 2.5.8: Target Size (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)
