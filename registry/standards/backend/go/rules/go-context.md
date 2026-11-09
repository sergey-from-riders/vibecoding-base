---
id: "backend.go-context"
title: "Go context"
section: "backend"
level: "recommended"
tags: ["go-context", "Go"]
technologies: ["Go"]
reviewed_at: "2026-11-09"
order: 39
related: ["integrations.timeouts", "backend.bounded-concurrency"]
sources: ["https://go.dev/doc/database/cancel-operations", "https://pkg.go.dev/database/sql#Rows"]
schema_version: 1
---

# Go context

## Коротко

Запрос к БД или внешнему сервису должен завершаться при отмене родительской работы.

## Плохо

```go
// В HTTP-обработчике: срок запроса потерян.
ctx := context.Background()
err := db.QueryRowContext(ctx, query, orderID).Scan(&title)
if err != nil { return err }
```

## Хорошо

```go
ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
defer cancel()
err := db.QueryRowContext(ctx, query, orderID).Scan(&title)
if err != nil { return err }
```

## Почему

Зависшие операции занимают соединения и ресурсы.

## Когда применять

Фрагмент функции, возвращающей error: db — *sql.DB, r — *http.Request, query — параметризованный SELECT одной строки. Две секунды — пример, а не норматив. В Go передавайте context явно; фоновая задача должна иметь собственного владельца и срок жизни.

## Как проверить

- Отмените запрос и проверьте завершение зависимых операций.

## Человек

Задаёт бюджет времени запроса и правила отмены работы.

## Агент

Реализует правило в коде сервиса и проверяет ошибку, отмену и граничные входные данные.

Контроль результата:

- Отмените запрос и проверьте завершение зависимых операций.

## Источники

- [Canceling in-progress operations - The Go Programming Language](https://go.dev/doc/database/cancel-operations)
- [sql package - database/sql - Go Packages](https://pkg.go.dev/database/sql#Rows)
