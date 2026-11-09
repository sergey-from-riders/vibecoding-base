---
id: "security.secrets"
title: "Управление секретами"
section: "security"
level: "required"
tags: ["secrets"]
technologies: []
reviewed_at: "2026-11-09"
order: 71
related: ["security.object-access", "security.sql-injection"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html"]
schema_version: 1
---

# Управление секретами

## Коротко

Используйте управляемую конфигурацию и ограниченный доступ вместо ключей в репозитории.

## Плохо

```text
Рабочий пароль записан прямо в README.
```

## Хорошо

```text
README содержит пример без значения.
Секрет передаётся через защищённую конфигурацию.
```

## Почему

Удаление файла из последнего коммита не убирает секрет из истории.

## Когда применять

При утечке сначала отзовите или замените ключ. Очистка истории — отдельная согласованная операция.

## Как проверить

- Проверьте исходники, историю, логи и сборку на реальные секреты.

## Человек

Выдаёт и отзывает доступы, назначает владельцев ротации.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- Проверьте исходники, историю, логи и сборку на реальные секреты.

## Источники

- [Secrets Management - OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
