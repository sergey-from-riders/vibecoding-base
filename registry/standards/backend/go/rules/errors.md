---
id: "backend.errors"
title: "Обрабатывайте ошибки там, где известен контекст"
section: "backend"
level: "required"
tags: ["errors", "Go"]
technologies: ["Go"]
reviewed_at: "2026-11-09"
order: 40
related: ["backend.boundaries", "backend.go-context"]
sources: ["https://go.dev/doc/effective_go"]
schema_version: 1
---

# Обрабатывайте ошибки там, где известен контекст

## Коротко

Сохраняйте причину ошибки внутри системы и возвращайте безопасное объяснение наружу.

## Плохо

```go
result, _ := saveOrder(order)
return success(result)
```

## Хорошо

```go
result, err := saveOrder(order)
if err != nil { return fmt.Errorf("save order: %w", err) }
return result, nil
```

## Почему

Игнорирование ошибки создаёт ложный успех.

## Когда применять

Не используйте panic для ожидаемой ошибки запроса. Преобразование внутренних причин в HTTP выполняется на границе.

## Как проверить

- Сбой хранилища не возвращает успешный ответ?

## Источники

- [Первоисточник](https://go.dev/doc/effective_go)
