---
id: "languages.javascript-naming"
title: "Имена в JavaScript и TypeScript"
section: "languages"
level: "recommended"
tags: ["naming"]
technologies: ["javascript", "typescript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1101
related: ["languages.bindings", "frontend.component-naming", "frontend.next-file-conventions"]
sources: ["https://google.github.io/styleguide/tsguide.html", "https://react.dev/learn/your-first-component"]
schema_version: 1
---

# Имена в JavaScript и TypeScript

## Коротко

В принятом здесь соглашении JavaScript/TypeScript переменные, параметры, обычные функции и методы называются camelCase; классы, интерфейсы, type aliases и React-компоненты — PascalCase.

## Плохо

```typescript
type invoice_summary = { id: string };
export function Format_invoice(INVOICE: invoice_summary): string {
  return `Счет ${INVOICE.id}`;
}
```

## Хорошо

```typescript
export type InvoiceSummary = { id: string };
export function formatInvoice(invoice: InvoiceSummary): string {
  return `Счет ${invoice.id}`;
}
const currentInvoice: InvoiceSummary = { id: 'inv-7' };
export const invoiceLabel = formatInvoice(currentInvoice);
```

## Почему

Различимые категории и содержательные имена облегчают чтение без искусственных префиксов и несовместимой смены внешнего контракта.

## Когда применять

Для нового и изменяемого JS/TS-кода после принятия этого соглашения. Существующий согласованный стиль не требует массового переименования ради одной правки. Генерируемые имена и контракт SDK могут быть исключением; причина должна быть понятна.

### Подробные условия

Имя должно описывать назначение; сокращения внутри составного имени оформляй последовательно, например loadHttpConfig. Это соглашение проекта, не ограничение синтаксиса языка.

Не меняй имена внешнего JSON/API, заданные контрактом, ради локального стиля. При необходимости преобразуй их один раз на границе. Публичный экспорт переименовывается с учетом потребителей. Имена файлов определяются фреймворком или принятой структурой; PascalCase компонента не означает обязательный PascalCase каждого файла.

## Как проверить

- Новый обычный helper и type alias → проверить имена → formatInvoice и InvoiceSummary соответствуют разным категориям.
- Внешнее поле invoice_id → обработать DTO → контракт сохранен; локальное invoiceId появляется только через явное преобразование.
- Публичная функция переименована → проверить импорты/потребителей → совместимость сохранена или изменение мигрировано явно.

## Человек

Выбирает соглашение проекта и принимает стоимость публичного переименования.

## Агент

Проверяет назначение символа и контракты потребителей; не применяет механическую замену ко всем JSON-ключам и файлам.

## Источники

- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) — Naming and constants; источник соглашения, не требование языка.
- [React: Your First Component](https://react.dev/learn/your-first-component) — Component capitalization and top-level definitions.
