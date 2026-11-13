---
id: "backend.typed-boundaries"
title: "Валидация типов"
section: "backend"
level: "required"
tags: ["typed-boundaries", "Python", "FastAPI"]
technologies: ["Python", "FastAPI"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 43
related: ["api.error-details", "security.object-access", "api.compatibility"]
sources: ["https://docs.pydantic.dev/latest/concepts/models/", "https://docs.pydantic.dev/latest/concepts/strict_mode/", "https://fastapi.tiangolo.com/tutorial/handling-errors/"]
schema_version: 1
---

# Валидация типов

## Коротко

Проверяйте недоверенный ввод до бизнес-эффекта. Статические аннотации Python не заменяют runtime-валидацию, а валидная структура не заменяет авторизацию.

## Плохо

```python
def read_quantity(payload: dict) -> int:
    return payload["quantity"]  # Аннотация не проверяет JSON.
```

## Хорошо

```python
from pydantic import BaseModel, ConfigDict, Field

class CreateOrder(BaseModel):
    model_config = ConfigDict(extra="forbid")
    quantity: int = Field(strict=True, ge=1, le=10_000)

request = CreateOrder.model_validate({"quantity": 2})
```

## Почему

Пример для Pydantic v2: quantity обязателен, null запрещен, bool/строка/float не становятся int благодаря strict=True; 1..10000 — выбранный диапазон примера. Неизвестные поля запрещены как политика этого DTO. Другая coercion/extra-политика допустима при документированном контракте и приемке.

## Когда применять

На HTTP, очередях, импорте и ответах внешних сервисов в Python. Зафиксируйте версии Pydantic/FastAPI и семантику missing/null/default по каждому нужному полю. Pydantic может преобразовывать типы; строгий режим имеет различия между JSON и Python-вводом для некоторых типов, поэтому тестируйте реальный путь model_validate/model_validate_json.

В FastAPI неверный request вызывает RequestValidationError; базовый формат detail не является автоматически RFC 9457. Если принят api.error-details, адаптер преобразует ошибки в согласованный problem media type и extension, исключая raw input/секреты. Ошибка response-модели или внутренний ValidationError не должна выглядеть как вина клиента. После валидации отдельно проверяйте субъект, действие, объект и бизнес-лимит до charge. Любое изменение coercion/required/extra у опубликованного API проверяется на совместимость.

## Как проверить

1. quantity = 2 через реальный JSON-path → модель → int 2 и разрешенная операция после авторизации → результат модели и вызов бизнес-функции.

2. Отсутствие, null, true, "2", 2.0, 0, 10001 или extra → валидация профиля → отказ до charge → список ошибок без входных секретов и ноль эффектов.

3. quantity корректен, но чужой объект; либо ошибка внутренней response-модели → запрос → отказ доступа/серверная ошибка по разным контрактам → HTTP и отсутствие побочного эффекта.

## Человек

Выбирает допустимые значения, coercion/extra-политику и внешний формат ошибок.

## Агент

Строит DTO на фиксированной версии, проверяет missing/null/bool и оба пути ввода; не смешивает validation и authorization.

## Источники

- [Pydantic v2 Models: required, extra и model_validate](https://docs.pydantic.dev/latest/concepts/models/)
- [Pydantic v2 Strict Mode: Field(strict=True), Python/JSON](https://docs.pydantic.dev/latest/concepts/strict_mode/)
- [FastAPI Handling Errors: RequestValidationError и exception handlers](https://fastapi.tiangolo.com/tutorial/handling-errors/)
