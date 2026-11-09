---
schema_version: 1
id: "frameworks.bitrix24-webhook"
title: "Bitrix24: серверный вебхук"
section: "frameworks"
level: "required"
tags: ["bitrix24-webhook", "Bitrix24"]
technologies: ["Bitrix24"]
reviewed_at: "2026-11-09"
order: 108
related: ["security.secrets", "api.idempotency"]
sources: ["https://apidocs.bitrix24.ru/local-integrations/local-webhooks.html"]
---

# Bitrix24: серверный вебхук

## Коротко

URL входящего вебхука содержит секрет доступа. Вызывайте Bitrix24 со своего сервера.

## Плохо

```text
Браузер → https://portal.bitrix24.ru/rest/1/SECRET/crm.lead.add
```

## Хорошо

```text
Браузер → POST /api/leads
Сервер → Bitrix24 REST API
Секрет → серверная конфигурация
```

## Почему

Секрет из клиентского JavaScript доступен посетителю. Ограничения формы не ограничивают прямой вызов API.

## Когда применять

Bitrix24 REST, локальная интеграция через входящий вебхук. Для устанавливаемого приложения используйте подходящий OAuth-поток. Не публикуйте URL в логах и примерах.

## Человек

Выбирает портал, владельца интеграции и минимальные права вебхука.

## Агент

Хранит секрет на сервере, валидирует заявку и проверяет отказ Bitrix24.

## Пример применения

Форма заявки отправляет только имя и контакт в свой backend. Backend создаёт лид и сохраняет соответствие локального request_id и CRM ID для защиты от дублей.

## Как проверить

- В клиентской сборке и логах нет секрета.
- Свой API проверяет ввод, лимиты и право операции.

## Источники

- [Входящие и исходящие вебхуки](https://apidocs.bitrix24.ru/local-integrations/local-webhooks.html)
