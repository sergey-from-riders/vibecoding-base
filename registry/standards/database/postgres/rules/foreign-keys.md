---
id: "database.foreign-keys"
title: "Внешние ключи"
section: "database"
level: "recommended"
tags: ["foreign-keys", "SQL"]
technologies: ["SQL"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 22
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl-constraints.html"]
schema_version: 1
---

# Внешние ключи

## Коротко

Если связь хранится в одной реляционной БД и обязана всегда существовать, закрепите ее внешним ключом. Явно определите допустимость NULL и действие при удалении родителя.

## Плохо

```sql
CREATE TABLE orders (order_id uuid PRIMARY KEY, tenant_id uuid, user_id uuid);
-- user_id может ссылаться на отсутствующего или чужого tenant пользователя.
```

## Хорошо

```sql
CREATE TABLE users (
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  PRIMARY KEY (tenant_id, user_id)
);
CREATE TABLE orders (
  order_id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  FOREIGN KEY (tenant_id, user_id)
    REFERENCES users (tenant_id, user_id) ON DELETE RESTRICT
);
```

## Почему

Составной FK в примере обеспечивает принадлежность ссылки тому же tenant; отдельные FK на tenant и user этого не доказывают. Он не проверяет разрешение текущего пользователя на операцию. Индекс на ссылающихся колонках PostgreSQL автоматически не создает: решение зависит от удаления/обновления родителей и запросов.

## Когда применять

Для PostgreSQL 18 и обычных реляционных связей. NOT NULL означает обязательную связь. Для optional-связи задайте семантику NULL; у составного FK проверьте MATCH SIMPLE/FULL, чтобы частичный NULL не обходил нужную проверку. CASCADE применяйте только к данным, которые должны удаляться вместе с владельцем. RESTRICT запрещает удаление при существующей ссылке; NO ACTION отличается возможностью отложенной проверки, если ограничение допускает ее.

При разных БД FK недоступен: документируйте владельца, проверку существования, обнаружение осиротевших ссылок и восстановление; не изображайте предварительный API-вызов эквивалентом FK.

## Как проверить

1. Родитель существует в tenant A → вставка связанного заказа A → успех → FK и строки обеих таблиц.

2. Несуществующий user_id или пользователь tenant B → вставка заказа A → 23503 и нет заказа → SQLSTATE и выборка.

3. Родитель с заказом → DELETE → RESTRICT отклоняет; optional-связь с согласованным NULL → допустима → результаты транзакций и выбранная delete-политика.

## Человек

Выбирает обязательность связи, владение данными и допустимое удаление.

## Агент

Проверяет состав ключа, nullable-колонки и delete-действие; оценивает индекс по запросам, не добавляет его механически.

## Источники

- [PostgreSQL 18, §5.5.5: FK, MATCH, ON DELETE и индексы](https://www.postgresql.org/docs/18/ddl-constraints.html)
