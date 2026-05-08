# Skill: tdd-quality-gate

## Когда использовать
- любая фича backend/frontend;
- изменения в CI/CD quality gates;
- подготовка задачи к merge/release.

## Required pre-read
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `docs/06-VIBECODING-WORKFLOW.md`

## Процедура
1. Зафиксировать feature test-plan до реализации.
2. Написать падающие тесты (`Red`).
3. Реализовать минимальный код (`Green`).
4. Выполнить рефакторинг и повторный прогон.
5. Проверить обязательные наборы:
- backend unit + integration;
- frontend component/integration + e2e (для затронутых сценариев);
- universal-account regression.
6. Обновить CI/deploy документацию при изменении gate логики.

## DoD
- тесты добавлены и реально подтверждают новое поведение;
- ни один обязательный gate не пропущен;
- фича не помечена ready до полного green статуса.
