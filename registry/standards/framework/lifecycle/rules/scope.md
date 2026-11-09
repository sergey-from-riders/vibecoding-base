---
id: "architecture.scope"
title: "Сначала определите результат задачи"
section: "architecture"
level: "recommended"
tags: ["scope"]
technologies: []
reviewed_at: "2026-11-09"
order: 1
related: ["architecture.one-source", "architecture.contract-first"]
sources: ["https://docs.github.com/en/pull-requests/reference/pull-requests"]
schema_version: 1
---

# Сначала определите результат задачи

## Коротко

Опишите поведение, которое должен получить пользователь, и способ его проверить.

## Плохо

```text
Сделай современную систему целиком.
```

## Хорошо

```text
Пользователь скачивает счёт.
Учитываем доступ и ошибки.
Готово: чужой счёт скачать нельзя.
```

## Почему

Без границ агент может потратить время на ненужные функции.

## Когда применять

Для изменений поведения. Опечатку можно исправить без отдельного проектного документа.

## Как проверить

- Можно ли понять из задачи, что должно получиться?

## Источники

- [Первоисточник](https://docs.github.com/en/pull-requests/reference/pull-requests)
