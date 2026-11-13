---
schema_version: 1
id: "seo.sitemaps"
title: "Sitemap и даты изменения"
section: "seo"
level: "recommended"
tags: ["seo", "sitemaps", "приемка"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1408
related: ["seo.canonical-urls"]
sources: ["https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap"]
---

# Sitemap и даты изменения

## Коротко

Sitemap перечисляет выбранные канонические URL и отражает фактическое существенное изменение содержания.

## Плохо

```xml
В sitemap включены 404, приватные URL и noindex; lastmod заменяется текущей датой при каждой сборке.
```

## Хорошо

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://example.com/delivery/</loc><lastmod>2026-11-10</lastmod></url>
</urlset>
```

## Почему

Sitemap помогает обнаружению URL, но не гарантирует индексирование. Неверные даты ухудшают достоверность метаданных.

## Когда применять

Для публичного сайта, особенно большого, нового или со сложной структурой. Для небольшого связного сайта отсутствие sitemap не означает невозможность индексирования.

### Требования

- Включайте абсолютные канонические URL, предназначенные для индексирования. Исключите закрытые, удаленные, redirect и noindex страницы из базового профиля.
- При превышении 50 000 URL или 50 MB в несжатом виде разделяйте sitemap и используйте индекс. XML должен корректно экранировать значения и использовать UTF-8.
- Lastmod, если он указан, отражает значимое изменение страницы; при отсутствии достоверной даты опустите его. Google не использует priority и changefreq как обещание обхода.

## Как проверить

- Распарсите XML, проверьте лимиты, дубли, доступность и статусы выборки URL.
- Сравните lastmod с историей реальных изменений, включая сборку без изменений содержания.

## Человек

Определяет индексируемый набор страниц и смысл значимого изменения материала.

## Агент

Проверяет XML, лимиты, URL, статусы и достоверность lastmod; исключает подмену даты временем сборки.

## Источники

- [Google Search Central: Sitemaps](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap)
