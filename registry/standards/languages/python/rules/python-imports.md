---
schema_version: 1
id: "languages.python-imports"
title: "Python: явные imports и управляемая инициализация"
section: "languages"
level: "recommended"
tags: ["python", "imports", "basics"]
technologies: ["Python"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1012
related: ["languages.python-naming", "languages.python-toolchain", "backend.readable-code"]
sources: ["https://peps.python.org/pep-0008/", "https://docs.python.org/3.14/reference/import.html"]
---

# Python: явные imports и управляемая инициализация

## Коротко

Imports явно показывают происхождение имен. Группируйте stdlib, third-party и проектные пакеты; импорт модуля не должен сам выполнять бизнес-операцию.

## Плохо

```python
from json import *
import pathlib, os

result = loads(pathlib.Path("orders.json").read_text())
# Чтение файла запускается при любом import этого модуля.
```

## Хорошо

```python
import json
from pathlib import Path


def read_json(path: Path) -> object:
    return json.loads(path.read_text(encoding="utf-8"))
```

## Почему

Wildcard скрывает источник имени и может незаметно изменить namespace. Python выполняет код модуля при загрузке; тяжелая инициализация, сеть или чтение обязательного файла на уровне модуля мешают тестам, CLI и повторному использованию. Явная функция отделяет импорт от запуска операции.

## Когда применять

Для библиотек и приложений Python. Обычные imports находятся после docstring и допустимых __future__ declarations, до констант/кода; группы разделяются пустой строкой. import os и import sys обычно отдельными строками, from module import A, B допустим. Absolute imports предпочтительны; явные relative imports внутри пакета разрешены, если сохраняют ясность.

Не используйте from module import * в обычном коде. Узкое исключение — намеренный re-export публичного API с контролем __all__; это не разрешение скрывать произвольные зависимости. Отложенный import внутри функции допустим для optional dependency, цикла, измеримого startup cost; причина и поведение при отсутствии зависимости должны быть понятны. Не исправляйте packaging ручным добавлением случайных путей в sys.path.

TYPE_CHECKING imports не существуют в runtime: учитывайте introspection framework и версию механизма annotations. Модуль и тесты запускаются в установленном package/предусмотренном entry point, а не только благодаря текущей рабочей директории. Пример читает JSON при вызове и возвращает object; валидация структуры выполняется отдельно.

## Как проверить

1. Импорт example module при отсутствующем orders.json → import → успешно без чтения файла/сети → isolated import test.

2. Явный вызов read_json с корректным UTF-8 JSON → операция → разобранное значение → fixture.

3. Optional dependency отсутствует или package запускается из другой cwd → предусмотренный путь → понятный отказ/неактивная функция без sys.path workaround → packaging test.

## Человек

Определяет публичные re-exports и допустимую initialization policy.

## Агент

Проверяет зависимости и import-time эффекты; не скрывает cycle случайным изменением sys.path.

## Источники

- [PEP 8: Imports и public interfaces](https://peps.python.org/pep-0008/)
- [Python 3.14 Reference, §5: module loading и execution](https://docs.python.org/3.14/reference/import.html)
