---
id: "frontend.performance"
title: "Измеряйте скорость реальных страниц"
section: "frontend"
level: "recommended"
tags: ["performance", "React", "Next.js"]
technologies: ["React", "Next.js"]
reviewed_at: "2026-11-09"
order: 51
related: ["frontend.server-client", "frontend.data-boundary"]
sources: ["https://sre.google/sre-book/service-level-objectives/"]
schema_version: 1
---

# Измеряйте скорость реальных страниц

## Коротко

Оптимизируйте задержку, скачки макета и объём загрузки на целевых устройствах.

## Плохо

```text
Добавить memo везде, не измеряя эффект.
```

## Хорошо

```text
Найти медленный сценарий.
Измерить до и после изменения.
```

## Почему

Локальная оптимизация может усложнить код без заметной пользы.

## Когда применять

Бюджеты зависят от продукта. Web Vitals полезны как ориентир; фиксированный общий лимит JS подходит не каждой странице.

## Как проверить

- Проверьте слабое устройство, загрузку изображений и длинный список.

## Источники

- [Первоисточник](https://sre.google/sre-book/service-level-objectives/)
