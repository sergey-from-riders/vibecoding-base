---
schema_version: 1
id: "interface.media-import"
title: "Добавление медиа"
section: "interface"
level: "required"
tags: ["админка", "media-import", "интерфейс"]
technologies: ["Web"]
published_at: "2026-11-11"
reviewed_at: "2026-11-11"
order: 221
related: ["interface.media-gallery"]
sources: ["https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData", "https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop", "https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/file"]
---

# Добавление медиа

## Коротко

Файлы добавляются выбором, перетаскиванием, вставкой из буфера или по прямой ссылке.

## Плохо

```text
Можно выбрать только один файл.
Ошибка десятого файла отменяет всю подборку.
Вставка текста в подпись создаёт лишнее изображение.
```

## Хорошо

```text
Выбрать несколько · Перетащить · Ctrl/Cmd+V · По ссылке.
У каждого файла прогресс, отмена и повтор.
Вставка в описание меняет описание.
```

## Почему

Разные способы добавления соответствуют привычным рабочим действиям. Ошибка одного файла не должна заставлять повторять успешные загрузки.

## Когда применять

Изображения и разрешённые проектом документы. Учитывайте поддержку буфера браузером и сохраняйте кнопку выбора файла. Сервер проверяет содержимое, размер, формат и права; импорт по URL запрещает внутренние адреса и проверяет каждое перенаправление.

## Как проверить

- Загрузите подборку с одним повреждённым файлом.
- Проверьте вставку картинки и обычного текста в разные области.

## Человек

Определяет разрешённые форматы, ограничения и права загрузки.

## Агент

Показывает отдельные состояния файлов и повторяет только неуспешные.

## Пример применения

В учебной галерее можно вставить изображение из буфера в область загрузки. Ссылка на страницу с фото не считается прямой ссылкой на файл; ошибка объясняет различие.

## Источники

- [ClipboardEvent: clipboardData property - Web APIs | MDN](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData)
- [File drag and drop - Web APIs | MDN](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop)
- [<input type="file"> HTML attribute value - HTML | MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/file)
