---
schema_version: 1
id: "interface.navigation-links"
title: "Ссылки родительских разделов меню"
section: "interface"
level: "required"
tags: ["интерфейс", "navigation-links"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1301
related: ["interface.keyboard-mobile", "interface.row-navigation"]
sources: ["https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/examples/disclosure-navigation-hybrid/"]
---

# Ссылки родительских разделов меню

## Коротко

Родительский раздел меню остается ссылкой на свою страницу; подменю раскрывается отдельной кнопкой.

## Плохо

```html
<button>Каталог</button>
<!-- Страница каталога существует, но перейти на нее из меню нельзя. -->
```

## Хорошо

```html
<nav aria-label="Основная навигация">
  <ul><li>
    <a href="/catalog/">Каталог</a>
    <button type="button" aria-expanded="false" aria-controls="catalog-links"
      aria-label="Подразделы каталога">⌄</button>
    <ul id="catalog-links" hidden>
      <li><a href="/catalog/tools/">Инструменты</a></li>
    </ul>
  </li></ul>
</nav>
```

## Почему

Навигация и раскрытие являются разными действиями. Ссылка сохраняет открытие в новой вкладке, доступность и индексируемый адрес.

## Когда применять

Для верхнего, бокового и мобильного меню, когда родительский пункт имеет собственную страницу. Если страницы нет, достаточно кнопки с названием группы.

### Требования

- Ссылка ведет на существующий URL категории. Соседняя кнопка управляет только подменю; нажатие ссылки не подменяется раскрытием.
- Обработчик кнопки синхронно изменяет aria-expanded и hidden. Пример показывает начальную HTML-разметку, а не готовую реализацию обработчика.
- Tab/Shift+Tab проходят ссылки и кнопки; Escape закрывает подменю и возвращает фокус на его кнопку. Управление доступно touch и без hover.
- Для обычной навигации используйте nav и списки; роль menu не добавляется без полного соответствующего клавиатурного контракта. Активная страница может отмечаться aria-current="page".

## Как проверить

- Откройте родительскую категорию обычным кликом, Enter, Ctrl/Cmd-click и средней кнопкой.
- Отдельно раскройте/закройте подменю клавиатурой и touch; проверьте Escape, фокус и соответствие aria-expanded видимости.

## Человек

Выбирает, у каких пунктов есть собственная страница и дочерние ссылки; проверяет понятность двух действий на телефоне.

## Агент

Реализует ссылку и отдельную disclosure-кнопку; проверяет Enter, Escape, фокус, новую вкладку и прямой URL.

## Источники

- [WAI-ARIA APG: Disclosure Navigation with Top-Level Links](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/examples/disclosure-navigation-hybrid/)
