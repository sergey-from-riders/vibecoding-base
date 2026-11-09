---
id: "testing.integration"
title: "Интеграционные тесты"
section: "testing"
level: "recommended"
tags: ["integration", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 79
related: ["database.migrations", "api.openapi"]
sources: ["https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html", "https://www.postgresql.org/docs/18/ddl-constraints.html"]
schema_version: 1
---

# Интеграционные тесты

## Коротко

Изолированные тесты не заменяют проверки SQL, миграций и форматов взаимодействия.

## Плохо

```text
Mock всегда возвращает успех; реальная миграция не запускается.
```

## Хорошо

```text
Тестовая БД → миграции → запрос → проверка результата.
```

## Почему

Ошибка схемы или прав БД может не проявиться в mock.

## Когда применять

Используйте отдельную тестовую среду и ограниченные данные. Рабочая база не должна служить полигоном.

## Как проверить

- Проверены реальные права роли и ограничения схемы?

## Человек

Определяет границы, где ошибка взаимодействия наиболее опасна.

## Агент

Подбирает проверку под риск, запускает её и сообщает результат вместе с оставшимися ограничениями.

Контроль результата:

- Проверены реальные права роли и ограничения схемы?

## Источники

- [Google Testing Blog: Just Say No to More End-to-End Tests](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)
- [PostgreSQL: Documentation: 18: 5.5. Constraints](https://www.postgresql.org/docs/18/ddl-constraints.html)
