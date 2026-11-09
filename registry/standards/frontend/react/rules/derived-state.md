---
id: "frontend.derived-state"
title: "Вычисляйте производные значения без лишнего состояния"
section: "frontend"
level: "recommended"
tags: ["derived-state", "React"]
technologies: ["React"]
reviewed_at: "2026-11-09"
order: 47
related: ["frontend.server-client", "frontend.data-boundary"]
sources: ["https://react.dev/learn/you-might-not-need-an-effect"]
schema_version: 1
---

# Вычисляйте производные значения без лишнего состояния

## Коротко

Если значение полностью определяется текущими данными, вычислите его при отображении.

## Плохо

```javascript
useEffect(() => setFullName(first + " " + last), [first, last]);
```

## Хорошо

```javascript
const fullName = first + " " + last;
```

## Почему

Лишняя копия состояния требует синхронизации и создаёт промежуточные неверные значения.

## Когда применять

Effect нужен для синхронизации с внешней системой. Тяжёлое вычисление оптимизируйте после измерения.

## Как проверить

- Не хранится ли одна информация в нескольких состояниях?

## Источники

- [Первоисточник](https://react.dev/learn/you-might-not-need-an-effect)
