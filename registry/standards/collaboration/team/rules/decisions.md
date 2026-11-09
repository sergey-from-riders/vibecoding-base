---
id: "collaboration.decisions"
title: "Architecture Decision Record"
section: "collaboration"
level: "contextual"
tags: ["decisions"]
technologies: []
reviewed_at: "2026-11-09"
order: 18
related: ["collaboration.small-pr", "collaboration.ownership"]
sources: ["https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions.html"]
schema_version: 1
---

# Architecture Decision Record

## Коротко

Сохраните причину выбора, альтернативы и последствия там, где их найдёт команда.

## Плохо

```text
Почему здесь очередь? Никто не помнит.
```

## Хорошо

```text
Решение: очередь для медленной отправки.
Цена: повторная обработка и мониторинг.
```

## Почему

Знание причины помогает отличить нужное ограничение от исторической случайности.

## Когда применять

Для архитектуры и необратимых решений; мелкой правке отдельный ADR не нужен.

## Как проверить

- У решения есть причина и условие пересмотра?

## Человек

Фиксирует принятое решение, ограничения и отвергнутые альтернативы.

## Агент

Проверяет рабочее дерево, сохраняет чужие изменения и передаёт diff, команды проверки и ограничения.

Контроль результата:

- У решения есть причина и условие пересмотра?

## Источники

- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions.html)
