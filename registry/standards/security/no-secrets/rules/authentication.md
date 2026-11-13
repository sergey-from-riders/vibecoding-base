---
schema_version: 1
id: "security.authentication"
title: "Аутентификация: вход, факторы и восстановление"
section: "security"
level: "required"
tags: ["authentication", "passwords", "mfa", "recovery"]
technologies: ["Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1051
related: ["security.sessions", "security.resource-limits", "security.secrets", "integrations.oauth"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html", "https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html", "https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html"]
---

# Аутентификация: вход, факторы и восстановление

## Коротко

Все пути получения учетной записи проходят серверную проверку подлинности и защиту от перебора. Восстановление пароля или смена фактора не могут быть более слабым обходом основного входа.

## Плохо

```text
Основной вход требует MFA, но reset по email из body сразу меняет пароль.
Пароли хранятся как SHA-256; лимит попыток проверяется только в UI.
```

## Хорошо

```text
Серверный authentication framework / доверенный IdP.
Вход → bounded attempts → проверка фактора → новая сессия.
Recovery → одноразовый ограниченный token → атомарное потребление.
Sensitive account change → повторная аутентификация + уведомление.
Успех/отказ журналируются без пароля, OTP и recovery token.
```

## Почему

Аутентификация устанавливает субъект, но не права на объект. Хеш общего назначения не предназначен для замедления перебора паролей. Надежный login теряет смысл, если legacy API, support flow или повторно используемая reset-ссылка позволяют получить ту же учетную запись без нужного подтверждения.

## Когда применять

Для интерактивного входа пользователей; machine-to-machine credentials имеют отдельный профиль. Перечислите login, registration, recovery, MFA enrollment/removal, account linking и служебные обходы. Проверка выполняется backend/IdP; локальный флаг браузера не является результатом. Используйте поддерживаемый framework/IdP, TLS и одинаковую политику на web/mobile/API. В этом профиле административный доступ и управление платежами требуют MFA; остальные роли выбираются анализом риска. Для OIDC действует integrations.oauth.

Если приложение хранит пароли, используйте password-hashing API с индивидуальной солью, предпочтительно Argon2id; параметры выбираются не ниже актуального принятого OWASP-профиля и проверяются под нагрузкой. Не храните plaintext/обратимо зашифрованный пароль и не используйте простой SHA-256. Разрешите passphrases и password managers; задайте minimum/maximum длину без скрытого усечения, запрет известных скомпрометированных паролей, отказ от произвольной периодической смены без основания. Числа политики должны быть записаны в проекте, не оставаться словами «достаточно надежный».

Предел попыток учитывает account и общий источник/бюджет, действует на всех экземплярах и не позволяет легко навсегда заблокировать жертву. Ответы login/recovery не раскрывают наличие учетной записи через текст/status и очевидное различие обработки. Recovery token случаен, связан с пользователем/назначением, имеет срок и атомарно используется один раз; он не заменяет необходимый второй фактор без отдельной безопасной recovery-политики. Смена email/пароля/MFA требует повторного подтверждения, уведомления по доверенному каналу и политики отзыва сессий.

## Как проверить

1. Верные факторы действующей учетной записи → login → сервер создает новую сессию только после полной проверки → auth event без credential.

2. Массовые неверные попытки через разные API/instances или неизвестный account → вход/recovery → общий лимит действует, публичные отказы не раскрывают account → controlled negative fixtures.

3. Reset token истек, использован повторно/параллельно, либо смена MFA без reauthentication → запрос → не более одного допустимого восстановления, обход фактора отвергнут → состояние token/account/session.

## Человек

Выбирает уровни аутентификации, численные ограничения, безопасное recovery и владельца исключений.

## Агент

Перечисляет все auth pathways, использует проверенный framework и проверяет replay/конкуренцию recovery без журналирования секретов.

## Источники

- [OWASP Authentication: authentication responses, MFA, throttling, reauthentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [OWASP Password Storage: salt, Argon2id и work factors](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [OWASP Forgot Password: token expiry/single-use и recovery response](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html)
