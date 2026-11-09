---
id: "interface.clear-actions"
title: "UI-тексты"
section: "interface"
level: "recommended"
tags: ["clear-actions"]
technologies: []
reviewed_at: "2026-11-09"
order: 52
related: ["interface.keyboard", "interface.contrast"]
sources: ["https://www.w3.org/WAI/WCAG22/Understanding/labels-or-instructions.html"]
schema_version: 1
---

# UI-тексты

## Коротко

Подпись кнопки должна объяснять, что произойдёт после нажатия.

## Плохо

```text
Кнопка «ОК» отправляет заявку и списывает деньги.
```

## Хорошо

```text
Кнопки «Сохранить черновик» и «Оплатить 500 ₽».
```

## Почему

Неясная подпись увеличивает вероятность ошибочного действия.

## Когда применять

Особенно важно для оплаты, публикации и удаления.

## Как проверить

- Можно ли предсказать результат без пробного нажатия?

## Человек

Определяет результат действия и понятную пользователю терминологию.

## Агент

Реализует компоненты и проверяет клавиатуру, узкий экран и доступные названия элементов.

Контроль результата:

- Можно ли предсказать результат без пробного нажатия?

## Источники

- [Understanding Success Criterion 3.3.2: Labels or Instructions](https://www.w3.org/WAI/WCAG22/Understanding/labels-or-instructions.html)
