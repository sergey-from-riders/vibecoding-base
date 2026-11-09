---
id: "security.sql-injection"
title: "Передавайте SQL-параметры отдельно от текста запроса"
section: "security"
level: "required"
tags: ["sql-injection"]
technologies: []
reviewed_at: "2026-11-09"
order: 72
related: ["security.object-access", "security.secrets"]
sources: ["https://owasp.org/API-Security/editions/2023/en/0x11-t10/"]
schema_version: 1
---

# Передавайте SQL-параметры отдельно от текста запроса

## Коротко

Не вставляйте пользовательскую строку непосредственно в SQL.

## Плохо

```sql
query = "SELECT * FROM users WHERE name = '" + name + "'"
```

## Хорошо

```sql
query = "SELECT * FROM users WHERE name = $1"
args = [name]
```

## Почему

Пользовательский ввод не должен менять структуру команды.

## Когда применять

Для имён колонок и направления сортировки используйте разрешённый список; bind-параметры не заменяют SQL-идентификаторы.

## Как проверить

- Попробуйте кавычки и SQL-фрагмент во входном значении.

## Источники

- [Первоисточник](https://owasp.org/API-Security/editions/2023/en/0x11-t10/)
