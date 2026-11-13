---
schema_version: 1
id: "languages.python-naming"
title: "Python: имена классов, функций и констант"
section: "languages"
level: "recommended"
tags: ["python", "naming", "basics"]
technologies: ["Python"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1011
related: ["languages.python-imports", "backend.readable-code"]
sources: ["https://peps.python.org/pep-0008/"]
---

# Python: имена классов, функций и констант

## Коротко

Используйте PascalCase для классов, snake_case для функций, методов, переменных и модулей, UPPER_SNAKE_CASE для констант модуля. Исключения совместимости должны быть явными.

## Плохо

```python
# ReportBuilder.py
maxRows = 100

class report_builder:
    def BuildReport(self, UserId):
        return f"report:{UserId}"
```

## Хорошо

```python
# report_builder.py
MAX_ROWS = 100


class ReportBuilder:
    def build_report(self, user_id: int) -> str:
        return f"report:{user_id}"
```

## Почему

Последовательный регистр сообщает роль имени без дополнительного соглашения на каждый модуль. Python не делает UPPER_SNAKE_CASE неизменяемым и не делает _name защищенным от доступа: это соглашения публичного интерфейса, а не security controls.

## Когда применять

Для нового рукописного Python-кода; PascalCase соответствует CapWords в PEP 8. Module file называется report_builder.py, пакет — коротким lowercase именем; слова в модуле разделяются underscore, когда это нужно. Для метода экземпляра первый параметр self, для classmethod — cls. Ошибки-классы имеют содержательное имя с Error, если обозначают ошибку.

Непубличные имена начинаются с одного underscore. Double underscore применяйте только для предотвращения коллизий наследования, не для «защиты секрета»; не изобретайте новые dunder names. Избегайте имен list/str/id, когда они скрывают нужный builtin; для keyword используйте ясный синоним или class_. Не превращайте все значения в константы: MAX_ROWS — соглашение для стабильного параметра модуля.

Generated code, внешние payload keys и обязательные framework callbacks сохраняют контракт. Уже опубликованный mixedCase API не переименовывается с поломкой клиентов только ради PEP 8: нужен адаптер/deprecation. Formatter обычно не переименовывает символы; naming проверяется отдельно выбранным linter/review.

## Как проверить

1. Новый модуль с классом/методом/константой → review/import → имена соответствуют ролям и модуль импортируется → AST/linter.

2. Класс вызван через прежнее публичное имя → план rename → потребитель сохранен адаптером либо изменение объявлено breaking → consumer test.

3. _internal и MAX_ROWS → проверка документации → не заявлены как запрет доступа или runtime immutability → review контракта.

## Человек

Утверждает публичные имена и исключения для совместимости.

## Агент

Применяет профиль PEP 8, сохраняет внешние имена и проверяет builtin shadowing.

## Источники

- [PEP 8: Naming Conventions, Class/Function/Variable/Module names, Constants](https://peps.python.org/pep-0008/)
