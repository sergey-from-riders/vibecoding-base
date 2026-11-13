---
schema_version: 1
id: "languages.python-toolchain"
title: "Python: интерпретатор, окружение и зависимости"
section: "languages"
level: "recommended"
tags: ["python", "toolchain", "dependencies", "basics"]
technologies: ["Python"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1014
related: ["languages.python-imports", "languages.python-types", "security.supply-chain"]
sources: ["https://docs.python.org/3.14/library/venv.html", "https://packaging.python.org/en/latest/guides/writing-pyproject-toml/", "https://pip.pypa.io/en/stable/topics/repeatable-installs/", "https://pip.pypa.io/en/stable/cli/pip_check/"]
---

# Python: интерпретатор, окружение и зависимости

## Коротко

Проект объявляет поддерживаемый Python и способ восстановить зависимости в чистом окружении. Установка в случайный системный interpreter не является воспроизводимым запуском.

## Плохо

```bash
sudo pip install package
pip install --upgrade все-зависимости перед каждым release
Скопировать .venv с другого компьютера и не проверять версию Python.
```

## Хорошо

```bash
# Пример POSIX-профиля pip: выбранный Python уже установлен.
python -m venv .venv
.venv/bin/python -m pip install --require-hashes -r requirements.lock
.venv/bin/python -m pip check
# requirements.lock заранее содержит pins и hashes всех зависимостей.
```

## Почему

venv изолирует Python packages от базового окружения, но не фиксирует автоматически сам interpreter и системные библиотеки. requires-python описывает совместимость установки, а не точный patch/runtime image. Lock/resolution приложения и диапазоны зависимостей публикуемой библиотеки решают разные задачи.

## Когда применять

Для Python приложений и пакетов. Зафиксируйте поддерживаемый диапазон в pyproject.toml через requires-python, когда используется project metadata; точную CI/deploy версию и платформу храните в конфигурации окружения. Тестируйте заявленные версии, а не ставьте диапазон шире проверенного. Build backend, formatter, linter/type checker также имеют контролируемые версии.

Выберите один поддержанный workflow — pip с pin/hash requirements либо менеджер с документированным lock/sync. В pip-примере файл заранее сформирован для нужной платформы, включает транзитивные зависимости и hashes; обычный pip freeze без hashes не равен ему. Library metadata задает допустимые диапазоны, а тестовая/release среда фиксируется отдельно. pip check проверяет совместимость установленных dependency requirements, не безопасность и не поведение приложения.

.venv не коммитится и не переносится как release artifact: окружение пересоздается; на Windows используется соответствующий Scripts/python.exe. Установка выполняется через interpreter -m pip, чтобы не перепутать pip другой среды. Нативные extensions и внешние libraries требуют учета OS/architecture/toolchain. Обновление зависимостей проводится отдельным review и проверкой, а не незаметно при каждом запуске.

## Как проверить

1. Чистое окружение выбранной версии/платформы → sync/install → ожидаемые pins и успешный pip check → interpreter/package inventory.

2. Неверный hash/отсутствующий pin в hash-mode или несовместимый Python → установка → явный отказ → stderr без fallback на latest.

3. Заявлены несколько Python версий либо native extension → CI matrix → проверены поддерживаемые сочетания; неподдерживаемое исключено явно → результаты матрицы.

## Человек

Выбирает поддерживаемую матрицу и workflow обновления/восстановления среды.

## Агент

Проверяет interpreter и metadata, использует чистое окружение и не приравнивает pip check к тестам приложения.

## Источники

- [Python venv: изоляция, пересоздание, непереносимость окружения](https://docs.python.org/3.14/library/venv.html)
- [PyPA Writing pyproject.toml: requires-python и build metadata](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)
- [pip Repeatable installs: pins, transitive requirements, hash checking](https://pip.pypa.io/en/stable/topics/repeatable-installs/)
- [pip check: совместимость установленных зависимостей и коды выхода](https://pip.pypa.io/en/stable/cli/pip_check/)
