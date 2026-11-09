---
id: "security.sql-injection"
title: "SQL-параметры"
section: "security"
level: "required"
tags: ["sql-injection"]
technologies: []
reviewed_at: "2026-11-09"
order: 72
related: ["security.object-access", "security.secrets"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html", "https://www.psycopg.org/psycopg3/docs/basic/params.html"]
schema_version: 1
---

# SQL-параметры

## Коротко

Не вставляйте пользовательскую строку непосредственно в SQL.

## Плохо

```python
cursor.execute("SELECT * FROM users WHERE name = '" + name + "'")
```

## Хорошо

```python
cursor.execute("SELECT * FROM users WHERE name = %s", (name,))
```

## Почему

Пользовательский ввод не должен менять структуру команды.

## Когда применять

Пример для Python и Psycopg 3: `%s` — placeholder драйвера, а не строковая подстановка Python. Значения передаются отдельным аргументом. Для имён колонок и направления сортировки используйте разрешённый список; bind-параметры не заменяют SQL-идентификаторы.

## Как проверить

- Попробуйте кавычки и SQL-фрагмент во входном значении.

## Человек

Определяет доступные операции и минимальные права подключения к БД.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- Попробуйте кавычки и SQL-фрагмент во входном значении.

## Источники

- [SQL Injection Prevention - OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [Passing parameters to SQL queries - psycopg 3.3.9.dev1 documentation](https://www.psycopg.org/psycopg3/docs/basic/params.html)
