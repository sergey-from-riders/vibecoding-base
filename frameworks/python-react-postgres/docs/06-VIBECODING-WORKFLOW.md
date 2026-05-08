# 06. Vibe Coding Workflow (2026)

## Goal
Ускорять delivery через агентов, не теряя архитектурную целостность.

## Golden path
1. Создать task card в `agents/tasks/<id>.md`
2. Выбрать подходящий playbook в `agents/playbooks/`
3. Зафиксировать API/DB контракт и тест-план
4. Написать падающие тесты (`Red`)
5. Реализовать минимальный vertical slice (`Green`)
6. Рефакторинг без изменения поведения (`Refactor`)
7. Прогнать unit + integration + e2e smoke + universal-account regression
8. Проверить traces/logs
9. Обновить docs/adr

## Required artifacts per task
- contract diff
- migration (если есть изменение данных)
- tests (unit + integration + e2e where applicable)
- observability evidence по `docs/22-OBSERVABILITY-STANDARD.md`
- docs update
- DB naming check against `docs/07-DB-NAMING-CONVENTIONS.md` (если трогали схему)
- quality-gate proof (какие тестовые наборы прошли в CI)

## AI safety guardrails
- агент не меняет scope задачи;
- агент не добавляет новые домены без ADR;
- агент не обходит migration policy;
- агент не пушит непроверенный contract drift.
- агент не помечает фичу как готовую без прохождения test gates из `docs/17-TESTING-TDD-QUALITY-GATES.md`.
