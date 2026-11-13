---
id: "security.redaction"
title: "Маскирование секретов в логах"
section: "security"
level: "required"
tags: ["redaction"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 74
related: ["security.secrets", "payments.card-data", "operations.correlation"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html"]
schema_version: 1
---

# Маскирование секретов в логах

## Коротко

Перед отправкой диагностических данных исключайте секреты и лишние персональные поля. Правило распространяется на все каналы сбора, а не только application log.

## Плохо

```text
logger.error("request failed", request.body, request.headers, error);
proxy_access_log: полный URL с access_token;
error_tracker: exception.message с connection string.
```

## Хорошо

```text
event = payment_failed
request_id = безопасный идентификатор корреляции
provider_error_code = allowlist кода ошибки
operation_id = внутренний идентификатор без секрета
Нет raw body, Authorization, Cookie, query и полного exception object.
```

## Почему

Redaction после отправки не удаляет уже созданную копию у коллектора. Секрет может оказаться в nested JSON, URL, SQL/connection error, baggage/span attribute или replay. Структурированный формат сохраняет полезное событие без полного недоверенного объекта; проверка размера и кодирование отдельно защищают от log injection и расхода ресурсов.

## Когда применять

Для логов приложения, reverse proxy/CDN, traces, error tracking, analytics, session replay, debug dumps и экспортов поддержки. По умолчанию задайте allowlist разрешенных имен/типов полей; credentials, cookies, Authorization, client_secret, подписанные URL и чувствительные данные исключайте до экспорта. Если нужен корреляционный идентификатор, создайте отдельный безопасный ID; частичная маска настоящего секрета не универсально безопасна.

Обработчик должен учитывать вложенные структуры/массивы, регистр и алиасы полей, URL query и exception chains. Raw request/response capture выключен на чувствительных маршрутах; локальный debug не оправдывает запись реальных токенов. Проверьте соседние SDK/агенты и proxy, которые получают данные до приложения.

Форматируйте через структурированный serializer, экранируйте CR/LF/разделители согласно приемнику, ограничьте длину строк, число полей и размер события. Malformed поле заменяется безопасным маркером, полезное security-событие сохраняется. Доступ, срок хранения и удаление записей ограничиваются отдельно; redaction не заменяет эти меры. Ошибка redactor не должна включать fallback с полным payload.

## Как проверить

1. Обычная ошибка платежа → журналирование → event/request_id/error_code позволяют связать событие без body → проверка структуры.

2. Синтетические секреты во вложенном поле, URL и chained exception → все каналы → ни исходное значение, ни опасная часть не экспортированы → поиск canary в каждом приемнике.

3. Поле с CR/LF и очень длинной строкой → запись → одно корректное ограниченное событие, без поддельной строки и raw fallback → размер и parser output.

## Человек

Утверждает минимальные диагностические поля, владельцев приемников, сроки хранения и допустимую корреляцию.

## Агент

Проверяет redaction до каждого экспортера и отрицательные сценарии nested/query/exception/log injection.

## Источники

- [OWASP Logging: Data to exclude, Event collection, Verification](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)
