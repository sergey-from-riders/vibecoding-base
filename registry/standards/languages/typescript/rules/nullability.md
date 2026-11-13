---
id: "languages.nullability"
title: "Отсутствие, null и undefined"
section: "languages"
level: "recommended"
tags: ["nullability", "contracts"]
technologies: ["typescript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1104
related: ["languages.runtime-boundaries", "architecture.contract-first"]
sources: ["https://www.typescriptlang.org/tsconfig/strictNullChecks.html", "https://www.typescriptlang.org/docs/handbook/2/narrowing.html"]
schema_version: 1
---

# Отсутствие, null и undefined

## Коротко

В TypeScript-проекте используй проверку null/undefined (`strictNullChecks`) и опиши их семантику в контракте.

## Плохо

```typescript
export function applyNickname(current: string | null, patch: { nickname?: string | null }) {
  return patch.nickname || current; // null и пустая строка потеряли смысл
}
```

## Хорошо

```typescript
export type NicknamePatch = { nickname?: string | null };
export function applyNickname(current: string | null, patch: NicknamePatch): string | null {
  if (!Object.hasOwn(patch, 'nickname')) return current;
  if (patch.nickname === null || typeof patch.nickname === 'string') return patch.nickname;
  throw new TypeError('nickname must be a string or null');
}
```

## Почему

Явная семантика сохраняет намерение клиента: не менять поле, очистить его или записать допустимое пустое значение.

## Когда применять

Для TypeScript с совместимыми настройками компилятора. В примере: отсутствие — оставить, null — очистить, строка включая пустую — заменить, явный undefined — ошибка. Это проектный PATCH-контракт, не универсальное поведение всех API. Object.hasOwn требует подходящей runtime/lib-версии (ES2022).

### Подробные условия

Отсутствующее необязательное поле, null, пустая строка, 0 и false не взаимозаменяемы. `||` подменяет все falsy-значения; `??` — только null/undefined. Выбирай оператор по семантике, а не по краткости.

Non-null assertion `!` не добавляет runtime-проверку. Применяй его только при доказанном инварианте; при внешнем входе сначала нужен guard. Если различие между отсутствием optional-поля и явным undefined значимо, проверь настройки типов (в том числе exactOptionalPropertyTypes), сериализацию и runtime-контракт.

## Как проверить

- Поле отсутствует → applyNickname → текущее значение сохранено.
- nickname=null либо пустая строка → применить → очистка либо пустая строка различаются и сохраняются.
- nickname присутствует с undefined/неверным типом → применить → TypeError; настройка компилятора не выдается за runtime-защиту.

## Человек

Определяет различия отсутствия, очистки и пустого значения для конкретного поля.

## Агент

Проверяет compiler options и сериализацию; не применяет !/||, чтобы скрыть неразобранный контракт.

## Источники

- [TypeScript: strictNullChecks](https://www.typescriptlang.org/tsconfig/strictNullChecks.html) — Null and undefined as distinct types when enabled.
- [TypeScript Handbook: Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html) — Runtime guards, control flow and discriminated unions.
