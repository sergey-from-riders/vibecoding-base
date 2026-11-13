---
id: "api.headers"
title: "HTTP-заголовки"
section: "api"
level: "recommended"
tags: ["headers", "HTTP"]
technologies: ["HTTP"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 37
related: ["api.http-status", "api.error-details", "caching.private-cache", "integrations.retries"]
sources: ["https://www.rfc-editor.org/rfc/rfc9110.html", "https://www.rfc-editor.org/rfc/rfc6585.html", "https://fetch.spec.whatwg.org/#http-access-control-expose-headers"]
schema_version: 1
---

# HTTP-заголовки

## Коротко

Передавайте media type, управление кешем и условия повтора стандартными HTTP-полями с определенной семантикой. Пользовательский заголовок не заменяет HTTP status code.

## Плохо

```http
HTTP/1.1 200 OK
X-App-Result: error
Content-Type: application/json

{"message":"Сервис недоступен"}
```

## Хорошо

```http
HTTP/1.1 503 Service Unavailable
Content-Type: application/problem+json
Retry-After: 30

{"title":"Service Unavailable"}
```

## Почему

Это минимальный профиль заголовков API, не полный перечень HTTP. Content-Type описывает фактическое тело запроса/ответа; Accept в запросе выражает предпочтение клиента. Vary в ответе указывает влияющие на выбор представления поля запроса. Cache-Control задается по чувствительности и допустимой свежести, см. caching.private-cache. Добавление заголовка без потребителя не является целью.

## Когда применять

Для HTTP API с телом и/или кешированием. Retry-After в ответе 503 или 429 может содержать неотрицательное целое число секунд либо HTTP-date; он не обязателен во всех ошибках и не гарантирует будущий успех. При отсутствии клиент применяет согласованный backoff. Пример 30 секунд иллюстративный.

Если браузерному cross-origin клиенту нужно читать Retry-After или согласованный X-Request-Id, настройте их явное раскрытие через Access-Control-Expose-Headers и проверьте реальную CORS-политику; это не нужно серверному клиенту. Content-Language необязателен и описывает естественные языки предполагаемой аудитории представления; это не обязательно все языки, встречающиеся в его содержимом. Пользовательские X-App-* не обязательны. Удаление уже используемого заголовка оценивайте как изменение контракта.

## Как проверить

1. JSON-ответ → обычный HTTP-клиент → распознает ошибку по status и тело по Content-Type → HTTP-трасса без зависимости от X-App-Result.

2. 503 с Retry-After и без него → клиент повтора → учитывает секунды/дату либо backoff в общем бюджете → временная шкала запросов.

3. Cross-origin браузер читает Retry-After → CORS-ответ → нужный заголовок доступен; при выборе локали по заголовку запроса кешируемые варианты разделены соответствующим Vary, например Accept-Language; локаль, полностью заданная URL, сама по себе не требует Vary: Accept-Language → browser-тест и ответы прокси.

## Человек

Определяет нужды клиентов, кеша и диагностики и назначение каждого нестандартного поля.

## Агент

Проверяет значения заголовков вместе с телом, статусом и браузерным доступом; связывает политику кеша с данными ответа.

## Источники

- [RFC 9110, §8.3, §10.2.3, §12.5: media type, Retry-After, negotiation](https://www.rfc-editor.org/rfc/rfc9110.html)
- [RFC 6585, §4: 429 и опциональный Retry-After](https://www.rfc-editor.org/rfc/rfc6585.html)
- [Fetch, CORS protocol: Access-Control-Expose-Headers](https://fetch.spec.whatwg.org/#http-access-control-expose-headers)
