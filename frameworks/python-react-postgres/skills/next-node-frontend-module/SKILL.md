# Skill: next-node-frontend-module

## Когда использовать
- любая frontend-фича в `apps/web`;
- изменение list UI;
- изменение design tokens/style rules;
- изменения React/Node runtime слоя в web приложении.

## Required pre-read
- `docs/19-REACT-NODE-FRONTEND-STANDARD.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `docs/08-UI-CROSS-PLATFORM-RULES.md`

## Процедура
1. Проверить reuse-first и shadcn-only ограничения.
2. Проверить, что list экран использует unified list kit.
3. Проверить mobile-first compact layout и high-contrast style policy.
4. Проверить запрет на shadow/black-border/transition-all.
5. Прогнать `tools/scripts/check_web_limits.sh apps/web`.
6. Добавить/обновить unit + integration + e2e тесты.
7. Обновить документацию и ADR при архитектурных изменениях.

## DoD
- лимиты и стиль-политика соблюдены;
- duplicate list implementation отсутствует;
- web limits check и тестовые гейты пройдены.
