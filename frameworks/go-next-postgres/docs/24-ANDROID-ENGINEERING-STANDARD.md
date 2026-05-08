# 24. Android Engineering Standard (WebView-First, 2026)

Этот документ обязателен для всех изменений в `apps/mobile/android`.

## 1) Scope

Android-клиент в текущей фазе:
1. Kotlin native shell
2. Secure WebView container
3. Deep link + auth exchange orchestration
4. Минимальные native adapters (без дублирования web бизнес-логики)

## 2) Fixed stack

1. `Kotlin >= 2.1`
2. `Android Gradle Plugin >= 8.7`
3. `minSdk = 28`
4. `targetSdk = 36`
5. `compileSdk = 36`

## 3) Architecture rules

1. `Single-activity` shell by default.
2. Web UI — единственный источник продуктового UI для Android на текущем этапе.
3. Native code отвечает только за:
- lifecycle;
- deep links;
- secure storage;
- limited JS bridge;
- crash/telemetry hooks.
4. Бизнес-правила auth/company-switch не дублируются в Kotlin.

## 4) WebView security baseline (mandatory)

1. `javaScriptEnabled = true` только для trusted origin.
2. `allowFileAccess = false`
3. `allowContentAccess = false`
4. `setSupportMultipleWindows(false)`
5. `mixedContentMode = MIXED_CONTENT_NEVER_ALLOW`
6. `safeBrowsingEnabled = true`
7. custom `WebViewClient` с allowlist доменов
8. любые переходы вне allowlist -> external browser

## 5) WebView bridge policy

Bridge включается только через явный allowlist методов.

Разрешенные категории bridge-методов:
1. auth/deep-link callback ack
2. telemetry ping
3. device-info minimal envelope

Запрещено:
1. выполнение произвольного JS command
2. передача секретов/токенов в plaintext в bridge payload
3. прямой доступ bridge к file system API

## 6) Deep link and auth exchange (mandatory)

Канонический flow:
1. Web auth стартует provider login.
2. Provider callback -> app deep link.
3. Android shell извлекает `code/state`.
4. Shell отправляет exchange на backend:
- `POST /api/v1/auth/native/exchange`
5. Получает app session + device credential flow.

Без `state`-проверки flow считается non-compliant.

## 7) Environment contract

Источник шаблона:
- `apps/mobile/android/.env.example`

Обязательные переменные:
1. `APP_ANDROID_WEB_BASE_URL`
2. `APP_ANDROID_API_BASE_URL`
3. `APP_ANDROID_APP_ID`
4. `APP_ANDROID_APP_NAME`

Правило:
- production URL только через Nginx public domain.

## 8) Strict numeric limits

1. `MAX_KT_FILE_LINES = 260`
2. `MAX_CLASS_LINES = 220`
3. `MAX_FUNCTION_LINES = 45`
4. `MAX_BRIDGE_FILE_LINES = 180`
5. `MAX_BRIDGE_METHODS_PER_FILE = 12`
6. `MAX_COMMENT_RATIO_PERCENT = 5`

Нарушение лимитов блокирует merge.

## 9) Testing baseline

Каждая фича Android shell обязана иметь:
1. unit tests (bridge/deep-link/parser logic)
2. instrumentation smoke (WebView load + auth callback)
3. regression test для последнего найденного бага

Минимальный smoke сценарий:
1. app open
2. web bundle load
3. deep link callback parse
4. native exchange request dispatch

## 10) Observability contract

1. Все network errors логируются structured log с `request_id`.
2. События `deep_link_received`, `exchange_started`, `exchange_finished` обязательны.
3. Логирование payload без секретов.
4. Стандарт observability: `docs/22-OBSERVABILITY-STANDARD.md`.

## 11) UI parity rules

1. Android WebView UX повторяет web/telegram flow.
2. Токены и визуальные ограничения наследуются из web token system.
3. Любое divergence фиксируется ADR или feature note.

## 12) Definition of Done

Android-изменение принимается только если:
1. соблюдены лимиты из раздела 8;
2. deep link + exchange flow протестирован;
3. observability events присутствуют;
4. нет дублирования backend бизнес-логики в shell.
