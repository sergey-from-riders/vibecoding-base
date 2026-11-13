# SEO и приемка публичного сайта

Навигация по модулю `seo/site-audit`. Единственные исходные тексты требований находятся в `rules/`.

## Область применения

17 правил для доступных поисковому роботу страниц: заголовки, favicon, индексирование, канонические URL, HTTP, sitemap, ссылки, рендеринг, изображения, structured data, пагинация, локали, метрики и приемка релиза.

| Поле | Значение |
| --- | --- |
| Раздел | `seo` |
| Правил | 17 |
| Содержательная проверка | 2026-11-13 |
| Статус редакции | Кандидат; факт публикации проверяется отдельно |

Google Search Central, Google Crawling Infrastructure, web.dev, W3C и RFC 9110. Один H1 и выбранные бюджеты помечены как профиль проекта, а не всеобщий закон ранжирования.

Уровень обязательности действует в пределах области конкретного правила. Карточка не доказывает соответствие сайта; для каждого применимого ID нужны проверка и свидетельство.

## Правила

| ID | Правило | Уровень |
| --- | --- | --- |
| `seo.page-titles` | [Заголовок страницы title](rules/page-titles.md) | Обязательно |
| `seo.heading-structure` | [Структура заголовков H1–H6](rules/heading-structure.md) | Рекомендуется |
| `seo.meta-description` | [Описание страницы meta description](rules/meta-description.md) | Рекомендуется |
| `seo.favicon` | [Favicon и идентификация сайта](rules/favicon.md) | Обязательно |
| `seo.indexability` | [Индексирование и исключение страниц](rules/indexability.md) | Обязательно |
| `seo.canonical-urls` | [Канонические URL](rules/canonical-urls.md) | Обязательно |
| `seo.status-redirects` | [HTTP-статусы и перенаправления страниц](rules/status-redirects.md) | Обязательно |
| `seo.sitemaps` | [Sitemap и даты изменения](rules/sitemaps.md) | Рекомендуется |
| `seo.crawlable-links` | [Навигационные ссылки и достижимость страниц](rules/crawlable-links.md) | Обязательно |
| `seo.rendered-content` | [Доступность содержания при рендеринге](rules/rendered-content.md) | Обязательно |
| `seo.images` | [Изображения в публичном содержании](rules/images.md) | Обязательно |
| `seo.structured-data` | [Структурированные данные](rules/structured-data.md) | По условию |
| `seo.pagination-facets` | [Пагинация и индексирование фильтров](rules/pagination-facets.md) | Обязательно |
| `seo.multilingual` | [Языковые версии и hreflang](rules/multilingual.md) | По условию |
| `seo.performance` | [Производительность публичного сайта](rules/performance.md) | Рекомендуется |
| `seo.mobile-content` | [Мобильное содержание и метаданные](rules/mobile-content.md) | Обязательно |
| `seo.release-audit` | [Приемка публичного сайта перед релизом](rules/release-audit.md) | Обязательно |

## Применение и проверка

- [Профиль публичного сайта РФ](../../../stacks/public-site-ru.md).
- [Профиль сайта на 1С-Битрикс](../../../stacks/bitrix-site-ru.md).
- [Матрица приемки сайта](../../../../templates/site-acceptance.md).
- [Матрица операций с персональными данными](../../../../templates/ru-data-processing-matrix.md).
- [Содержательная редакция и границы проверки](../../../../docs/revision-2026-11-13.md).

В репозитории отсутствуют исполняемые проверки и шаблоны приложений. Сценарии выполняются в проекте-потребителе с его версиями, данными и инфраструктурой. Публикация контента проверяется по [контракту](../../../../docs/content-contract.md).

[История модуля](CHANGELOG.md) · [Каталог](../../../../docs/catalog.md).
