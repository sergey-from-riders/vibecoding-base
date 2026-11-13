---
schema_version: 1
id: "security.sessions"
title: "Сессии: выдача, срок и отзыв"
section: "security"
level: "required"
tags: ["sessions", "cookies", "revocation"]
technologies: ["HTTP", "Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1052
related: ["security.authentication", "security.csrf", "security.object-access", "caching.private-cache"]
sources: ["https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x16-V7-Session-Management.md", "https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x12-V3-Web-Frontend-Security.md", "https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html"]
---

# Сессии: выдача, срок и отзыв

## Коротко

Сервер проверяет сессию, ограничивает ее срок и отзывает при logout/отключении учетной записи. Удаление cookie в браузере не отзывает скопированный token.

## Плохо

```http
Set-Cookie: session=user_id_42; Domain=example.com; Path=/
# При logout только убрать cookie; прежний token сервер все еще принимает.
```

## Хорошо

```http
Set-Cookie: __Host-session=<opaque-random-token>; Path=/; Secure; HttpOnly; SameSite=Lax
# После аутентификации token новый; прежний недействителен.
# Logout: invalidate backend session, затем удалить cookie с тем же scope.
```

## Почему

Session fixation предотвращается сменой token при аутентификации. Secure/HttpOnly ограничивают передачу и чтение cookie, но не заменяют CSRF/XSS-защиту. Для self-contained JWT одна подпись и exp не обеспечивают немедленный отзыв до истечения.

## Когда применять

Для приложений с пользовательской сессией. Пример — stateful browser session cookie; значение является placeholder, реальный reference token создается CSPRNG с не менее 128 бит энтропии согласно выбранному ASVS 5.0.0, 7.2.3. Не кодируйте в нем user_id/PII. Проверяйте token на backend, создавайте новый при authentication/reauthentication и прекращайте действие старого; конкурентные запросы/rotation не должны восстанавливать отозванный token.

Документируйте idle timeout, absolute lifetime, parallel sessions и необходимость reauthentication. Сроки контролирует сервер, активность не продлевает absolute lifetime. Logout/expiry инвалидируют сессию; disabled/deleted account прекращает все сессии. Для JWT выберите действенный revoke/version/denylist механизм и проверьте его на всех consumers; refresh token не должен возрождать отозванную сессию. Поведение SSO/IdP/RP при logout и повторном входе фиксируется отдельно.

Cookie-профиль: HTTPS, Secure, HttpOnly для session value, минимальный scope, __Host- без Domain и с Path=/, если cookie не требуется другим hosts. При обоснованной передаче cookie другим hosts используйте __Secure- и явно ограниченный Domain по выбранному ASVS-профилю; этот префикс не устраняет риски недоверенных соседних subdomains. SameSite выбирается под flow: Strict/Lax для обычного same-site, None+Secure только при обоснованной cross-site необходимости с отдельной CSRF-защитой. Это прикладной профиль на выбранных controls ASVS, не заявление полного соответствия. Session token не помещается в URL, localStorage, логи и общедоступный кеш; иной клиентский transport требует отдельного threat model.

## Как проверить

1. Успешный login с заранее известным старым token → authentication → новый token работает, старый отклоняется → server session state.

2. Idle/absolute expiry, logout или disabled account → запрос с копией прежнего token и refresh → доступа нет во всех consumers → replay fixtures.

3. Cookie в браузере → HTTP/script/cross-site попытка → Secure/HttpOnly/SameSite соответствуют профилю; допустимый SSO flow работает → browser network и cookie inspection.

## Человек

Задает сроки, одновременные сессии, отзыв и согласованное поведение SSO.

## Агент

Проверяет backend lifecycle и replay, cookie scope и невозможность восстановления отозванной сессии.

## Источники

- [ASVS v5.0.0 V7: 7.2.1–4, 7.3.1–2, 7.4.1–2 — verification, expiry, termination](https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x16-V7-Session-Management.md)
- [ASVS v5.0.0 V3: 3.3.1–4 — browser cookie profile](https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x12-V3-Web-Frontend-Security.md)
- [OWASP Session Management: cookie attributes и session lifecycle](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
