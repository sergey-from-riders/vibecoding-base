---
id: "frontend.url-state"
title: "Состояние в URL"
section: "frontend"
level: "recommended"
tags: ["url-state", "React"]
technologies: ["React"]
reviewed_at: "2026-11-09"
order: 49
related: ["frontend.server-client", "frontend.data-boundary"]
sources: ["https://developer.mozilla.org/en-US/docs/Web/API/History_API/Working_with_the_History_API", "https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams"]
schema_version: 1
---

# Состояние в URL

## Коротко

Поиск и фильтры, которыми делятся, должны восстанавливаться по ссылке.

## Плохо

```text
После обновления страницы поиск пропал.
```

## Хорошо

```text
/standards/?q=uuid&level=contextual
```

## Почему

Ссылка становится воспроизводимым описанием того, что видит пользователь.

## Когда применять

Не помещайте в URL секреты или чувствительные данные. Временное состояние открытого меню не обязано попадать в адрес.

## Как проверить

- Откройте ссылку в новой вкладке и нажмите «Назад».

## Человек

Определяет, какие фильтры должны сохраняться в общей ссылке.

## Агент

Реализует поведение компонентов и проверяет изменение данных, загрузку и ошибку в браузере.

Контроль результата:

- Откройте ссылку в новой вкладке и нажмите «Назад».

## Источники

- [Working with the History API - Web APIs](https://developer.mozilla.org/en-US/docs/Web/API/History_API/Working_with_the_History_API)
- [URLSearchParams - Web APIs](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
