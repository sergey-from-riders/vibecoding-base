---
schema_version: 1
id: "seo.structured-data"
title: "Структурированные данные"
section: "seo"
level: "contextual"
tags: ["seo", "structured-data", "приемка"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1412
related: ["seo.rendered-content"]
sources: ["https://developers.google.com/search/docs/appearance/structured-data/sd-policies", "https://developers.google.com/search/docs/appearance/structured-data/breadcrumb"]
---

# Структурированные данные

## Коротко

Структурированные данные описывают фактическое видимое содержание и соответствуют выбранному типу разметки.

## Плохо

```json
JSON-LD содержит рейтинг 5.0 и 1000 отзывов, которых нет на странице и в системе.
```

## Хорошо

```json
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Главная","item":"https://example.com/"},{"@type":"ListItem","position":2,"name":"Каталог","item":"https://example.com/catalog/"}]}
```

## Почему

Синтаксическая валидность не подтверждает достоверность. Корректная разметка дает возможность расширенного результата, но не гарантирует его показ.

## Когда применять

При наличии поддерживаемого и полезного типа: BreadcrumbList, Product, Article и другие. Не добавляйте неподходящий тип только ради расширенного результата.

### Требования

- Выберите тип и сверяйте его обязательные/рекомендуемые поля с актуальной документацией конкретной функции. JSON-LD является допустимым форматом, а не отдельным runtime приложения.
- Сведения о цене, наличии, организации, авторе и отзывах берутся из фактического содержания; даты и ссылки актуальны.
- Разметка согласована с видимой страницей и доступна роботу. Общие правила не заменяют требования конкретного типа.

## Как проверить

- Проверьте JSON и применимый Rich Results Test, затем вручную сопоставьте поля с содержанием.
- Измените цену/наличие и проверьте синхронное обновление разметки; отсутствие расширенного результата не объявляйте автоматически дефектом кода.

## Человек

Подтверждает фактические цены, отзывы, авторство и применимость выбранного типа разметки.

## Агент

Сверяет JSON-LD с видимым содержанием и документацией функции, выполняет доступные валидаторы и фиксирует ограничения результата.

## Источники

- [Google Search Central: Structured data policies](https://developers.google.com/search/docs/appearance/structured-data/sd-policies)
- [Google Search Central: Breadcrumb](https://developers.google.com/search/docs/appearance/structured-data/breadcrumb)
