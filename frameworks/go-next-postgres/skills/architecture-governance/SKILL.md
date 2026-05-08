# Skill: architecture-governance

## Когда использовать
- изменение структуры монорепы;
- изменение межмодульных границ;
- добавление новых shared packages.

## Процедура
1. Проверить scope-lock (`Auth + Switch Company`).
2. Проверить слои: adapter -> service -> repository.
3. Для backend проверить compliance с `docs/18-GO-BACKEND-ENGINEERING-STANDARD.md`.
4. Проверить контрактность: есть ли изменение в `packages/contracts`.
5. Проверить observability impact.
6. Обновить `docs/*` и при необходимости `docs/adr/*`.

## DoD
- границы не нарушены;
- нет бизнес-логики вне backend service layer;
- docs и contracts синхронизированы.
