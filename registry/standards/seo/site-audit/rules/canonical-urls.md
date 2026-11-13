---
schema_version: 1
id: "seo.canonical-urls"
title: "Канонические URL"
section: "seo"
level: "required"
tags: ["seo", "canonical-urls", "приемка"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1406
related: ["seo.indexability", "seo.pagination-facets"]
sources: ["https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls?hl=ru", "https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading"]
---

# Канонические URL

## Коротко

Дубли согласованно указывают предпочтительный URL, а уникальные страницы не канонизируются на несоответствующее содержание.

## Плохо

```html
<link rel="canonical" href="https://example.com/">
<!-- Такой canonical установлен на все карточки и все страницы пагинации. -->
```

## Хорошо

```html
<link rel="canonical" href="https://example.com/catalog/drill-d18/">
```

## Почему

Canonical является сигналом выбора представителя дублирующегося содержания. Он не заменяет redirect, авторизацию или удаление страницы.

## Когда применять

Для URL с дублями из параметров, нескольких доменов или вариантов маршрута. Self-canonical принят как соглашение профиля для основной страницы.

### Требования

- Укажите один согласованный абсолютный canonical в head или применимый HTTP Link. Он ведет на доступную релевантную индексируемую страницу без цепи redirects.
- Согласуйте canonical, sitemap, внутренние ссылки, HTTPS/домен и локаль. Не отправляйте все варианты пагинации на первую страницу, если содержание различается.
- Не задавайте conflicting canonical в исходном HTML и после рендеринга. Noindex не используется как способ выбора canonical среди дублей.

## Как проверить

- Проверьте чистый URL, tracking-параметры, другой домен/протокол, локаль и вторую страницу каталога.
- Убедитесь в отсутствии циклов, нескольких конфликтующих canonical и целей с 404/noindex.

## Человек

Выбирает канонические страницы и политику дублей, включая параметры, языки и пагинацию.

## Агент

Проверяет canonical в HTML и HTTP, конечный статус цели, отсутствие циклов и согласованность sitemap/ссылок.

## Источники

- [Google Search Central: Canonical URLs](https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls?hl=ru)
- [Google Search Central: Pagination](https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading)
