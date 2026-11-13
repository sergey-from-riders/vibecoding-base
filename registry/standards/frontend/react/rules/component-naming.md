---
id: "frontend.component-naming"
title: "Имена и определения React-компонентов"
section: "frontend"
level: "required"
tags: ["react", "naming"]
technologies: ["react"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1110
related: ["languages.javascript-naming", "frontend.hooks", "frontend.next-file-conventions"]
sources: ["https://react.dev/learn/your-first-component", "https://google.github.io/styleguide/tsguide.html"]
schema_version: 1
---

# Имена и определения React-компонентов

## Коротко

React-компоненты объявляй на верхнем уровне модуля и используй в JSX под именем с заглавной буквы, обычно PascalCase.

## Плохо

```jsx
function invoiceCard({ title }) {
  return <article>{title}</article>;
}
export function Screen() {
  return <invoiceCard title="Счет" />;
}
```

## Хорошо

```jsx
export function InvoiceCard({ title }) {
  return <article>{title}</article>;
}
export function Screen() {
  return <InvoiceCard title="Счет" />;
}
```

## Почему

Регистр JSX-имени влияет на интерпретацию элемента; вложенное объявление компонента может менять его identity между render и сбрасывать состояние.

## Когда применять

Для React JSX/TSX. Пример — фрагмент компонента, не сборка приложения. Компонент, переданный через свойство объекта, допускает JSX MemberExpression по React; это не основание переименовывать внешний контракт. Формат файлов устанавливается отдельно.

### Подробные условия

Обычные функции, обработчики и переменные остаются camelCase; пропсы/типы компонентов в TypeScript — PascalCase по соглашению проекта. Не вызывай компонент как обычную функцию ради получения JSX.

Нижний регистр в JSX обозначает встроенный/пользовательский HTML-элемент, а не локальную функцию компонента. Имя файла — отдельное соглашение: InvoiceCard.tsx или invoice-card.tsx могут быть допустимы; специальные page.tsx/layout.tsx Next.js не переименовываются по правилу имен компонентов.

## Как проверить

- InvoiceCard используется в JSX → render → вызывается React-компонент и отображается заголовок.
- Локальная функция использована как <invoiceCard> → проверить → обнаружен ошибочный тип элемента, а не принята функция с нижним регистром.
- Родитель перерисован → проверить identity дочернего компонента → верхнеуровневое объявление сохраняет ожидаемое состояние.

## Человек

Выбирает единое именование обычных файлов, сохраняя conventions фреймворка.

## Агент

Проверяет JSX-имена, уровень объявления и реальные импорты; не переносит PascalCase на все функции.

## Источники

- [React: Your First Component](https://react.dev/learn/your-first-component) — Component capitalization and top-level definitions.
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) — Naming and constants; источник соглашения, не требование языка.
