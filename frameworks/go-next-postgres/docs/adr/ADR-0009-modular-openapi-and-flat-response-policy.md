# ADR-0009: Modular OpenAPI and flat response/header policy

- Status: accepted
- Date: 2026-03-02

## Context
Нужен единый контракт endpoint-ов: модульные OpenAPI файлы, единый bundle, docs endpoints, и строгая политика формата ответа/заголовков.
Без этого фичи расходятся между кодом и контрактом.

## Decision
Принят обязательный стандарт:
- OpenAPI 3.2.0, модульные файлы по доменам;
- единый bundle + docs/catalog artifacts через scripts;
- coverage check по inventory endpoint-ов;
- обязательные docs endpoints;
- flat response policy + mandatory response headers;
- обязательный error tone: `Исправьте/Проверьте/Укажите/...`.

Канонический регламент:
- `docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md`

## Consequences
- Контракт всегда синхронизирован с реализацией.
- Endpoint без OpenAPI описания блокируется.
- API ответы и ошибки унифицируются по формату и тону.
