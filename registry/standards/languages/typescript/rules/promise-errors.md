---
id: "languages.promise-errors"
title: "Результаты и ошибки Promise"
section: "languages"
level: "required"
tags: ["async", "errors"]
technologies: ["javascript", "typescript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1105
related: ["frontend.states", "testing.honest-checks"]
sources: ["https://typescript-eslint.io/rules/no-floating-promises/"]
schema_version: 1
---

# Результаты и ошибки Promise

## Коротко

У каждой асинхронной операции должен быть владелец результата: await, возврат Promise вызывающему коду или явный обработчик отказа у фоновой операции.

## Плохо

```typescript
export function startSave(save: () => Promise<void>): string {
  void save();
  return 'saved';
}
```

## Хорошо

```typescript
export type SaveResult = { status: 'saved' } | { status: 'failed'; cause: unknown };
export async function saveWithResult(save: () => Promise<void>): Promise<SaveResult> {
  try {
    await save();
    return { status: 'saved' };
  } catch (cause: unknown) {
    return { status: 'failed', cause };
  }
}
```

## Почему

Отложенный отказ не должен становиться ложным сообщением об успехе или неуправляемой ошибкой процесса.

## Когда применять

Для JS/TS Promise API. Пример возвращает внутренний результат; вызывающий код обязан разобрать status, а cause нельзя без очистки выводить пользователю или в журнал. Допустима и передача rejected Promise вызывающему слою, если там явно определен обработчик. Это правило не требует превращать каждую ошибку в Result-объект.

### Подробные условия

Успех показывается после подтвержденного результата. `void promise` только отбрасывает значение; rejection остается необработанным, если никто его не принимает.

Обработчик различает отказ и успех и выполняет нужное освобождение ресурсов. Не скрывай ошибку пустым catch. Для deliberate background operation обоснуй, почему завершение вызывающей функции допустимо раньше, кто обрабатывает отказ и что происходит при завершении процесса. Линтер no-floating-promises помогает найти пропуск, но его настройки не доказывают runtime-корректность.

## Как проверить

- save выполняется успешно с задержкой → await saveWithResult → saved появляется только после завершения.
- save отклоняет Promise → дождаться результата → failed с cause, ложного saved нет.
- Фоновый вызов помечен void → проверить путь отказа и завершение процесса → один void не считается обработкой или гарантией доставки.

## Человек

Определяет допустимую фоновую работу и видимый результат отказа.

## Агент

Проверяет владельца каждого Promise, различает deliberate background и забытый await; не подавляет предупреждение без обработки.

## Источники

- [typescript-eslint: no-floating-promises](https://typescript-eslint.io/rules/no-floating-promises/) — Handled promises; void does not handle rejection.
