---
schema_version: 1
id: "languages.go-types"
title: "Go: типы и проверка значений на границе"
section: "languages"
level: "recommended"
tags: ["go", "types", "basics"]
technologies: ["Go"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1003
related: ["languages.go-naming", "backend.errors", "backend.boundaries"]
sources: ["https://go.dev/ref/spec", "https://go.dev/wiki/CodeReviewComments", "https://go.dev/doc/faq#nil_error"]
---

# Go: типы и проверка значений на границе

## Коротко

Выражайте устойчивую структуру данными struct и конкретными типами. Разные предметные идентификаторы при реальном риске смешения могут иметь отдельные defined types; тип не заменяет runtime-проверку входа.

## Плохо

```go
type UserID = string
type OrderID = string
// Оба alias остаются string: случайная подмена компилируется.
```

## Хорошо

```go
type UserID string
type OrderID string

type Assignment struct {
	OrderID OrderID
	OwnerID UserID
}
```

## Почему

Defined type отличается от underlying type; alias лишь дает прежнему типу другое имя. Compiler предотвращает часть случайных присваиваний, но явное преобразование и пустое значение остаются возможными. Для ID из JSON нужны отдельные проверки формата, существования и полномочий.

## Когда применять

Для Go domain/API boundaries. Конкретный struct предпочтителен map[string]any, если поля известны; any допустим для действительно открытой структуры с дальнейшим type switch/проверкой. Не создавайте interface без потребителя: маленький интерфейс описывает нужное поведение, а не зеркалирует все методы реализации. Для отсутствия/ошибки определите nil, ok или error явно, не смешивайте с допустимым нулем.

Учитывайте zero value: nil map читается, но запись требует инициализации; nil slice допускает append. Interface с typed nil pointer не равен nil interface — это важно при возврате error. Не утверждайте, что named integer автоматически ограничивает диапазон или overflow; размер int зависит от платформы, для wire/storage выберите явный контракт ширины/диапазона. Для длительности используйте time.Duration с единицами, для денег — отдельный точный профиль.

Generics вводятся для повторяющегося типобезопасного алгоритма, когда это упрощает потребителей; они не являются обязательным слоем каждого DTO. Возможности языка и синтаксис должны соответствовать go directive проекта. Пример — декларации внутри пакета, не законченный валидатор ID.

## Как проверить

1. Значения OrderID и UserID → обычное присваивание одному полю → корректный тип принимается, переменная другого defined type без conversion не компилируется → compile fixtures.

2. Пустой/неверный строковый ID проходит explicit conversion → boundary validator → отклонен по отдельному контракту → отрицательный runtime-тест проекта.

3. nil map/interface и нулевой числовой ввод → код соответствующей границы → нет неучтенного panic/ложного успеха, результат задокументирован → узкие edge tests.

## Человек

Определяет семантику типов, допустимые нулевые значения и границы валидации.

## Агент

Различает alias/defined type, проверяет nil и диапазоны; не подменяет runtime-проверку компиляцией.

## Источники

- [Go Specification: type declarations, assignability, zero values, maps/interfaces](https://go.dev/ref/spec)
- [Go Code Review Comments: Interfaces и In-Band Errors](https://go.dev/wiki/CodeReviewComments)
- [Go FAQ: typed nil внутри interface и error](https://go.dev/doc/faq#nil_error)
