---
id: "security.object-access"
title: "Проверяйте право на конкретный объект"
section: "security"
level: "required"
tags: ["object-access"]
technologies: []
reviewed_at: "2026-11-09"
order: 70
related: ["security.secrets", "security.sql-injection"]
sources: ["https://owasp.org/API-Security/editions/2023/en/0x11-t10/"]
schema_version: 1
---

# Проверяйте право на конкретный объект

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

## Источники

- [Первоисточник](https://owasp.org/API-Security/editions/2023/en/0x11-t10/)
