---
id: "interface.forms"
title: "Формы и валидация"
section: "interface"
level: "required"
tags: ["forms"]
technologies: []
reviewed_at: "2026-11-09"
order: 56
related: ["interface.clear-actions", "interface.keyboard"]
sources: ["https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html"]
schema_version: 1
---

# Формы и валидация

## Коротко

Сохраняйте введённые данные и показывайте, что именно нужно исправить.

## Плохо

```text
После отправки форма очищена, сверху «Ошибка».
```

## Хорошо

```text
Под email: «Проверьте адрес».
Текст сохранён; ошибка связана с полем.
```

## Почему

Пользователь не должен повторять ввод из-за исправимой ошибки.

## Когда применять

Проверка браузера улучшает удобство, но сервер всё равно проверяет данные.

## Как проверить

- Скринридер объявляет ошибку и проблемное поле?

## Человек

Определяет обязательные поля и способ исправления ошибки.

## Агент

Реализует компоненты и проверяет клавиатуру, узкий экран и доступные названия элементов.

Контроль результата:

- Скринридер объявляет ошибку и проблемное поле?

## Источники

- [Understanding Success Criterion 3.3.1: Error Identification](https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html)
