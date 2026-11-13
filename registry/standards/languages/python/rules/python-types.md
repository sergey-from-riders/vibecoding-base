---
schema_version: 1
id: "languages.python-types"
title: "Python: аннотации и runtime-валидация"
section: "languages"
level: "recommended"
tags: ["python", "types", "basics"]
technologies: ["Python"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1013
related: ["languages.python-naming", "backend.typed-boundaries"]
sources: ["https://docs.python.org/3.14/library/typing.html"]
---

# Python: аннотации и runtime-валидация

## Коротко

Аннотируйте устойчивые границы функций и проверяйте их выбранным type checker. Недоверенный ввод валидируется в runtime: аннотация int не проверяет значение сама.

## Плохо

```python
def require_quantity(value: int) -> int:
    return value

require_quantity("many")  # Runtime принимает строку несмотря на аннотацию.
```

## Хорошо

```python
def require_quantity(value: object) -> int:
    if not isinstance(value, int) or isinstance(value, bool):
        raise TypeError("quantity must be an integer")
    if value < 1:
        raise ValueError("quantity must be positive")
    return value
```

## Почему

Python не обеспечивает function/variable annotations при вызове. object требует уточнить тип до использования; Any отключает значимую часть статической проверки. Даже int может содержать отрицательное число, а bool является подтипом int, что важно для строгого числового API.

## Когда применять

Для нового Python-кода с общими/public/domain functions, DTO и взаимодействием модулей. Явно указывайте параметры и возвращаемое значение, включая -> None, когда результата нет. Локальные очевидные переменные можно оставлять на inference. Выбранный type checker, версия и строгость входят в профиль проекта; не утверждайте «типизировано» без реально выполняемой проверки.

None в допустимых значениях и отсутствие аргумента — разные вещи: int | None не задает default автоматически. Для коллекции укажите тип элементов, для известной структуры используйте dataclass/TypedDict/schema по задаче, а не неограниченный dict[str, Any]. TypedDict и cast не валидируют JSON в runtime. Динамические библиотеки могут требовать Any, stubs или Protocol: ограничьте такую границу и не распространяйте отключение проверки на весь модуль.

Синтаксис list[int] требует Python 3.9+, X | None — 3.10+, type Alias = ... — 3.12+; выбирайте совместимый с requires-python. Профиль внешнего DTO, coercion, unknown fields и missing/null раскрыт в backend.typed-boundaries. Пример специально принимает object и не преобразует строку/float/bool в количество.

## Как проверить

1. Целое 2 → require_quantity → возвращает int 2 → runtime unit scenario.

2. Строка, 2.0, True, None → require_quantity → TypeError; 0/-1 → ValueError → негативные runtime fixtures.

3. Внутренний consumer ожидает str, а получает результат int → выбранный type checker → ошибка до запуска; удаление optional default не скрыто аннотацией → static fixture.

## Человек

Задает границы типизации, строгость и политику преобразования внешних значений.

## Агент

Различает type checking и runtime validation, ограничивает Any и проверяет минимальную версию синтаксиса.

## Источники

- [Python typing: annotations не enforced runtime; Any/object, TypedDict, cast](https://docs.python.org/3.14/library/typing.html)
