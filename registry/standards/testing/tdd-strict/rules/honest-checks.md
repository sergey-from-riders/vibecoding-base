---
id: "testing.honest-checks"
title: "Статус проверок"
section: "testing"
level: "required"
tags: ["honest-checks"]
technologies: []
reviewed_at: "2026-11-09"
order: 81
related: ["architecture.readiness", "ai-agents.evidence"]
sources: ["https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks"]
schema_version: 1
---

# Статус проверок

## Коротко

Публикуйте точный объём проверки, версию и ограничения.

## Плохо

```text
CI зелёный, хотя скрипт проверяет только наличие папок.
```

## Хорошо

```text
Проверена структура.
Runtime-тесты пока отсутствуют.
```

## Почему

Статус должен объяснять, что именно подтверждено.

## Когда применять

Это инженерное правило справочника, а не требование протокола. Первоисточник описывает подход или механизм; конкретный процесс выбирается проектом.

Проверки контента, линтер, сборка и тест поведения доказывают разные вещи.

## Как проверить

- Откройте команды проверки и сопоставьте их с заявленным результатом.

## Человек

Принимает результат с учётом реально выполненных и пропущенных проверок.

## Агент

Подбирает проверку под риск, запускает её и сообщает результат вместе с оставшимися ограничениями.

Контроль результата:

- Откройте команды проверки и сопоставьте их с заявленным результатом.

## Источники

- [Status checks - GitHub Docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks)
