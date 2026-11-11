---
schema_version: 1
id: "interface.media-gallery"
title: "Галерея и описание медиа"
section: "interface"
level: "recommended"
tags: ["админка", "media-gallery", "интерфейс"]
technologies: ["Web"]
published_at: "2026-11-11"
reviewed_at: "2026-11-11"
order: 222
related: ["interface.media-import", "interface.manual-order", "interface.media-editing"]
sources: ["https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/img", "https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html"]
illustrations: {"bad": {"path": "registry/standards/ui/admin-interface/assets/media-bad.webp", "alt": "Галерея и описание медиа: неудобный пример на вымышленных данных"}, "good": {"path": "registry/standards/ui/admin-interface/assets/media-good.webp", "alt": "Галерея и описание медиа: рекомендуемый пример на вымышленных данных"}}
---

# Галерея и описание медиа

## Коротко

Галерея сохраняет связь файла, подписи, описания и порядка при любой перестановке.

## Плохо

```text
Фото перетащили, подпись осталась у соседнего.
Обложка выбирается случайно.
В alt записано IMG_2381.jpg.
```

## Хорошо

```text
Стабильный ID связывает фото и метаданные.
Обложка явно отмечена.
Подпись и альтернативный текст заполняются отдельно.
```

## Почему

Метаданные принадлежат изображению, а не позиции в массиве. Альтернативный текст передаёт смысл изображения, подпись может сообщать дополнительный контекст.

## Когда применять

Галереи и одиночные изображения. Декоративному изображению нужен пустой alt; информативному — содержательное описание. Название файла не заменяет ни описание, ни права на использование.

## Как проверить

- Переставьте и замените изображение: подписи не перепутались.
- Проверьте обложку и краткое превью с +N.

## Человек

Выбирает обложку и пишет подходящие описания.

## Агент

Перемещает объект целиком и не связывает подписи с индексом массива.

## Пример применения

Три фото: «Вулкан», «Палатка», «Тропа». После переноса «Тропы» на первое место её подпись остаётся при ней; отдельно выбранная обложка не меняется без явного правила.

## Источники

- [<img> HTML image embed element - HTML | MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/img)
- [Understanding Success Criterion 2.5.7: Dragging Movements | WAI | W3C](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html)
