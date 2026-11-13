---
schema_version: 1
id: "languages.go-naming"
title: "Go: имена, экспорт и инициализмы"
section: "languages"
level: "recommended"
tags: ["go", "naming", "basics"]
technologies: ["Go"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1001
related: ["languages.go-imports", "backend.boundaries"]
sources: ["https://go.dev/wiki/CodeReviewComments", "https://go.dev/doc/effective_go", "https://go.dev/ref/spec"]
---

# Go: имена, экспорт и инициализмы

## Коротко

В Go имя определяет экспорт. Используйте MixedCaps/mixedCaps, согласованные ID/HTTP/URL и короткие lowercase package names.

## Плохо

```go
package BillingUtils

type invoice_data struct{ UserId string }
const MAX_ITEMS = 100
func Make_invoice(user_id string) invoice_data {
    return invoice_data{UserId: user_id}
}
```

## Хорошо

```go
package billing

// Invoice хранит идентификатор владельца счета.
type Invoice struct{ UserID string }

const maxItems = 100

func newInvoice(userID string) Invoice {
	return Invoice{UserID: userID}
}
```

## Почему

Заглавная первая буква экспортирует объявление package scope, поле или метод; это часть API, а не только оформление. Constants в Go используют те же MixedCaps/mixedCaps, а не Python-профиль UPPER_SNAKE_CASE. Единый регистр инициализмов позволяет последовательно искать UserID, ServeHTTP и URL.

## Когда применять

Для нового рукописного Go-кода. Package name — короткое содержательное слово в нижнем регистре без underscores; выбирайте billing.Invoice вместо billing.BillingInvoice. Имена переменных/неэкспортируемых функций начинаются со строчной, публичных типов/функций — с заглавной. Инициализм внутри имени сохраняет регистр: userID, HTTPClient; в начале неэкспортируемого имени допустимо urlValue.

Экспортируйте только нужный интерфейс пакета, добавляйте doc comments к публичным объявлениям. Короткие i/err/ctx оправданы локальным контекстом; широкая область требует более предметного имени. Правила не требуют вручную переписывать generated code или имена внешнего protocol/schema. Изменение экспортируемого имени либо JSON/DB-тега оценивается как изменение совместимости; переименование Go-поля не должно случайно менять wire contract.

gofmt обязателен для оформления, но не проверяет смысл имени/экспорта; naming-review остается отдельным. Пример показывает стиль, не полную модель счета.

## Как проверить

1. Новый package billing → компиляция и чтение внешним пакетом → Invoice/UserID доступны, newInvoice не экспортирован → compile fixtures.

2. Имена UserId, ServeHttp, MAX_ITEMS → review → исправлены в рукописном коде без переименования protocol field → diff.

3. Переименование существующего exported symbol → проверка клиентов → breaking change замечен или сохранен адаптер → consumer build.

## Человек

Определяет публичную поверхность пакетов и исключения совместимости.

## Агент

Применяет gofmt, проверяет initials и не расширяет экспорт только ради удобства примера.

## Источники

- [Go Code Review Comments: Initialisms, Mixed Caps, Package Names](https://go.dev/wiki/CodeReviewComments)
- [Effective Go: Names и Package names](https://go.dev/doc/effective_go)
- [Go Specification: Exported identifiers](https://go.dev/ref/spec)
