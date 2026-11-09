---
id: "testing.critical-paths"
title: "End-to-end тесты"
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

# End-to-end тесты

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

## Человек

Выбирает критические пользовательские сценарии.

## Агент

Подбирает проверку под риск, запускает её и сообщает результат вместе с оставшимися ограничениями.

Контроль результата:

- Можно ли пройти основной путь на узком экране?

## Источники

- [Google Testing Blog: Just Say No to More End-to-End Tests](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)
