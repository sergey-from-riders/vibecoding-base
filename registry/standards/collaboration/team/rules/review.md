---
id: "collaboration.review"
title: "Code review"
section: "collaboration"
level: "recommended"
tags: ["review"]
technologies: []
reviewed_at: "2026-11-09"
order: 16
related: ["collaboration.small-pr", "collaboration.ownership"]
sources: ["https://google.github.io/eng-practices/review/reviewer/looking-for.html"]
schema_version: 1
---

# Code review

## Коротко

Ревью должно находить нарушения требований, а не только обсуждать стиль.

## Плохо

```text
Выглядит красиво, принимаем.
```

## Хорошо

```text
Проверены права, ошибки и совместимость.
Тест воспроизводит исходную проблему.
```

## Почему

Успешная сборка не доказывает правильность бизнес-правил.

## Когда применять

Глубина ревью зависит от риска; форматирование лучше поручить инструментам.

## Как проверить

- Проверен хотя бы один отрицательный сценарий?

## Человек

Принимает бизнес-поведение, риски и существенные архитектурные решения.

## Агент

Проверяет рабочее дерево, сохраняет чужие изменения и передаёт diff, команды проверки и ограничения.

Контроль результата:

- Проверен хотя бы один отрицательный сценарий?

## Источники

- [What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
