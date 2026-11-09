---
id: "operations.config"
title: "Конфигурация окружения"
section: "operations"
level: "required"
tags: ["config"]
technologies: []
reviewed_at: "2026-11-09"
order: 90
related: ["security.secrets", "operations.immutable-release"]
sources: ["https://12factor.net/config", "https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html"]
schema_version: 1
---

# Конфигурация окружения

## Коротко

Один модуль конфигурации должен проверять обязательные значения до приёма запросов.

## Плохо

```text
Нет ключа → приложение молча использует тестовый.
```

## Хорошо

```text
Отсутствует обязательная настройка →
понятная ошибка запуска без раскрытия секрета.
```

## Почему

Тихая подмена настройки создаёт труднообнаружимые ошибки и риск доступа.

## Когда применять

Для необязательной функции допустимо явное отключение. Секреты и окружения разделяются.

## Как проверить

- Проверьте запуск без ключа и с недопустимым значением.

## Человек

Определяет обязательные параметры и владельцев секретов.

## Агент

Готовит воспроизводимые команды, проверяет состояние сервисов и прикладывает фактический результат.

Контроль результата:

- Проверьте запуск без ключа и с недопустимым значением.

## Источники

- [The Twelve-Factor App](https://12factor.net/config)
- [Secrets Management - OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
