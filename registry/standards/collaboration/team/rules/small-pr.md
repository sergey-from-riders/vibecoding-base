---
id: "collaboration.small-pr"
title: "Объединяйте в PR одно понятное изменение"
section: "collaboration"
level: "recommended"
tags: ["small-pr"]
technologies: []
reviewed_at: "2026-11-09"
order: 13
related: ["collaboration.ownership", "collaboration.preserve-changes"]
sources: ["https://docs.github.com/en/pull-requests/reference/pull-requests"]
schema_version: 1
---

# Объединяйте в PR одно понятное изменение

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

## Источники

- [Первоисточник](https://docs.github.com/en/pull-requests/reference/pull-requests)
