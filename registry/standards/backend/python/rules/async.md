---
id: "backend.async"
title: "Не блокируйте цикл событий"
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

# Не блокируйте цикл событий

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

## Источники

- [Первоисточник](https://docs.python.org/3.14/library/asyncio-task.html)
