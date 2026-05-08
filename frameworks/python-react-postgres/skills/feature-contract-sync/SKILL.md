# Skill: feature-contract-sync

## Когда использовать
- команда: “актуализируй фичу”;
- добавление/изменение endpoint-ов;
- изменения API response format/headers.

## Required pre-read
- `docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `packages/contracts/README.md`

## Процедура
1. Найти все endpoint-ы, затронутые фичей.
2. Обновить соответствующий module OpenAPI файл.
3. Добавить/обновить examples и code samples.
4. Обновить `endpoints.inventory.tsv`.
5. Прогнать:
- `tools/scripts/build_openapi_bundle.sh`
- `tools/scripts/check_openapi_coverage.sh`
6. Проверить docs endpoints artifacts (`openapi.json`, `openapi.yaml`, `endpoints.catalog.json`).
7. Обновить docs/ADR при изменении контрактных правил.

## DoD
- нет endpoint-ов вне OpenAPI;
- coverage check пройден;
- docs endpoints и examples актуальны;
- flat response/header policy соблюдена.
