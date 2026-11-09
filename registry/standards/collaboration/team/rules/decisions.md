---
id: "collaboration.decisions"
title: "Записывайте причины существенных решений"
section: "collaboration"
level: "contextual"
tags: ["decisions"]
technologies: []
reviewed_at: "2026-11-09"
order: 18
related: ["collaboration.small-pr", "collaboration.ownership"]
sources: ["https://docs.github.com/en/pull-requests/reference/pull-requests"]
schema_version: 1
---

# Записывайте причины существенных решений

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

## Источники

- [Первоисточник](https://docs.github.com/en/pull-requests/reference/pull-requests)
