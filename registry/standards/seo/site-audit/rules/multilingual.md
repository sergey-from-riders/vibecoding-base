---
schema_version: 1
id: "seo.multilingual"
title: "Языковые версии и hreflang"
section: "seo"
level: "contextual"
tags: ["seo", "multilingual", "приемка"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1414
related: []
sources: ["https://developers.google.com/search/docs/specialty/international/localized-versions", "https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls?hl=ru"]
---

# Языковые версии и hreflang

## Коротко

Языковые версии имеют стабильные URL, корректные связи и содержание соответствующего языка.

## Плохо

```html
Все hreflang ведут на одну русскую страницу; английская версия канонизируется на русский оригинал без причины.
```

## Хорошо

```html
<link rel="alternate" hreflang="ru" href="https://example.com/ru/delivery/">
<link rel="alternate" hreflang="en" href="https://example.com/en/delivery/">
<link rel="canonical" href="https://example.com/ru/delivery/">
```

## Почему

Hreflang описывает соответствующие языковые/региональные варианты. Он не переводит страницу и не заменяет выбор языка пользователем.

## Когда применять

При наличии нескольких языковых или региональных версий. Для одноязычного сайта hreflang не требуется.

### Требования

- Укажите поддерживаемые коды языка и при необходимости региона; регион без языка не используется.
- Связи взаимны и включают саму страницу. Canonical согласован с языком и политикой дублей; отсутствующий перевод не подменяется нерелевантной страницей.
- Пользователь может перейти между вариантами. Не делайте IP/языковой redirect единственным способом доступа к версии; HTML lang проверяется для доступности.

## Как проверить

- Проверьте пары страниц, обратные ссылки, статусы и фактический язык содержания.
- Откройте каждую версию напрямую с разными языковыми настройками и без cookies.

## Человек

Выбирает поддерживаемые языки/регионы и проверяет качество переводов.

## Агент

Проверяет взаимный hreflang, коды, canonical, статусы, HTML lang и прямой доступ без принудительной смены версии.

## Источники

- [Google Search Central: Localized versions](https://developers.google.com/search/docs/specialty/international/localized-versions)
- [Google Search Central: Canonical URLs](https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls?hl=ru)
