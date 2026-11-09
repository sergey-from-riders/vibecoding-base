---
id: "security.ssrf"
title: "Ограничивайте серверное открытие внешних URL"
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

# Ограничивайте серверное открытие внешних URL

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

## Источники

- [Первоисточник](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
