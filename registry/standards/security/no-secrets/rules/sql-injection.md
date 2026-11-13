---
id: "security.sql-injection"
title: "SQL-параметры"
section: "security"
level: "required"
tags: ["sql-injection"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 72
related: ["security.object-access", "database.constraints", "backend.typed-boundaries"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html", "https://www.psycopg.org/psycopg3/docs/basic/params.html", "https://www.psycopg.org/psycopg3/docs/api/sql.html"]
schema_version: 1
---

# SQL-параметры

## Коротко

Значения передавайте параметрами драйвера. Динамические identifiers и keywords выбирайте из фиксированной разрешенной карты; параметр значения не заменяет имя столбца.

## Плохо

```python
cur.execute(f"SELECT id FROM users WHERE name = '{name}' ORDER BY {sort_key}")
```

## Хорошо

```python
from psycopg import sql


def find_users(cur, name, sort_key):
    columns = {"name": "name", "id": "id"}
    if sort_key not in columns:
        raise ValueError("unsupported sort key")
    query = sql.SQL(
        "SELECT id, name FROM users WHERE name = %s ORDER BY {} ASC"
    ).format(sql.Identifier(columns[sort_key]))
    cur.execute(query, (name,))
    return cur.fetchall()
```

## Почему

Binding сохраняет ввод данными, даже если он содержит кавычки или SQL-подобную строку. Identifier quoting защищает синтаксис, но без allowlist разрешило бы выбирать непредусмотренный столбец. ORM и stored procedure не защищают автоматически, если внутри строят raw SQL конкатенацией.

## Когда применять

Для SQL-запросов к любым входным данным, включая полученные от другого сервиса и ранее сохраненные в БД. Пример — классический binding Psycopg 3.x; проверена официальная документация 3.3.9, не dev-ветка. В %s нет кавычек; tuple из одного значения имеет запятую. Это маркер драйвера, а не оператор форматирования Python. Синтаксис placeholder других драйверов может отличаться.

Имена таблиц/столбцов и ASC/DESC выбирайте из фиксированных application-owned mappings, неизвестный выбор отклоняйте. Для значений сохраняйте binding и при динамической композиции. Не вставляйте список IN строковой конкатенацией; используйте поддержанный драйвером массив/число placeholders. Параметризация LIKE предотвращает SQL injection, но wildcard %/_ сохраняет смысл поиска; при требовании буквального поиска экранирование шаблона задается отдельно.

Не запрещайте апостроф в корректном имени ради SQL: O'Reilly должен сохраниться/найтись как данные. Авторизация строк и минимальные права DB-role применяются независимо: безопасный запрос тоже может вернуть чужую запись. Runtime-испытание требует той же версии драйвера и реальной тестовой БД, а не только проверки сформированной строки.

## Как проверить

1. Имя O'Reilly → parameterized insert/read → сохранено и найдено без синтаксической ошибки → значение в тестовой БД.

2. Строка с кавычкой, OR и SQL-комментарием как name → запрос → ищется буквальное значение, набор строк не расширяется → контролируемые fixtures.

3. sort_key=name/id либо произвольный SQL-текст → запрос → разрешенный Identifier сортирует, неизвестный выбор отклоняется до execute → обе ветви allowlist.

## Человек

Определяет допустимую структуру динамических запросов и права DB-role.

## Агент

Использует binding и driver composition, проверяет обычный апостроф и отдельную ветвь динамической сортировки.

## Источники

- [OWASP SQL Injection Prevention: binding, structural allowlist, least privilege](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [Psycopg 3.3.9: Passing parameters to SQL queries](https://www.psycopg.org/psycopg3/docs/basic/params.html)
- [Psycopg 3.3.9: sql composition и Identifier](https://www.psycopg.org/psycopg3/docs/api/sql.html)
