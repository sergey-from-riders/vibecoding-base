# Skill: ui-cross-platform

## Когда использовать
- создание/изменение UI-правил;
- синхронизация дизайна между web/telegram/qt/android-webview;
- изменение токенов.

## Процедура
1. Прочитать `docs/08-UI-CROSS-PLATFORM-RULES.md`.
2. Для web обязательно прочитать `docs/19-REACT-NODE-FRONTEND-STANDARD.md`.
3. Для Qt обязательно прочитать `docs/20-CPP-QT-MEMORY-SAFETY-STANDARD.md`.
4. Проверить, что изменения не нарушают single-accent policy и лимит `TOTAL_PROJECT_COLORS_MAX = 5`.
5. Обновить `packages/tokens/tokens.json` при визуальных изменениях.
6. Проверить platform mapping impact (`docs/09`, `docs/10`).
7. Обновить документацию и добавить ADR при breaking-изменениях.

## DoD
- единые UX-инварианты сохранены;
- токены и платформенные правила синхронизированы;
- для web соблюдены shadcn-only и unified list правила;
- Telegram Mini App совместимость проверена для web.
