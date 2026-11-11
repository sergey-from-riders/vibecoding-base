---
schema_version: 1
id: "interface.keyboard-mobile"
title: "Клавиатура и мобильный экран"
section: "interface"
level: "required"
tags: ["админка", "keyboard-mobile", "интерфейс"]
technologies: ["Web"]
published_at: "2026-11-11"
reviewed_at: "2026-11-11"
order: 225
related: ["interface.editor-performance"]
sources: ["https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html", "https://www.w3.org/WAI/ARIA/apg/patterns/table/", "https://www.w3.org/WAI/ARIA/apg/patterns/grid/"]
---

# Клавиатура и мобильный экран

## Коротко

Все основные действия доступны без мыши и на узком экране.

## Плохо

```text
Переставить поле можно только перетаскиванием.
Плавающая панель закрывает кнопку на телефоне.
```

## Хорошо

```text
Есть фокус, подписи и действия «Выше», «Ниже», «Во вкладку».
Панель учитывает экранную клавиатуру.
Широкий код прокручивается внутри своего блока.
```

## Почему

Клавиатура и одиночное нажатие — самостоятельные способы управления. Одна клавиатурная альтернатива не решает требования к альтернативе перетаскиванию указателем.

## Когда применять

Основные сценарии административного интерфейса. Нативная таблица предпочтительна; роль grid требует полноценного управления фокусом. Проверяйте 320 и 390 px, масштаб, светлую и тёмную темы.

## Как проверить

- Пройдите выбор, перестановку и публикацию только клавиатурой.
- Повторите без жеста перетаскивания на узком экране.

## Человек

Определяет критические сценарии для приёмки.

## Агент

Проверяет фокус, семантику и альтернативные способы действия.

## Пример применения

Меню поля содержит «Переместить во вкладку…». После переноса фокус остаётся у того же поля, а не теряется в начале страницы.

## Источники

- [Understanding Success Criterion 2.5.7: Dragging Movements | WAI | W3C](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html)
- [Table Pattern | APG | WAI | W3C](https://www.w3.org/WAI/ARIA/apg/patterns/table/)
- [Grid (Interactive Tabular Data and Layout Containers) Pattern | APG | WAI | W3C](https://www.w3.org/WAI/ARIA/apg/patterns/grid/)
