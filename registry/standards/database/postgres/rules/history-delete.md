---
id: "database.history-delete"
title: "История и удаление данных"
section: "database"
level: "contextual"
tags: ["history-delete", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 28
related: ["database.constraints", "operations.restore"]
sources: ["https://www.postgresql.org/docs/18/indexes-partial.html", "https://www.postgresql.org/docs/18/plpgsql-trigger.html"]
schema_version: 1
---

# История и удаление данных

## Коротко

Мягкое удаление, история версий и аудит решают разные задачи.

## Плохо

```text
deleted_at есть, но все запросы читают удалённое.
```

## Хорошо

```text
Чтение учитывает deleted_at.
Уникальность и восстановление проверены.
Срок окончательной очистки определён.
```

## Почему

Флаг удаления сам по себе не удаляет данные и не создаёт историю изменений.

## Когда применять

Аудит фиксирует, кто и что изменил; история версий позволяет восстановить прежнее содержимое. Выберите нужные механизмы отдельно. При soft delete проверьте уникальность активных записей, восстановление и окончательную очистку. Срок хранения задаёт политика проекта.

## Как проверить

- Проверьте восстановление, повторное создание и очистку связанных данных.

## Человек

Определяет сроки хранения, восстановление и требования к удалению.

## Агент

Готовит схему или миграцию, проверяет граничные значения и совместимость с текущими запросами.

Контроль результата:

- Проверьте восстановление, повторное создание и очистку связанных данных.

## Источники

- [PostgreSQL: Documentation: 18: 11.8. Partial Indexes](https://www.postgresql.org/docs/18/indexes-partial.html)
- [PostgreSQL: Documentation: 18: 41.10. Trigger Functions](https://www.postgresql.org/docs/18/plpgsql-trigger.html)
