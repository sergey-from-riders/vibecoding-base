---
schema_version: 1
id: "frameworks.fastapi-io"
title: "FastAPI: async и блокирующий I/O"
section: "frameworks"
level: "recommended"
tags: ["fastapi-io", "FastAPI", "Python"]
technologies: ["FastAPI", "Python"]
reviewed_at: "2026-11-09"
order: 111
related: ["backend.async", "integrations.timeouts"]
sources: ["https://fastapi.tiangolo.com/async/"]
---

# FastAPI: async и блокирующий I/O

## Коротко

В async-обработчике используйте неблокирующий клиент. Обычный def-обработчик подходит для синхронной библиотеки.

## Плохо

```python
@app.get("/report")
async def report():
    return blocking_sdk.fetch_report()
```

## Хорошо

```python
@app.get("/report")
def report():
    return blocking_sdk.fetch_report()
```

## Почему

Синхронный вызов внутри async def блокирует цикл событий. Обычные def-обработчики FastAPI выполняет в пуле потоков.

## Когда применять

FastAPI, ASGI. Пример использует синхронный SDK. Для async-клиента выбирайте async def + await. Выделение потока не отменяет тайм-ауты; CPU-тяжёлые задачи требуют отдельного рассмотрения.

## Человек

Задаёт время ответа и предел нагрузки на внешний сервис.

## Агент

Проверяет тип SDK, выбирает обработчик и проводит тест параллельных запросов.

## Пример применения

Внешний SDK отчётов поддерживает только синхронный вызов. Endpoint реализован через def, SDK имеет ограничение времени; тяжёлая генерация вынесена в очередь.

## Как проверить

- Медленный SDK не блокирует все остальные запросы.
- Настроены тайм-аут и предел параллелизма.

## Источники

- [Concurrency and async / await - FastAPI](https://fastapi.tiangolo.com/async/)
