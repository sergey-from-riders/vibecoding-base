---
schema_version: 1
id: "seo.pagination-facets"
title: "Пагинация и индексирование фильтров"
section: "seo"
level: "required"
tags: ["seo", "pagination-facets", "приемка"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1413
related: ["seo.canonical-urls", "interface.incremental-loading"]
sources: ["https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading", "https://developers.google.com/search/docs/crawling-indexing/block-indexing", "https://developers.google.com/crawling/docs/faceted-navigation"]
---

# Пагинация и индексирование фильтров

## Коротко

Страницы каталога имеют устойчивые URL, а индексирование фильтров управляется явной матрицей.

## Плохо

```text
Все страницы имеют URL /catalog/#page-2 и canonical на первую. Фильтры создают бесконечные комбинации URL.
```

## Хорошо

```text
/catalog/?page=2 — самостоятельный URL и self-canonical.
Ссылки «Следующая» ведут через href.
Индексируемые посадочные фильтры перечислены; остальные получают согласованную политику обхода/индексирования.
```

## Почему

Бесконечная прокрутка не гарантирует обнаружение последующих объектов. Фасеты могут создавать большое число малополезных дублей.

## Когда применять

Для каталогов с пагинацией, сортировкой и фильтрами. Решение об индексируемых фильтрах зависит от содержания и поисковых задач.

### Требования

- Каждая логическая страница имеет URL без fragment как единственного номера и доступные ссылки продолжения. Не канонизируйте разные страницы серии на первую.
- Задайте allowlist полезных индексируемых комбинаций и политику остальных. Noindex требует доступности для чтения; robots.txt не заменяет удаление из индекса.
- Не создавайте бесконечные URL из повторных/несовместимых параметров. В профиле обхода Google фасетный URL без результатов, с повторными/бессмысленными фильтрами или несуществующей страницей пагинации возвращает 404 на том же URL; не перенаправляйте все такие случаи на общую страницу ошибки. Это не универсальное требование к пустому внутреннему поиску или намеренно существующей редакционной странице категории.

## Как проверить

- Обойдите каталог без scroll/click-обработчиков и подтвердите достижимость всех нужных объектов.
- Проверьте page=2, несуществующую страницу, повторные/бессмысленные фильтры и фасет без результатов: ошибочные фасетные URL возвращают 404 на исходном адресе. Отдельно проверьте политику обычного внутреннего поиска.

## Человек

Определяет полезные посадочные страницы фильтров и политику остальных комбинаций.

## Агент

Проверяет href пагинации, canonical, конечность обхода, ошибочные комбинации и соответствующие HTTP-статусы.

## Источники

- [Google Search Central: Pagination](https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading)
- [Google Search Central: noindex](https://developers.google.com/search/docs/crawling-indexing/block-indexing)
- [Google Crawling: Faceted navigation](https://developers.google.com/crawling/docs/faceted-navigation)
