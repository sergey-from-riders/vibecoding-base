# Playbook: Auth Feature Delivery

Scope: изменения в Auth / Session / Switch Company.

## 1) Spec

1. Открыть task log: `agents/tasks/<task-id>.md`
2. Зафиксировать сценарий (happy + negative)
3. Проверить scope (`Auth`, `Switch Company` only)

## 2) Contract

1. Обновить OpenAPI module файлы
2. Обновить `endpoints.inventory.tsv`
3. Добавить примеры request/response и curl samples

## 3) Tests Red

1. Unit tests для service layer
2. Integration tests endpoint -> service -> DB
3. E2E/smoke сценарий (если UI затронут)
4. Убедиться, что новые тесты падают до реализации

## 4) Implementation

1. Реализовать минимальный vertical slice
2. Не допускать business logic в handler/UI adapters
3. Соблюдать лимиты и стандарты module-specific docs

## 5) Tests Green

1. Запустить полный набор для затронутых модулей
2. Исправить regressions
3. Зафиксировать evidence в task log

## 6) Observability

1. Добавить trace/log/metrics для новых endpoint-ов
2. Проверить `request_id` propagation
3. Проверить error telemetry

## 7) Docs and commit

1. Обновить docs/ADR при изменении правил
2. Подготовить атомарные коммиты по `docs/14`
3. В commit body добавить Why/What/Impact/Validation

## 8) Done criteria

1. Contracts + tests + code + docs синхронизированы
2. Quality gates пройдены
3. Нет неописанных endpoint-ов
