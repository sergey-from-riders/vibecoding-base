---
schema_version: 1
id: "interface.table-sorting"
title: "Сортировка таблиц"
section: "interface"
level: "required"
tags: ["админка", "table-sorting", "интерфейс"]
technologies: ["Web"]
published_at: "2026-11-11"
reviewed_at: "2026-11-11"
order: 202
related: ["interface.table-columns"]
sources: ["https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines", "https://docs.opensearch.org/latest/search-plugins/searching-data/paginate/"]
---

# Сортировка таблиц

## Коротко

Сортировка применяется ко всей найденной выборке, а не только к загруженным строкам.

## Плохо

```text
На экране 50 из 2000 товаров.
Цена сортируется как текст: 100, 20, 3.
Остальные страницы остаются в старом порядке.
```

## Хорошо

```text
Сервер сортирует все 2000 товаров: 3, 20, 100.
Пустая цена последняя в обоих направлениях.
При равной цене порядок уточняет id.
```

## Почему

Сортировка одной страницы создаёт ложное впечатление самого дешёвого товара. Стабильный дополнительный ключ предотвращает перестановку равных значений между порциями.

## Когда применять

Все столбцы с определённым смыслом сравнения. Для чекбокса, фото и кнопок сортировка обычно не нужна. Цены разных валют сравниваются только с явным правилом пересчёта или группировки.

## Как проверить

- Проверьте оба направления, пустые значения и одинаковые цены.
- Сопоставьте первую и следующую порции.

## Человек

Определяет смысл сравнения, валюту и обработку пустых значений.

## Агент

Реализует типизированную серверную сортировку и проверяет границы страниц.

## Пример применения

SQL-пример для одного валютного набора: ORDER BY amount_minor ASC NULLS LAST, id ASC. Заголовок показывает направление и передаёт его через aria-sort.

## Источники

- [Carbon Design System: Data table](https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines)
- [Paginate results | OpenSearch Documentation](https://docs.opensearch.org/latest/search-plugins/searching-data/paginate/)
