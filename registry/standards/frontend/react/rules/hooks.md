---
id: "frontend.hooks"
title: "Порядок и область вызова React Hooks"
section: "frontend"
level: "required"
tags: ["react", "hooks"]
technologies: ["react"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1111
related: ["frontend.derived-state", "frontend.server-client", "frontend.component-naming"]
sources: ["https://react.dev/reference/rules/rules-of-hooks", "https://react.dev/reference/react/use", "https://react.dev/reference/react/useEffect"]
schema_version: 1
---

# Порядок и область вызова React Hooks

## Коротко

useState, useEffect и другие обычные React Hooks вызывай на верхнем уровне функционального компонента или custom Hook, до условных return.

## Плохо

```jsx
import { useState } from 'react';
export function Counter({ enabled }) {
  if (!enabled) return null;
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

## Хорошо

```jsx
import { useState } from 'react';
export function Counter({ enabled }) {
  const [count, setCount] = useState(0);
  if (!enabled) return null;
  return <button onClick={() => setCount(value => value + 1)}>{count}</button>;
}
```

## Почему

React связывает обычные Hooks с порядком вызова; скрытый пропуск нарушает связь состояния и render. Cleanup и зависимости обеспечивают корректную синхронизацию с внешней системой.

## Когда применять

Для React Hooks в поддерживаемой версии. Проверены текущие React docs (19.x); исключение API use нельзя переносить на useState/useEffect. В Next.js соответствующие state/effect hooks требуют Client Component; не каждый файл с именем useSomething является серверно совместимым.

### Подробные условия

Не помещай их в цикл, условие, callback, обработчик события или обычный helper. Custom Hook использует имя use + заглавная буква и действительно вызывает Hooks; добавлять use к обычной функции ради стиля не нужно.

Для Effect перечисляй реактивные зависимости и возвращай cleanup подписки/ресурса, когда он нужен. Не подавляй проверку зависимостей для маскировки устаревшего замыкания. API use в React 19+ имеет отдельное исключение: его можно вызывать в условии/цикле, но сохраняются его собственные ограничения, включая React-контекст вызова и запрет try/catch вокруг use.

## Как проверить

- enabled true → false → true → render → порядок Hooks сохраняется и состояние не повреждено.
- Hook вызван из event handler/после условного return → lint/review → нарушение выявлено.
- Effect переподписывается или компонент размонтирован → проверить → предыдущий ресурс освобожден; API use проверен по своим правилам.

## Человек

Определяет нужную внешнюю синхронизацию и lifecycle ресурса.

## Агент

Проверяет порядок и зависимости Hooks, различает специальный use и обычные Hooks, не создает эффект для производного значения.

## Источники

- [React: Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) — Call order and React function boundaries.
- [React: use](https://react.dev/reference/react/use) — Calling use in loops and conditions; restrictions.
- [React: useEffect](https://react.dev/reference/react/useEffect) — Dependencies, cleanup and race conditions in data fetching.
