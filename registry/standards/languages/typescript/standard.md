# JavaScript и TypeScript

Документационный модуль `languages/typescript`, раздел `languages`. Правила задают начальные соглашения языка и проверяемые границы исполнения; они не заменяют документацию выбранной версии toolchain.

## Паспорт модуля

| Поле | Значение |
| --- | --- |
| ID | `languages/typescript` |
| Состояние | Кандидат содержания, 2026-11-13 |
| Языки | JavaScript, TypeScript |
| Число правил | 6 |
| Публикация | Не подтверждена; новые правила не содержат выдуманную дату первой публикации |

## Правила

| ID | Правило | Уровень |
| --- | --- | --- |
| `languages.javascript-naming` | [Имена в JavaScript и TypeScript](rules/javascript-naming.md) | Рекомендуется |
| `languages.bindings` | [Привязки const и let](rules/bindings.md) | Рекомендуется |
| `languages.runtime-boundaries` | [Проверка внешних данных в TypeScript](rules/runtime-boundaries.md) | Обязательно |
| `languages.nullability` | [Отсутствие, null и undefined](rules/nullability.md) | Рекомендуется |
| `languages.promise-errors` | [Результаты и ошибки Promise](rules/promise-errors.md) | Обязательно |
| `languages.module-boundaries` | [Модули и разрешение импортов](rules/module-boundaries.md) | Рекомендуется |

## Применение

Выбирайте ID по фактическому стеку. Именование — явно выбранное соглашение проекта; семантика const, типов и Promise — свойства языка/runtime. Фиксируйте версии компилятора, runtime, package manager и параметры, влияющие на контракты. TypeScript не добавляет runtime-валидацию внешнего JSON автоматически.

React/Next conventions описаны в [React](../../frontend/react/standard.md) и [Next.js](../../frontend/next/standard.md). Не применяйте обычный стиль имен файлов к специальным именам фреймворка.

## Проверка и ограничения

В этом модуле только Markdown. Код в статьях — иллюстрации; список фактически выполненных проверок и ограничений находится в [отчете](../../../../docs/revision-2026-11-13/workflow.md). Чтение правила и корректный frontmatter не подтверждают соответствие проекта.

[История](CHANGELOG.md) · [Контракт содержания](../../../../docs/content-contract.md).
