---
id: "api.http-status"
title: "Сообщайте об ошибке HTTP-статусом"
section: "api"
level: "required"
tags: ["http-status", "HTTP"]
technologies: ["HTTP"]
reviewed_at: "2026-11-09"
order: 29
related: ["api.methods", "api.error-details"]
sources: ["https://www.rfc-editor.org/rfc/rfc9457.html"]
schema_version: 1
---

# Сообщайте об ошибке HTTP-статусом

## Коротко

Клиент, прокси и мониторинг должны видеть результат запроса без разбора произвольного JSON.

## Плохо

```http
HTTP/1.1 200 OK
Content-Type: application/json

{"status": 404, "message": "Не найдено"}
```

## Хорошо

```http
HTTP/1.1 404 Not Found
Content-Type: application/problem+json

{"type":"about:blank","title":"Не найдено","status":404}
```

## Почему

Если ошибка замаскирована успешным кодом, инфраструктура может обработать её как успех.

## Когда применять

Для HTTP API. Поле status в Problem Details допустимо, но совпадает с реальным HTTP-кодом. Статус заказа — отдельное бизнес-поле.

## Как проверить

- Проверьте HTTP-код отсутствующего ресурса и ошибки доступа.

## Источники

- [Первоисточник](https://www.rfc-editor.org/rfc/rfc9457.html)
