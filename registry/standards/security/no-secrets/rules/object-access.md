---
id: "security.object-access"
title: "Object-level authorization"
section: "security"
level: "required"
tags: ["object-access"]
technologies: []
reviewed_at: "2026-11-09"
order: 70
related: ["security.secrets", "security.sql-injection"]
sources: ["https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/"]
schema_version: 1
---

# Object-level authorization

## Коротко

Вход в систему не даёт доступа ко всем записям.

## Плохо

```sql
SELECT * FROM orders WHERE order_id = $1
```

## Хорошо

```sql
SELECT * FROM orders
WHERE order_id = $1 AND tenant_id = $2
```

## Почему

Чужой идентификатор может быть известен или случайно раскрыт.

## Когда применять

tenant_id берётся из проверенного контекста, а не произвольного поля клиента. Для сложных ролей нужен явный механизм политик.

## Как проверить

- Пользователь одной организации не читает и не меняет данные другой?

## Человек

Определяет матрицу доступа к конкретным объектам.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- Пользователь одной организации не читает и не меняет данные другой?

## Источники

- [API1:2023 Broken Object Level Authorization - OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/)
