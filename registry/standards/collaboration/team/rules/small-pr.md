---
id: "collaboration.small-pr"
title: "Pull request"
section: "collaboration"
level: "recommended"
tags: ["small-pr"]
technologies: []
reviewed_at: "2026-11-09"
order: 13
related: ["collaboration.ownership", "collaboration.preserve-changes"]
sources: ["https://google.github.io/eng-practices/review/developer/small-cls.html"]
schema_version: 1
---

# Pull request

## Коротко

Ревьюеру проще проверить изменение с одной целью и воспроизводимой проверкой.

## Плохо

```text
В одном PR: редизайн, платежи и обновление БД.
```

## Хорошо

```text
PR: исправление двойной оплаты.
Описание причины и тест повторного запроса.
```

## Почему

Разнородные изменения скрывают ошибки и затрудняют откат.

## Когда применять

Размер определяется связностью задачи, а не жёстким лимитом строк.

## Как проверить

- Можно ли объяснить назначение PR одним предложением?

## Человек

Определяет самостоятельный результат, который можно проверить и выпустить.

## Агент

Проверяет рабочее дерево, сохраняет чужие изменения и передаёт diff, команды проверки и ограничения.

Контроль результата:

- Можно ли объяснить назначение PR одним предложением?

## Источники

- [Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
