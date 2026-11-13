---
id: "backend.async"
title: "Async I/O"
section: "backend"
level: "required"
tags: ["async", "Python"]
technologies: ["Python"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 42
related: ["backend.boundaries", "backend.go-context"]
sources: ["https://docs.python.org/3.14/library/asyncio-task.html"]
schema_version: 1
---

# Async I/O

## Коротко

В coroutine не выполняйте блокирующий I/O или длинный CPU-расчет в потоке event loop. Владейте жизненным циклом задач и ограничивайте их количество.

## Плохо

```python
import time

async def wait_tick() -> None:
    time.sleep(0.1)
```

## Хорошо

```python
import asyncio

async def wait_tick() -> None:
    await asyncio.sleep(0.1)
```

## Почему

async def не делает синхронный вызов неблокирующим. Пример показывает только ожидание таймера; для сети нужен async-клиент либо обоснованный вынос блокирующего I/O через asyncio.to_thread. В обычной GIL-сборке это не гарантирует параллельный CPU-расчет; учитывайте реализацию Python и расширения, освобождающие GIL.

## Когда применять

Для asyncio; документация сверена с Python 3.14, показанный пример совместим с более ранними версиями. TaskGroup/asyncio.timeout требуют 3.11+. Используйте context manager/try-finally для ресурсов, после cleanup обычно распространяйте CancelledError. Не подавляйте отмену широким except BaseException. Отмена await на thread не гарантирует остановку уже запущенной функции в потоке: ей нужен собственный срок/кооперативная остановка.

TaskGroup ожидает детей, но не ограничивает их число. Для большого потока используйте ограниченную очередь и фиксированных workers либо ограничение до create_task; semaphore внутри миллиона задач не ограничивает память ожидания. Фоновая задача имеет владельца, обработку исключения и shutdown. Бюджет отзывчивости задайте для конкретного параллелизма, длительности I/O и среды.

## Как проверить

1. Медленный I/O и независимый легкий запрос под согласованной нагрузкой → одновременное выполнение → легкий запрос укладывается в бюджет → распределение latency/event-loop lag.

2. Задача владеет ресурсом → cancel/timeout → cleanup выполнен, отмена дошла владельцу, бесхозных tasks нет → счетчик ресурсов и task snapshot.

3. Вход существенно больше N/Q → запуск → active и очередь ограничены; CPU-вариант вынесен по профилю → метрики памяти/задач и длительность.

## Человек

Определяет нагрузку, бюджет event loop и допустимость завершения фонового I/O.

## Агент

Проверяет синхронные библиотеки внутри async, cleanup и владельца tasks; тестирует cancel отдельно от остановки thread.

## Источники

- [Python 3.14 asyncio: task cancellation, TaskGroup, to_thread](https://docs.python.org/3.14/library/asyncio-task.html)
