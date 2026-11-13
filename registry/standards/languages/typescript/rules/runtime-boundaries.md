---
id: "languages.runtime-boundaries"
title: "Проверка внешних данных в TypeScript"
section: "languages"
level: "required"
tags: ["validation", "runtime"]
technologies: ["typescript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1103
related: ["languages.nullability", "frontend.data-boundary"]
sources: ["https://www.typescriptlang.org/docs/handbook/2/narrowing.html"]
schema_version: 1
---

# Проверка внешних данных в TypeScript

## Коротко

Данные из JSON, storage, URL, формы и внешнего SDK проверь во время выполнения там, где они становятся входом доверенной логики.

## Плохо

```typescript
type UserDto = { id: string; displayName: string };
export function decodeUser(value: unknown): UserDto {
  return value as UserDto;
}
```

## Хорошо

```typescript
export type UserDto = { id: string; displayName: string };
export function decodeUser(value: unknown): UserDto {
  if (typeof value !== 'object' || value === null || Array.isArray(value)
    || !('id' in value) || typeof value.id !== 'string' || value.id.length === 0
    || !('displayName' in value) || typeof value.displayName !== 'string') {
    throw new TypeError('Invalid UserDto');
  }
  return { id: value.id, displayName: value.displayName };
}
```

## Почему

Типы исчезают при исполнении JavaScript. Проверка на границе предотвращает ложную уверенность в недоверенном объекте.

## Когда применять

Для TS-кода с внешними данными. Пример относится к уже разобранному JSON, допускает пустое displayName и игнорирует лишние поля; это его локальный контракт. Проверка синтаксиса JSON, лимит размера и авторизация остаются отдельными задачами. Повторно валидировать каждый внутренний вызов после установленной границы не требуется.

### Подробные условия

До проверки используй unknown, затем декодируй по нужному контракту. Assertion `as T`, generic у fetch-клиента и interface не проверяют фактическое значение.

Определи требуемые поля, допустимые значения, null/отсутствие и политику неизвестных полей. Возвращай только нужный внутренний DTO. Для простой формы достаточно явных guards; schema-библиотека оправдана повторным использованием/сложностью, а не самим TypeScript. Ошибка декодирования должна иметь контролируемый результат без раскрытия всего чувствительного payload.

## Как проверить

- Объект с корректными полями и лишним полем → decode → возвращены только id/displayName.
- null, массив, пустой id или неверный тип displayName → decode → TypeError без печати payload.
- displayName пустой, id непустой → decode → успех согласно явно разрешенному контракту.

## Человек

Определяет фактический контракт внешних данных и реакцию на его нарушение.

## Агент

Проверяет guards на отрицательных и граничных значениях; не заменяет декодирование assertion.

## Источники

- [TypeScript Handbook: Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html) — Runtime guards, control flow and discriminated unions.
