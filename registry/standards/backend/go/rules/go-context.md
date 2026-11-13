---
id: "backend.go-context"
title: "Go context"
section: "backend"
level: "recommended"
tags: ["go-context", "Go"]
technologies: ["Go"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 39
related: ["integrations.timeouts", "backend.bounded-concurrency"]
sources: ["https://go.dev/doc/database/cancel-operations", "https://pkg.go.dev/database/sql#Rows"]
schema_version: 1
---

# Go context

## Коротко

Передавайте context родительской операции до зависимого I/O и проверяйте фактическую поддержку отмены драйвером. Отмена сигнализирует остановку, но не откатывает уже совершенный эффект.

## Плохо

```go
// Фрагмент функции, возвращающей error: родительский ctx потерян.
err := db.QueryRowContext(context.Background(), query, orderID).Scan(&title)
if err != nil { return err }
```

## Хорошо

```go
// ctx — контекст HTTP-запроса либо владельца задания.
queryCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
defer cancel()
err := db.QueryRowContext(queryCtx, query, orderID).Scan(&title)
if err != nil { return err }
```

## Почему

Context передается явным аргументом, обычно первым. Производный deadline не продлевает родительский. cancel освобождает ресурсы таймера даже при раннем успехе. database/sql предупреждает: драйвер без поддержки cancellation может вернуть управление только после завершения запроса.

## Когда применять

Для Go I/O в запросах и заданиях; нужны context, time и драйвер БД. В примере db — *sql.DB, query — параметризованный однострочный SELECT, orderID — параметр; 2 секунды иллюстрируют локальный бюджет. Для QueryContext нескольких строк закрывайте Rows и проверяйте Rows.Err; для HTTP — тело ответа и контекст клиента.

Не создавайте Background внутри зависимого вызова только ради обхода timeout. Если бизнес-операция должна продолжиться после HTTP-отмены, передайте ее устойчивой очереди/владельцу с собственным сроком и shutdown; это отдельный lifecycle, не бесхозная goroutine. Отмена cooperative: CPU-цикл должен проверять ctx, а зависимость — поддерживать прерывание. При неопределенном результате записи сверяйте состояние по ID, не делайте вывод «отменено значит не записано».

## Как проверить

1. Родитель отменен при SELECT → зависимый вызов → завершается в согласованном бюджете и освобождает соединение → ошибка, pool stats и завершение goroutine.

2. Дочерний timeout длиннее родительского → задержка → действует ранний deadline → измерение времени и errors.Is.

3. Отмена после возможной записи либо задание, обязанное продолжиться → сверка/устойчивый owner → нет второго эффекта и бесхозной работы → ID операции и результат восстановления.

## Человек

Определяет бюджеты и операции, которые живут дольше HTTP-запроса.

## Агент

Проверяет цепочку ctx, cancel и поддержку отмены реальным драйвером; тестирует освобождение ресурсов, а не только возврат ошибки.

## Источники

- [Go: Canceling in-progress operations, derived context и defer cancel](https://go.dev/doc/database/cancel-operations)
- [database/sql: cancellation драйвера, Rows.Close и Rows.Err](https://pkg.go.dev/database/sql#Rows)
