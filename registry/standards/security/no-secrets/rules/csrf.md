---
schema_version: 1
id: "security.csrf"
title: "Браузер: защита изменяющих запросов от CSRF"
section: "security"
level: "required"
tags: ["csrf", "cookies", "cors"]
technologies: ["HTTP", "Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1054
related: ["security.sessions", "security.output-encoding", "api.methods", "integrations.webhooks"]
sources: ["https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x12-V3-Web-Frontend-Security.md", "https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html"]
---

# Браузер: защита изменяющих запросов от CSRF

## Коротко

Если браузер автоматически прикладывает credentials, сервер проверяет допустимость инициатора изменяющего запроса. Наличие cookie, POST или CORS-ответа само по себе не подтверждает намерение пользователя.

## Плохо

```http
POST /preferences HTTP/1.1
Cookie: session=<token>
Content-Type: application/x-www-form-urlencoded

email_notifications=false
# Сервер меняет настройки только по cookie, без CSRF-проверки.
```

## Хорошо

```http
POST /preferences HTTP/1.1
Origin: https://app.example.com
Cookie: __Host-session=<session-token>
X-CSRF-Token: <session-bound-token>
Content-Type: application/json

{"email_notifications":false}
# Backend проверяет сессию, допустимый origin и CSRF token до изменения.
```

## Почему

Cross-site form способен отправить некоторые запросы вместе с ambient credentials даже когда атакующий не может прочитать ответ из-за same-origin policy. SameSite различает sites, а не любые origins: недоверенный соседний subdomain может иметь значение. XSS внутри доверенного origin способен обойти CSRF-механизм, поэтому нужны оба правила.

## Когда применять

Для browser flows с cookie/session или другим автоматически отправляемым credential, включая login CSRF. Обычный machine-to-machine webhook не использует browser CSRF token: он защищается отдельной подписью, и исключение ограничивается конкретным маршрутом. API с bearer token только в явно заданном Authorization header и без cookie fallback может иметь другой профиль; это должно быть подтверждено фактическими auth paths.

Предпочитайте встроенную защиту framework. Для stateful формы/API используйте synchronizer token, связанный с сессией; проверяйте на backend до эффекта, не передавайте в URL/log. Если выбран signed double-submit, токен должен быть криптографически связан с конкретной сессией; простого равенства двух attacker-controlled значений недостаточно.

Альтернативный профиль для browser API может опираться на обязательный non-safelisted header/preflight, точную allowlist origins и отказ от simple content types/обходных маршрутов. CORS reflection любого Origin, permissive credentials или доступная form-ветвь нарушают этот контракт. Origin/Fetch Metadata проверяются с документированным поведением при отсутствии/null; отсутствие не должно молча разрешать чувствительную операцию. SameSite и origin policy дополняют выбранный механизм. GET/HEAD/OPTIONS не выполняют запрошенные бизнес-изменения. Для batch проверяется весь endpoint до любого частичного эффекта.

## Как проверить

1. Текущая сессия и правильный session-bound token из разрешенного origin → POST → изменение применяется один раз по обычному контракту → server result.

2. Cross-site form, отсутствующий/чужой token или null/untrusted origin → запрос → эффект отсутствует, сервер отклоняет до записи → controlled browser/server fixture.

3. Проект использует preflight profile → simple content type/header omission либо route alias → попытка → обход не принят; подписанный webhook работает по собственному контракту → negative routing tests.

## Человек

Выбирает token/preflight/Fetch-Metadata профиль, доверенные origins и узкие исключения.

## Агент

Проверяет реальную отправку credentials и все изменяющие маршруты, включая login и simple-request обход.

## Источники

- [ASVS v5.0.0 V3: 3.5.1–3 — anti-forgery, preflight, safe methods](https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x12-V3-Web-Frontend-Security.md)
- [OWASP CSRF Prevention: built-in defenses, synchronizer/signed double-submit, headers/CORS](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
