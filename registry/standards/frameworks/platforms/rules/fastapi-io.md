---
schema_version: 1
id: "frameworks.fastapi-io"
title: "FastAPI: async и блокирующий I/O"
section: "frameworks"
level: "recommended"
tags: ["fastapi-io", "FastAPI", "Python"]
technologies: ["FastAPI", "Python"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 111
related: ["backend.async", "integrations.timeouts"]
sources: ["https://fastapi.tiangolo.com/async/", "https://starlette.dev/threadpool/"]
---

# FastAPI: async и блокирующий I/O

## Коротко

Не вызывайте блокирующий I/O прямо в async def. Для синхронного SDK используйте синхронный endpoint/dependency или явный перенос в ограниченный пул; для нативного async-клиента — await.

## Плохо

```python
@app.get("/report")
async def report():
    return blocking_sdk.fetch_report()  # Блокирует event loop.
```

## Хорошо

```python
from fastapi import FastAPI
from project.integrations import blocking_sdk

app = FastAPI()

@app.get("/report")
def report():
    # SDK настроен на конечные connect/read timeouts.
    return blocking_sdk.fetch_report()
```

## Почему

FastAPI выполняет синхронные endpoint и dependency в пуле потоков. Обычная вспомогательная def-функция, вызванная внутри async endpoint, остается в потоке вызова и автоматически туда не переносится.

## Когда применять

FastAPI/Starlette на ASGI; зафиксируйте фактические версии FastAPI, Starlette, AnyIO и SDK в приложении. Показан синхронный I/O-вызов, возвращающий сериализуемый результат. Этот пример не решает авторизацию endpoint и контракт ответа.

Если endpoint должен оставаться async, используйте документированный перенос блокирующей части, например `anyio.to_thread.run_sync` с управляемым limiter, либо замените SDK на настоящий async-клиент. `await` не делает синхронный вызов неблокирующим. Thread pool — общий ограниченный ресурс; увеличение числа потоков без измерений может перегрузить БД или внешний API.

Установите timeouts самого SDK, предел одновременных вызовов и поведение при насыщении. Отмена HTTP-запроса не гарантирует остановку уже выполняющегося блокирующего вызова в потоке. CPU-нагрузку и долгие задания рассматривайте отдельно: поток для I/O не является универсальным способом параллелить Python-вычисления.

Бюджет отзывчивости задает проект, например p95 легкого endpoint при конкретной смеси запросов; стандарт не назначает произвольное число миллисекунд всем приложениям.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Медленный SDK и параллельный легкий async endpoint | Легкий endpoint укладывается в выбранный бюджет | Нагрузочный отчет с concurrency, latency и версией стенда |
| Тот же SDK через helper, вызванный внутри async def | Проверка обнаруживает блокировку; после исправления бюджет восстановлен | Сравнимые результаты до/после |
| Пул/внешний сервис достиг лимита | Ограниченная очередь или согласованный отказ, без бесконечного накопления | Метрики активных вызовов и ожидания |
| Клиент отключился или SDK завис | Срабатывает timeout SDK; состояние эффекта обрабатывается по контракту | Лог длительности и освобождения ресурса |

Unit-тест с мгновенным mock SDK не проверяет event loop и насыщение пула.

## Человек

Выбирает бюджет задержки, concurrency и допустимое поведение при перегрузке.

## Агент

Прослеживает реальные блокирующие вызовы, включая helpers и dependencies; проверяет таймауты SDK и не обещает отмену работающего потока.

## Источники

- [FastAPI: async и синхронные функции](https://fastapi.tiangolo.com/async/)
- [Starlette: thread pool](https://starlette.dev/threadpool/)
