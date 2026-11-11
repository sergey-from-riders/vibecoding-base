---
schema_version: 1
id: "interface.table-layout"
title: "Табличные представления"
section: "interface"
level: "recommended"
tags: ["админка", "table-layout", "интерфейс"]
technologies: ["Web"]
published_at: "2026-11-11"
reviewed_at: "2026-11-11"
order: 201
related: ["interface.table-columns", "interface.row-selection"]
sources: ["https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines", "https://shopify.dev/docs/api/app-home/latest/patterns/compositions/index-table"]
illustrations: {"bad": {"path": "registry/standards/ui/admin-interface/assets/table-bad.webp", "alt": "Табличные представления: неудобный пример на вымышленных данных"}, "good": {"path": "registry/standards/ui/admin-interface/assets/table-good.webp", "alt": "Табличные представления: рекомендуемый пример на вымышленных данных"}}
---

# Табличные представления

## Коротко

Таблица помогает сравнивать однотипные записи и выполнять групповые действия.

## Плохо

```text
Каталог услуг: длинные карточки.
Цена и статус спрятаны внутри каждой карточки.
```

## Хорошо

```text
Каталог услуг: Название | Цена | Статус | Изменено.
Записи можно сравнить, открыть и выделить.
```

## Почему

Одинаковые свойства на одной линии быстрее просматривать. Таблица полезна, когда важны сравнение и обработка списка, а не только изображение.

## Когда применять

Товары, услуги, туры, статьи, заказы, заявки, клиенты, остатки и документы. Для расписания выбирайте календарь, для этапов работы — канбан; визуальную подборку можно показывать карточками.

## Как проверить

- Сравните три записи без открытия карточек.
- Проверьте, что длинное название доступно целиком.

## Человек

Выбирает свойства для сравнения и основную задачу списка.

## Агент

Показывает типовые строки, проверяет узкий экран и клавиатуру.

## Пример применения

В каталоге туров видны название, регион, цена с валютой и статус. На телефоне часть столбцов можно скрыть, сохранив название и основные действия.

## Источники

- [Carbon Design System: Data table](https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines)
- [Index table](https://shopify.dev/docs/api/app-home/latest/patterns/compositions/index-table)
