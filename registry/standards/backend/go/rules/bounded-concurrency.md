---
id: "backend.bounded-concurrency"
title: "Ограничение параллелизма"
section: "backend"
level: "recommended"
tags: ["bounded-concurrency", "Go"]
technologies: ["Go"]
reviewed_at: "2026-11-09"
order: 41
related: ["backend.boundaries", "backend.go-context"]
sources: ["https://go.dev/doc/effective_go#channels", "https://go.dev/doc/articles/race_detector"]
schema_version: 1
---

# Ограничение параллелизма

## Коротко

Каждая запущенная задача должна иметь предел, отмену и понятное завершение.

## Плохо

```text
На каждый файл запускается новая goroutine без лимита.
```

## Хорошо

```text
Очередь с ограничением размера.
Пул работников. Отмена и ожидание завершения.
```

## Почему

Неограниченная параллельность может исчерпать память и соединения.

## Когда применять

Размер пула выбирают измерением. Для общего изменяемого состояния нужны синхронизация и race-проверка.

## Как проверить

- Проверьте всплеск нагрузки, остановку и утечку goroutine.

## Человек

Задаёт допустимую нагрузку и приоритеты задач.

## Агент

Реализует правило в коде сервиса и проверяет ошибку, отмену и граничные входные данные.

Контроль результата:

- Проверьте всплеск нагрузки, остановку и утечку goroutine.

## Источники

- [Effective Go - The Go Programming Language](https://go.dev/doc/effective_go#channels)
- [Data Race Detector - The Go Programming Language](https://go.dev/doc/articles/race_detector)
