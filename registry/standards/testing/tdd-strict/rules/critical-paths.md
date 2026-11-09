---
id: "testing.critical-paths"
title: "Проверяйте важные сценарии целиком"
section: "testing"
level: "recommended"
tags: ["critical-paths"]
technologies: []
reviewed_at: "2026-11-09"
order: 80
related: ["testing.risk", "testing.regression"]
sources: ["https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html"]
schema_version: 1
---

# Проверяйте важные сценарии целиком

## Коротко

Небольшой набор сквозных тестов должен покрывать основные пользовательские действия.

## Плохо

```text
Есть unit-тесты, но кнопка сохранения не связана с API.
```

## Хорошо

```text
Вход → создание → повторное открытие.
Отдельно — отказ доступа и ошибка сети.
```

## Почему

Правильные компоненты могут быть неправильно соединены.

## Когда применять

Не заменяйте все быстрые тесты медленными e2e. Выбирайте сценарии с наибольшей ценой ошибки.

## Как проверить

- Можно ли пройти основной путь на узком экране?

## Источники

- [Первоисточник](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)
