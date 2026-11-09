---
id: "backend.go-context"
title: "Передавайте отмену и ограничивайте время"
section: "backend"
level: "recommended"
tags: ["go-context", "Go"]
technologies: ["Go"]
reviewed_at: "2026-11-09"
order: 39
related: ["backend.boundaries", "backend.errors"]
sources: ["https://go.dev/doc/effective_go"]
schema_version: 1
---

# Передавайте отмену и ограничивайте время

## Коротко

Запрос к БД или внешнему сервису должен завершаться при отмене родительской работы.

## Плохо

```go
db.Query("SELECT ...") // запрос живёт после ухода клиента
```

## Хорошо

```go
ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
defer cancel()
rows, err := db.QueryContext(ctx, query)
```

## Почему

Зависшие операции занимают соединения и ресурсы.

## Когда применять

Две секунды — пример, а не норматив. В Go передавайте context явно; фоновая задача должна иметь собственного владельца и срок жизни.

## Как проверить

- Отмените запрос и проверьте завершение зависимых операций.

## Источники

- [Первоисточник](https://go.dev/doc/effective_go)
