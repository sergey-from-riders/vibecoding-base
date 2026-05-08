# ADR-0004: Unified auth, session management and native deep-link login

- Status: accepted
- Date: 2026-03-02

## Context
Python React Postgres Framework запускается как единый продукт для web, Telegram web, Qt desktop (Windows/macOS/Linux) и Android WebView.
Нужен один auth-контур:
- с социальными провайдерами;
- с управлением сессиями из UI;
- с устойчивым возвратом пользователя после долгого простоя.

Без единого решения по auth на старте возникают расхождения между платформами и проблемы с безопасностью.

## Decision
Принята единая auth-архитектура:
- один backend auth service для всех клиентов;
- канонические таблицы: `users`, `auth_identities`, `sessions`, `device_credentials`, `auth_events`;
- соцвходы (Telegram, Google, Yandex, VK) маппятся в `auth_identities`;
- desktop/mobile native вход реализуется через web + PKCE + deep link exchange;
- обязательный session management API: list sessions, revoke one, revoke all except current;
- long-lived restore реализуется через ротируемые `device_credentials`.

Детальный контракт закреплен в:
- `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`
- `docs/05-AUTH-COMPANY-SWITCH.md`

## Consequences
- Единые сценарии логина и revoke на всех платформах.
- Упрощается поддержка и аудит auth-инцидентов.
- Требуется дисциплина в secure storage adapters (Qt/Android) и строгая PKCE/state валидация.
- Миграции и тест-матрица auth становятся шире, но дрейф платформ сильно снижается.
