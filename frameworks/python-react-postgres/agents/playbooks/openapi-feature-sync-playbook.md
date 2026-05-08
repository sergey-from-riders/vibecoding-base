# Playbook: OpenAPI Feature Sync

Trigger: команда "актуализируй фичу".

## 1) Detect endpoint changes

1. Найти новые/измененные endpoint-ы
2. Найти изменения request/response schemas
3. Найти изменения headers/status semantics

## 2) Update contracts

1. Обновить нужный module file в `packages/contracts/openapi/modules/`
2. Обновить shared schemas в `components/schemas/` при необходимости
3. Обновить `endpoints.inventory.tsv`

## 3) Examples and docs assets

1. Добавить минимум один request/response example
2. Добавить `x-codeSamples` (curl)
3. Проверить docs endpoints артефакты

## 4) Validate

1. `tools/scripts/build_openapi_bundle.sh`
2. `tools/scripts/check_openapi_coverage.sh`

Любой fail = task не готова.

## 5) Sync dependent docs

1. Обновить профильный doc модуля (если изменился контракт)
2. Обновить ADR при изменении стандартов

## 6) Done criteria

1. Код и OpenAPI без drift
2. Coverage violations = `0`
3. Примеры и тестовые подсказки актуальны
