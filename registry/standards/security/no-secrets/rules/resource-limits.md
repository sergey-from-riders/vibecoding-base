---
id: "security.resource-limits"
title: "Лимиты ресурсов"
section: "security"
level: "required"
tags: ["resource-limits"]
technologies: []
reviewed_at: "2026-11-09"
order: 76
related: ["api.pagination", "integrations.files"]
sources: ["https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/"]
schema_version: 1
---

# Лимиты ресурсов

## Коротко

У запросов должны быть пределы размера, частоты и сложности.

## Плохо

```text
Неограниченный upload и тысячи попыток входа.
```

## Хорошо

```text
Лимит файла, квота пользователя, предел времени
и ограничение частоты чувствительных операций.
```

## Почему

Даже корректный запрос может исчерпать ресурсы сервиса.

## Когда применять

Лимиты выбираются под продукт и учитывают общие ресурсы; один IP не всегда равен одному пользователю.

## Как проверить

- Проверьте большой ввод, параллельные запросы и восстановление после лимита.

## Человек

Задаёт квоты, приоритеты и поведение при превышении.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- Проверьте большой ввод, параллельные запросы и восстановление после лимита.

## Источники

- [API4:2023 Unrestricted Resource Consumption - OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/)
