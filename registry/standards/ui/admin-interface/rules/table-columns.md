---
schema_version: 1
id: "interface.table-columns"
title: "Настройка столбцов"
section: "interface"
level: "recommended"
tags: ["админка", "table-columns", "интерфейс"]
technologies: ["Web"]
published_at: "2026-11-11"
reviewed_at: "2026-11-11"
order: 203
related: ["interface.server-thumbnails"]
sources: ["https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines", "https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html"]
---

# Настройка столбцов

## Коротко

Пользователь выбирает видимость, ширину, порядок и закрепление столбцов.

## Плохо

```text
Все 80 свойств видны сразу.
Порядок можно изменить только в настройках числом.
```

## Хорошо

```text
Выведено 8 из 80 свойств.
Заголовки перетаскиваются за ручку.
Есть изменение ширины, закрепление и сброс.
```

## Почему

Разным сотрудникам нужны разные свойства. Персональная настройка уменьшает шум и не перестраивает рабочее место коллег.

## Когда применять

Списки с несколькими рабочими сценариями. Настройки привязываются к пользователю и виду списка; общий вид требует отдельного права. Обязательный столбец выбора и доступ к записи должны оставаться понятными.

## Как проверить

- Измените вид и снова откройте список.
- Проверьте сброс и независимость настроек двух пользователей.

## Человек

Задаёт исходный вид и обязательные столбцы.

## Агент

Сохраняет настройки по стабильным ID столбцов и добавляет сброс.

## Пример применения

Менеджер туров оставляет цены и даты, редактор — статус и дату проверки. Скрытие столбца не удаляет поле из записи.

## Источники

- [Carbon Design System: Data table](https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines)
- [Understanding Success Criterion 2.5.7: Dragging Movements | WAI | W3C](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html)
