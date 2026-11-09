---
id: "architecture.thin-slice"
title: "Доведите один сценарий до работающего результата"
section: "architecture"
level: "recommended"
tags: ["thin-slice"]
technologies: []
reviewed_at: "2026-11-09"
order: 4
related: ["architecture.scope", "architecture.one-source"]
sources: ["https://docs.github.com/en/pull-requests/reference/pull-requests"]
schema_version: 1
---

# Доведите один сценарий до работающего результата

## Коротко

Связывайте интерфейс, данные и проверки небольшими законченными изменениями.

## Плохо

```text
20 пустых обработчиков.
Ни один сценарий не работает.
```

## Хорошо

```text
Один запрос → проверка доступа → данные → ответ.
Есть проверка результата.
```

## Почему

Так ошибки взаимодействия обнаруживаются раньше.

## Когда применять

Рекомендация для продуктовой разработки; отдельное исследование может не иметь рабочего интерфейса.

## Как проверить

- Можно ли показать завершённый пользовательский сценарий?

## Источники

- [Первоисточник](https://docs.github.com/en/pull-requests/reference/pull-requests)
