---
schema_version: 1
id: "seo.rendered-content"
title: "Доступность содержания при рендеринге"
section: "seo"
level: "required"
tags: ["seo", "rendered-content", "приемка"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1410
related: ["seo.page-titles", "seo.canonical-urls"]
sources: ["https://developers.google.com/search/docs/crawling-indexing/javascript/javascript-seo-basics", "https://developers.google.com/search/docs/crawling-indexing/mobile/mobile-sites-mobile-first-indexing"]
---

# Доступность содержания при рендеринге

## Коротко

Публичный URL отдает доступное основное содержание и согласованные метаданные после выбранного способа рендеринга.

## Плохо

```text
Карточка доступна только после клика и авторизованного API; прямой URL возвращает пустую оболочку или 404.
```

## Хорошо

```text
Прямой URL карточки возвращает корректный статус.
Основной текст, title, canonical и ссылки доступны в проверенном HTML.
SSR/SSG либо подтвержденный CSR-путь не требуют пользовательского действия для загрузки основного содержания.
```

## Почему

Google выполняет JavaScript, но обход, рендеринг и индексирование являются отдельными этапами. Другие потребители могут не выполнять JS.

## Когда применять

Для сайтов с SSR, SSG, CSR и гибридным рендерингом. Документационный репозиторий не требует JavaScript-runtime; это правило относится к сайту-потребителю.

### Требования

- Проверьте прямую загрузку и клиентский переход, status, canonical, title, ссылки и видимый текст. Не допускайте расхождения существенного содержания.
- Не блокируйте необходимые публичные CSS/JS/API для выбранного робота. Основное содержание не должно требовать scroll/click/type для загрузки.
- Выбирайте SSR/SSG при необходимости предсказуемого получения HTML разными роботами. Если выбран CSR, приемка включает фактический рендеринг и обработку ошибок загрузки.

## Как проверить

- Сравните исходный ответ, DOM после рендеринга и проверку URL целевой поисковой системы.
- Отключите один ресурс, откройте вложенный маршрут напрямую и проверьте отсутствие ложного успешного пустого ответа.

## Человек

Выбирает целевые поисковые системы и обязательное публичное содержание.

## Агент

Сравнивает прямую загрузку и клиентский переход, HTML/DOM, статусы и доступность ресурсов для выбранного робота.

## Источники

- [Google Search Central: JavaScript SEO](https://developers.google.com/search/docs/crawling-indexing/javascript/javascript-seo-basics)
- [Google Search Central: Mobile-first indexing](https://developers.google.com/search/docs/crawling-indexing/mobile/mobile-sites-mobile-first-indexing)
