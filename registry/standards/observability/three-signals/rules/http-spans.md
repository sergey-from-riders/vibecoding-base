---
id: "operations.http-spans"
title: "HTTP spans"
section: "operations"
level: "recommended"
tags: ["http-spans", "OpenTelemetry"]
technologies: ["OpenTelemetry"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 84
related: ["operations.correlation", "operations.signals"]
sources: ["https://opentelemetry.io/docs/specs/semconv/http/http-spans/"]
schema_version: 1
---

# HTTP spans

## Коротко

Для HTTP-инструментации OpenTelemetry различай HTTP status code и Span Status.

## Плохо

```text
Любой код >= 400 → Error независимо от SpanKind.
Любой 200 → OK, даже если чтение тела оборвалось.
Пользователь отменил запрос → всегда считать отказом сервиса.
```

## Хорошо

```text
Обычный 200: Unset, без принудительного OK.
Обычный 404: SERVER Unset; CLIENT Error по рекомендации.
200 и ошибка получения тела: Error.
Распознанная намеренная отмена CLIENT: Unset по рекомендации;
error.type не задается. Контекст и версия semconv зафиксированы.
```

## Почему

HTTP-код описывает ответ протокола, а span отражает выполнение операции. Механическое правило «все 4xx — ошибка сервера» искажает телеметрию.

## Когда применять

Для OpenTelemetry HTTP spans соответствующей версии, а не для всех журналов приложения. Сопоставь версию SDK/instrumentation и экспортируемые conventions; обновление этой статьи не меняет установленную библиотеку. В источнике часть общего описания ошибок помечена Development — это не гарантия одинаковой поддержки инструментами.

### Подробные условия

Проверена Semantic Conventions 1.45.0, раздел Status, 2026-11-13. Когда у инструментации есть дополнительный контекст конкретного запроса, спецификация допускает (MAY) более точную классификацию. Без него действуют правила таблицы.

Для 1xx/2xx/3xx статус span MUST оставаться Unset; при другой ошибке, например неполученном теле после 200, MUST быть Error. Для 4xx на SERVER — MUST Unset, на CLIENT — SHOULD Error. Для 5xx и неинтерпретируемого клиентом кода — SHOULD Error. Это разные нормативные уровни: SHOULD допускает обоснованное отступление.

Если клиентская инструментация распознает намеренную отмену вызывающим кодом, она SHOULD оставить Unset и SHOULD NOT задавать error.type. Ненамеренный сетевой отказ обрабатывается как ошибка по применимому условию. http.response.status_code записывается, только если код действительно получен/отправлен; не выдумывай 500 при отсутствии ответа.

## Как проверить

- 200 без иной ошибки → получить SERVER/CLIENT span → Unset; принудительного OK нет.
- 404 без дополнительного контекста → сравнить оба SpanKind → SERVER Unset, CLIENT обычно Error; отступление от SHOULD обосновано.
- После 200 оборвалось тело либо caller намеренно отменил запрос → сравнить → первое Error; второе не классифицируется так автоматически.

| HTTP / событие | SpanKind | Дополнительный контекст | Норма и ожидаемый статус |
| --- | --- | --- | --- |
| 200 | SERVER / CLIENT | Нет другой ошибки | MUST Unset |
| 404 | SERVER | Нет | MUST Unset |
| 404 | CLIENT | Нет | SHOULD Error |
| 500 | SERVER / CLIENT | Нет | SHOULD Error |
| 200 | CLIENT | Ошибка получения тела | MUST Error |
| Ответ не получен | CLIENT | Ненамеренный сетевой отказ | SHOULD Error, SHOULD error.type |
| Отмена caller | CLIENT | Намеренность распознана | SHOULD Unset, SHOULD NOT error.type |

## Человек

Выбирает совместимую версию инструментации и документирует контекстное отклонение от рекомендации.

## Агент

Сопоставляет код, SpanKind, причину завершения и фактический экспорт; не повышает SHOULD до MUST.

## Источники

- [OpenTelemetry Semantic Conventions 1.45.0: HTTP spans](https://opentelemetry.io/docs/specs/semconv/http/http-spans/) — Status; checked 2026-11-13, including normative MUST/SHOULD/MAY distinctions.
