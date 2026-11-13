---
schema_version: 1
id: "frameworks.fastapi-conventions"
title: "FastAPI: routers, модели и жизненный цикл ресурсов"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["FastAPI", "Pydantic 2", "Python"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1208
related: ["frameworks.fastapi-io", "backend.typed-boundaries"]
sources: ["https://fastapi.tiangolo.com/tutorial/bigger-applications/", "https://fastapi.tiangolo.com/advanced/events/", "https://fastapi.tiangolo.com/tutorial/response-model/"]
---

# FastAPI: routers, модели и жизненный цикл ресурсов

## Коротко

Определите один явный composition root FastAPI, подключайте APIRouter и описывайте вход/выход моделями. Ресурсы процесса создаются и закрываются в lifespan, зависимости запроса — через Depends.

## Плохо

```python
# Импорт модуля сразу открывает соединение и скрыто создает отдельное приложение.
db = connect_to_database()
app = FastAPI()
@app.get("/orders")
def orders():
    return db.query("select * from orders")
```

## Хорошо

```python
from fastapi import APIRouter, FastAPI
from pydantic import BaseModel

class HealthResponse(BaseModel):
    status: str

router = APIRouter(prefix="/health", tags=["health"])

@router.get("", response_model=HealthResponse)
def read_health() -> HealthResponse:
    return HealthResponse(status="ok")

app = FastAPI()
app.include_router(router)
```

## Почему

Роутер, который нигде не включен, не создает endpoint в нужном приложении. Явная сборка приложения и управление ресурсами позволяют тестам подменять зависимости и корректно закрывать соединения.

## Когда применять

Современный FastAPI с Pydantic 2; зафиксируйте версии FastAPI/Starlette/Pydantic/Python в приложении. Пример полностью объявляет простой endpoint без внешнего ресурса. В большем проекте перенесите router в модуль, а include_router оставьте в composition root. Функции/модули — snake_case, модели — CapWords по Python-соглашению.

Pydantic-модель входа и response_model имеют разные роли. Не возвращайте ORM/entity целиком, если публичный ответ ограничен; response model не заменяет право доступа. Согласуйте coercion, optional/null и запрет extra полей согласно API, не считайте любое Pydantic-поле строгим по умолчанию.

Depends используют для контекста/ресурса запроса и его подмены в тесте; не вызывайте dependency как обычную функцию, ожидая внедрения. Ресурсы уровня приложения открывают до yield и закрывают после yield в lifespan; их не создают побочным эффектом импорта. Если lifespan задан, не рассчитывайте одновременно на старые startup/shutdown handlers.

Синхронные и async зависимости выбираются по характеру I/O. Отдельная папка services/repositories допустима при собственной ответственности, но FastAPI ее не требует. В OpenAPI проверяются все реально включенные routers и модели, а не только импорты.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| GET /health в созданном приложении | 200 и объект {"status":"ok"} по response model | TestClient/HTTP |
| Router забыли include_router | Проверка OpenAPI/маршрута выявляет отсутствие endpoint | Негативная конфигурационная проверка |
| Dependency заменена в тесте | Использован контролируемый ресурс, production-соединение не открыто | dependency_overrides и счетчик |
| Startup/shutdown, в том числе при ошибке | Ресурс закрыт, импорт модуля не делает I/O | TestClient как context manager и lifecycle log |

Модульный импорт и AST-проверка подтверждают синтаксис, но не исполнение lifespan или HTTP-маршрута.

## Человек

Утверждает схему API, область жизни ресурсов и границы роутеров.

## Агент

Показывает include_router и контракт моделей, проверяет startup/shutdown и подмену зависимостей.

## Источники

- [FastAPI: bigger applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/)
- [FastAPI: lifespan events](https://fastapi.tiangolo.com/advanced/events/)
- [FastAPI: response model](https://fastapi.tiangolo.com/tutorial/response-model/)
