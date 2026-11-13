---
id: "frontend.derived-state"
title: "Производное состояние"
section: "frontend"
level: "recommended"
tags: ["derived-state", "React"]
technologies: ["React"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 47
related: ["frontend.remote-drafts", "frontend.hooks", "frontend.data-boundary"]
sources: ["https://react.dev/learn/you-might-not-need-an-effect", "https://react.dev/learn/choosing-the-state-structure"]
schema_version: 1
---

# Производное состояние

## Коротко

Значение, полностью определяемое текущими props/state, вычисляй при render, а не синхронизируй через отдельный state и Effect.

## Плохо

```jsx
import { useEffect, useState } from 'react';
export function ItemCount({ items }) {
  const [count, setCount] = useState(items.length);
  useEffect(() => setCount(items.length), [items]);
  return <output>{count}</output>;
}
```

## Хорошо

```jsx
export function ItemCount({ items }) {
  const count = items.length;
  return <output>{count}</output>;
}
```

## Почему

Дублирование требует дополнительной синхронизации и создает промежуточное устаревшее значение. Чистое вычисление сохраняет один источник данных.

## Когда применять

Для React-компонентов с производными данными. Пример — JSX-фрагмент компонента, а не приложение. Независимый черновик или действительно внешняя подписка не удаляются ради формального уменьшения числа state/Effect.

### Подробные условия

Это относится к фильтрации, счетчикам и признакам доступности. Вычисление должно быть чистым и не мутировать вход.

Независимый редактируемый черновик — другое состояние с собственной жизнью; его обновление описывает frontend.remote-drafts. Effect уместен для синхронизации с внешней системой. `useMemo` добавляй при обоснованной стоимости/стабильности ссылки; он не нужен для корректности обычного вычисления. Отображаемая клиентом сумма не является авторитетным расчетом платежа.

## Как проверить

- items изменились → следующий render → count сразу соответствует новой длине без дополнительного эффекта.
- Пустой список → render → показан 0; входной массив не изменен.
- Форма содержит несохраненный черновик → пришел refetch → он не заменен под предлогом устранения дублирующего state; действует правило конфликта.

## Человек

Определяет, является значение производным или самостоятельным пользовательским вводом.

## Агент

Проверяет зависимости вычисления и не добавляет Effect/useMemo без конкретной причины.

## Пример применения

Если фильтр меняет список, количество считается из отфильтрованного результата в том же render. Если пользователь редактирует сохраненное название, черновик хранится отдельно и защищается от фонового обновления.

## Источники

- [React: You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect) — Derivation during render and intentional independent state.
- [React: Choosing the State Structure](https://react.dev/learn/choosing-the-state-structure) — Contradictions, redundancy and duplicated state.
