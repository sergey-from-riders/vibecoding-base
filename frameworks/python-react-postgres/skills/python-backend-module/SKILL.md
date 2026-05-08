# Skill: python-backend-module

## Когда использовать
- любая backend-фича в `apps/api`;
- изменения роутинга/хендлеров;
- изменения service/repository границ.

## Required pre-read
- `docs/18-PYTHON-BACKEND-ENGINEERING-STANDARD.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`
- `docs/05-AUTH-COMPANY-SWITCH.md`

## Процедура
1. Сначала обновить/зафиксировать API contract.
2. Разнести маршруты по модульным `router.py`.
3. Создать отдельный handler-файл на endpoint.
4. Вынести business logic в service layer.
5. Проверить line limits (file/function/handler).
6. Добавить unit + integration tests.
7. Обновить документацию и ADR (если меняются архитектурные правила).

## DoD
- нет гигантских router/handler файлов;
- handler thin, service fat enough for domain rules;
- лимиты размера соблюдены;
- тестовые гейты по backend пройдены.
