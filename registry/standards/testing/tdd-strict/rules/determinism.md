---
id: "testing.determinism"
title: "Делайте сбои тестов воспроизводимыми"
section: "testing"
level: "recommended"
tags: ["determinism"]
technologies: []
reviewed_at: "2026-11-09"
order: 82
related: ["testing.risk", "testing.regression"]
sources: ["https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html"]
schema_version: 1
---

# Делайте сбои тестов воспроизводимыми

## Коротко

Управляйте временем, случайностью и внешними зависимостями в тестах.

## Плохо

```text
Тест ждёт sleep(10) и зависит от рабочего API.
```

## Хорошо

```text
Управляемые часы и фиксированные данные.
Ожидание конкретного состояния.
```

## Почему

Случайные падения делают команду нечувствительной к настоящим ошибкам.

## Когда применять

Карантин нестабильного теста должен иметь владельца и срок исправления.

## Как проверить

- Можно ли повторить сбой с теми же входными данными?

## Источники

- [Первоисточник](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)
