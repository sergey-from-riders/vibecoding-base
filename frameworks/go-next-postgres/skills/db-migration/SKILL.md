# Skill: db-migration

## Когда использовать
- любые изменения схемы в `Auth` или `Company Context`.

## Процедура
1. Прочитать `docs/07-DB-NAMING-CONVENTIONS.md` и `docs/15-DATA-VERSIONING-AND-DIFF.md` (обязательно до начала).
2. Создать `NNNNNN_name.up.sql` + `NNNNNN_name.down.sql`.
3. Проверить idempotency where applicable (`IF EXISTS`/`IF NOT EXISTS`).
4. Проверить rollback семантику.
5. Проверить ключевые запросы на индексы.
6. Для каждой новой бизнес-таблицы добавить `*_versions` + триггеры snapshot-versioning.
7. Обновить `docs/04` (и `docs/07`/`docs/15`, если менялся стандарт).

## Правила
- append-only history;
- не переписывать примененные миграции;
- risky changes только phased.
- PK каждой сущности только `<entity>_id uuid`.
- FK только `<target_entity>_id uuid`.
- generic `id`/`uuid` для доменных ключей запрещены.
- Для бизнес-данных версия обязательна: full snapshot per change.
- Логовые таблицы (auth events, telemetry, request logs) исключаются из versioning.

## DoD
- up/down выполняются стабильно;
- критические auth/switch запросы индексированы;
- naming contract (`<entity>_id + uuid`) соблюден полностью;
- business versioning contract соблюден полностью;
- документация обновлена.
