---
id: "database.naming"
title: "Имена таблиц и полей"
section: "database"
level: "recommended"
tags: ["naming", "SQL"]
technologies: ["SQL"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 20
related: ["database.identifiers", "database.constraints"]
sources: ["https://www.postgresql.org/docs/18/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS"]
schema_version: 1
---

# Имена таблиц и полей

## Коротко

Для новой схемы этого профиля используйте unquoted lower_snake_case и согласованный словарь предметной области. Имя показывает сущность, роль связи или единицу значения.

## Плохо

```sql
CREATE TABLE "UserSessions" (
  "ID" uuid, ref uuid, t bigint, flag boolean
);
```

## Хорошо

```sql
CREATE TABLE user_sessions (
  session_id uuid PRIMARY KEY,
  owner_user_id uuid NOT NULL,
  expires_at timestamptz NOT NULL,
  is_revoked boolean NOT NULL DEFAULT false
); -- owner_user_id получает FK по правилу database.foreign-keys
```

## Почему

PascalCase в SQL не обязателен и часто приводит к зависимости от кавычек: PostgreSQL приводит unquoted-имена к нижнему регистру, quoted-имена чувствительны к регистру. По умолчанию имя ограничено 63 байтами; длинные автоматически сгенерированные имена могут усекаться. lower_snake_case и entity_id здесь — соглашение профиля, а не требование SQL.

## Когда применять

Для новых таблиц/полей PostgreSQL. Таблицы в примере во множественном числе; последовательный иной стиль существующего проекта допустим. PK — session_id, FK — имя сущности с ролью, если связей несколько: owner_user_id, reviewer_user_id. Суффикс _at означает момент, _date — календарную дату, _minor/_seconds — явно выбранную единицу; is_/has_ — логический признак. Не закодируйте единицу в имени и не храните другое значение.

Не используйте ref/data/flag без понятного предметного контекста; избегайте зарезервированных слов и названий, требующих постоянных кавычек. Имена constraints/indexes должны различаться и оставаться в лимите. Допустимое id в старом согласованном стиле не является дефектом: переименование БД/API требует отдельной миграции, а не механического форматирования.

## Как проверить

1. Новая схема → ревью по словарю → роль обеих user-ссылок и единицы понятны → DDL и словарь имен.

2. Имя длиннее лимита или различается лишь quoted-регистром → миграция на копии → коллизия/ошибка обнаружена до выпуска → фактический каталог имен.

3. Существующая схема с id и совместимым ORM → добавление поля → стиль сохранен, клиентов не ломает массовое переименование → diff схемы и запросов.

## Человек

Фиксирует словарь сущностей, единицы и стиль существующей схемы.

## Агент

Проверяет новые имена, роли FK, зарезервированные слова и длину в байтах; переименование отделяет от нового DDL.

## Источники

- [PostgreSQL 18, §4.1.1: unquoted/quoted identifiers и предел имени](https://www.postgresql.org/docs/18/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS)
