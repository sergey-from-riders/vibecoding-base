---
id: "backend.errors"
title: "Обработка ошибок"
section: "backend"
level: "required"
tags: ["errors", "Go"]
technologies: ["Go"]
reviewed_at: "2026-11-09"
order: 40
related: ["api.error-details", "testing.regression"]
sources: ["https://go.dev/blog/go1.13-errors"]
schema_version: 1
---

# Обработка ошибок

## Коротко

Сохраняйте причину ошибки внутри системы и возвращайте безопасное объяснение наружу.

## Плохо

```go
func persist(order Order) (*Order, error) {
    result, _ := saveOrder(order)
    return result, nil
}
```

## Хорошо

```go
func persist(order Order) (*Order, error) {
    result, err := saveOrder(order)
    if err != nil {
        return nil, fmt.Errorf("save order: %w", err)
    }
    return result, nil
}
```

## Почему

Игнорирование ошибки создаёт ложный успех.

## Когда применять

Не используйте panic для ожидаемой ошибки запроса. Преобразование внутренних причин в HTTP выполняется на границе.

## Как проверить

- Сбой хранилища не возвращает успешный ответ?

## Человек

Определяет, какие ошибки можно показать пользователю и когда нужна эскалация.

## Агент

Реализует правило в коде сервиса и проверяет ошибку, отмену и граничные входные данные.

Контроль результата:

- Сбой хранилища не возвращает успешный ответ?

## Источники

- [Working with Errors in Go 1.13 - The Go Programming Language](https://go.dev/blog/go1.13-errors)
