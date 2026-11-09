---
id: "security.ssrf"
title: "SSRF-защита"
section: "security"
level: "required"
tags: ["ssrf"]
technologies: []
reviewed_at: "2026-11-09"
order: 73
related: ["security.object-access", "security.secrets"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html"]
schema_version: 1
---

# SSRF-защита

## Коротко

Проверяйте адрес назначения, перенаправления, DNS и объём ответа.

## Плохо

```text
Сервер скачивает любой URL из формы.
```

## Хорошо

```text
Разрешённые HTTPS-источники.
Запрет внутренних адресов и опасных редиректов.
```

## Почему

Пользователь может попытаться обратиться через ваш сервер к внутренним сервисам.

## Когда применять

Проверка строкового префикса недостаточна. Учитывайте IPv6, DNS rebinding и адрес после каждого перенаправления.

## Как проверить

- Проверьте loopback, частные адреса и редирект на них.

## Человек

Определяет разрешённые внешние адреса и сетевые границы.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- Проверьте loopback, частные адреса и редирект на них.

## Источники

- [Server Side Request Forgery Prevention - OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
