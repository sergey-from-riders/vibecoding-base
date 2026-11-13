---
id: "languages.bindings"
title: "Привязки const и let"
section: "languages"
level: "recommended"
tags: ["bindings", "immutability"]
technologies: ["javascript", "typescript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1102
related: ["languages.javascript-naming", "frontend.derived-state"]
sources: ["https://www.typescriptlang.org/docs/handbook/variable-declarations.html", "https://google.github.io/styleguide/tsguide.html"]
schema_version: 1
---

# Привязки const и let

## Коротко

Используй const для привязки, которую не переназначают, и let для действительного переназначения.

## Плохо

```javascript
export function renameUser(user) {
  const CURRENT_USER = user; // имя выбрано только из-за const
  CURRENT_USER.name = 'Новое имя'; // объект вызывающего кода изменен
  return CURRENT_USER;
}
```

## Хорошо

```javascript
export const DEFAULT_TIMEOUT_MS = 5000;
export function renameUser(user, name) {
  const updatedUser = { ...user, name };
  return updatedUser;
}
```

## Почему

Привязка, семантическая константа и неизменяемые данные — разные свойства. Их смешение скрывает мутацию и создает бессмысленный UPPERCASE.

## Когда применять

Для JS/TS. Пример показывает копирование верхнего уровня и не гарантирует независимость вложенных объектов. Для горячего алгоритма допустима контролируемая мутация принадлежащих ему данных; правило не требует всегда копировать все структуры.

### Подробные условия

const не делает объект или массив неизменяемым: их свойства могут меняться. Если нужна неизменяемость, выбери соответствующий контракт владения, readonly-проверку типов или runtime-защиту с учетом ее глубины; не обещай deep immutability от одного ключевого слова.

Обычная const-переменная остается camelCase. UPPER_SNAKE_CASE допускается для именованных констант уровня модуля с устойчивым значением/назначением по соглашению проекта, например DEFAULT_TIMEOUT_MS. Полученный пользователь, результат запроса и callback не становятся такой константой только из-за const.

## Как проверить

- Привязка не переназначается → объявить → const с обычным camelCase.
- Переименовать пользователя через пример → сравнить → возвращен новый объект, исходное name сохранено.
- В объекте есть вложенный объект → изменить его после shallow copy → обнаружена общая ссылка; deep immutability не заявлена.

## Человек

Определяет владение данными и область допустимой мутации.

## Агент

Отделяет запрет переназначения от неизменяемости объекта и не делает все const-имена прописными.

## Источники

- [TypeScript Handbook: Variable Declarations](https://www.typescriptlang.org/docs/handbook/variable-declarations.html) — let, const and binding versus object mutation.
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) — Naming and constants; источник соглашения, не требование языка.
