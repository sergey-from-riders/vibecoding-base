# ADR-0005: Test-first delivery and mandatory CI quality gates

- Status: accepted
- Date: 2026-03-02

## Context
Проект развивается в агентном и высокоскоростном режиме.
Без жестких тестовых гейтов и TDD-подхода скорость быстро приводит к regression и неустойчивому deploy.

## Decision
Принят обязательный test-first подход:
- каждая фича проходит цикл `Red -> Green -> Refactor`;
- каждый backend-модуль обязан иметь реальные integration tests;
- каждая frontend-фича обязана иметь component/integration tests и e2e coverage;
- универсальный test account используется для межфичевого regression;
- CI verify stages обязательны перед build/deploy;
- deploy блокируется при падении любого test gate.

Детальный регламент закреплен в:
- `docs/17-TESTING-TDD-QUALITY-GATES.md`

## Consequences
- Снижается скорость "сырого" кодинга без тестов.
- Существенно растет надежность релизов и повторяемость результата.
- Появляется предсказуемая дисциплина приемки: без green tests фича не считается готовой.
