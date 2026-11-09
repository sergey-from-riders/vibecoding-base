---
id: "backend.typed-boundaries"
title: "Валидация типов"
section: "backend"
level: "required"
tags: ["typed-boundaries", "Python", "FastAPI"]
technologies: ["Python", "FastAPI"]
reviewed_at: "2026-11-09"
order: 43
related: ["backend.boundaries", "backend.go-context"]
sources: ["https://docs.pydantic.dev/latest/concepts/models/", "https://fastapi.tiangolo.com/tutorial/body/"]
schema_version: 1
---

# Валидация типов

## Коротко

Типы помогают разработчику, а проверка входа защищает работающую систему.

## Плохо

```text
quantity = payload["quantity"]
charge(quantity * price)
```

## Хорошо

```text
quantity = validated_request.quantity
# Целое число в разрешённом диапазоне.
```

## Почему

Аннотация типа сама по себе не проверяет входящий JSON.

## Когда применять

Для Python/FastAPI подходят модели Pydantic; конкретная версия фиксируется зависимостями проекта.

## Как проверить

- Проверьте строку, отрицательное число и слишком большое значение.

## Человек

Определяет допустимые значения и поведение при неверном вводе.

## Агент

Реализует правило в коде сервиса и проверяет ошибку, отмену и граничные входные данные.

Контроль результата:

- Проверьте строку, отрицательное число и слишком большое значение.

## Источники

- [Models](https://docs.pydantic.dev/latest/concepts/models/)
- [Request Body - FastAPI](https://fastapi.tiangolo.com/tutorial/body/)
