---
id: "backend.async"
title: "Async I/O"
section: "backend"
level: "required"
tags: ["async", "Python"]
technologies: ["Python"]
reviewed_at: "2026-11-09"
order: 42
related: ["backend.boundaries", "backend.go-context"]
sources: ["https://docs.python.org/3.14/library/asyncio-task.html"]
schema_version: 1
---

# Async I/O

## Коротко

В async-коде используйте асинхронный ввод-вывод или выносите блокирующую работу.

## Плохо

```python
async def handler():
    time.sleep(5)
```

## Хорошо

```python
async def handler():
    await asyncio.sleep(5)
```

## Почему

Один блокирующий вызов может задержать другие запросы процесса.

## Когда применять

Для Python asyncio. CPU-задачи обычно требуют процессов или выделенного worker; to_thread не делает произвольную CPU-работу параллельной в обычной сборке с GIL.

## Как проверить

- Параллельный лёгкий запрос остаётся отзывчивым?

## Человек

Определяет требования к задержке и пропускной способности.

## Агент

Реализует правило в коде сервиса и проверяет ошибку, отмену и граничные входные данные.

Контроль результата:

- Параллельный лёгкий запрос остаётся отзывчивым?

## Источники

- [Coroutines and tasks — Python 3.14.10 documentation](https://docs.python.org/3.14/library/asyncio-task.html)
