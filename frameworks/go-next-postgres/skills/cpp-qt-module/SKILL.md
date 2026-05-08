# Skill: cpp-qt-module

## Когда использовать
- любая C++/Qt задача в `apps/desktop/qt`;
- изменение моделей владения/памяти;
- изменения desktop UI flow.

## Required pre-read
- `docs/20-CPP-QT-MEMORY-SAFETY-STANDARD.md`
- `docs/19-NEXT-NODE-FRONTEND-STANDARD.md`
- `docs/08-UI-CROSS-PLATFORM-RULES.md`

## Процедура
1. Зафиксировать ownership model для новых типов.
2. Реализовать без `new/delete/malloc/free`.
3. Проверить QObject ownership (`parent`/`QPointer`) и smart pointer contract.
4. Проверить UI parity с web flow и tokens/style правилами.
5. Прогнать `tools/scripts/check_cpp_limits.sh apps/desktop/qt`.
6. Прогнать sanitizer/static-analysis/tests набор.
7. Обновить docs/ADR при изменении архитектурных правил.

## DoD
- memory-safety правила соблюдены;
- raw ownership patterns отсутствуют;
- cpp limits check и тестовые гейты пройдены.
