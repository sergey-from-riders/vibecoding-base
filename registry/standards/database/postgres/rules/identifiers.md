---
id: "database.identifiers"
title: "Идентификаторы: UUID и bigint"
section: "database"
level: "contextual"
tags: ["identifiers", "PostgreSQL", "SQL"]
technologies: ["PostgreSQL", "SQL"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 19
related: ["database.naming", "database.constraints"]
sources: ["https://www.postgresql.org/docs/18/functions-uuid.html", "https://tc39.es/ecma262/multipage/numbers-and-dates.html#sec-number.max_safe_integer"]
schema_version: 1
---

# Идентификаторы: UUID и bigint

## Коротко

Выбирайте идентификатор по месту генерации, диапазону и внешнему контракту. UUID и bigint допустимы при согласованной схеме выдачи; ни один из них не заменяет авторизацию.

## Плохо

```sql
CREATE TABLE orders (order_id bigint PRIMARY KEY);
-- Два независимых генератора без разделения диапазонов выдали 42.
```

## Хорошо

```sql
CREATE TABLE orders (
  order_id uuid PRIMARY KEY DEFAULT uuidv7()
);
-- PostgreSQL 18; PRIMARY KEY остается проверкой уникальности.
```

## Почему

Проблема плохого примера — несогласованные генераторы, а не bigint. Для одной БД корректен bigint GENERATED ... AS IDENTITY вместе с PK. UUID позволяет независимую генерацию с очень малой вероятностью коллизии, но ограничение уникальности все равно необходимо. UUIDv7 содержит временную составляющую, не служит секретом и не гарантирует абсолютный порядок событий разных узлов.

## Когда применять

В PostgreSQL 18 есть uuidv7(); при более ранней поддерживаемой версии выберите доступный генератор, например gen_random_uuid() для v4, и проверьте версию сервера. Внешние UUID передавайте строкой и валидируйте; для bigint за пределами безопасного Number у JavaScript согласуйте десятичную строку без промежуточного float.

Смена типа опубликованного ID затрагивает FK, индексы, API, ссылки и SDK: мигрируйте через явное соответствие старого и нового ID, не пересоздавайте личности объектов. Доступ к найденному объекту проверяется независимо от формы ID. Временная информация UUIDv7 может быть нежелательной для конкретного публичного контракта.

## Как проверить

1. Выбранный генератор и точная версия сервера → создание записи → ID правильного типа и PK → schema introspection и строка.

2. Клиент знает чужой корректный UUID → чтение/запись → отказ по полномочиям → ответ и неизменный объект.

3. bigint больше 2^53−1 или миграция ID → round-trip API и FK → ни потери цифр, ни разрыва ссылок → сравнение строкового значения и контроль связей.

## Человек

Определяет независимость генераторов, публичность ID и допустимость раскрытия времени.

## Агент

Проверяет генератор на целевой версии, сериализацию и все ссылки; не объявляет UUID доказательством доступа.

## Источники

- [PostgreSQL 18, §9.14: UUIDv4/v7 и извлечение времени](https://www.postgresql.org/docs/18/functions-uuid.html)
- [ECMAScript, Number.MAX_SAFE_INTEGER: диапазон целых](https://tc39.es/ecma262/multipage/numbers-and-dates.html#sec-number.max_safe_integer)
