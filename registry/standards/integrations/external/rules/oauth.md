---
id: "integrations.oauth"
title: "OAuth и PKCE"
section: "integrations"
level: "required"
tags: ["oauth", "OAuth"]
technologies: ["OAuth"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 60
related: ["security.secrets", "security.object-access", "integrations.mcp"]
sources: ["https://www.rfc-editor.org/rfc/rfc9700.html", "https://www.rfc-editor.org/rfc/rfc7636.html", "https://openid.net/specs/openid-connect-core-1_0.html"]
schema_version: 1
---

# OAuth и PKCE

## Коротко

Для интерактивного OAuth используйте Authorization Code с защитой привязки транзакции. Разделяйте OAuth-доступ к API и OIDC-аутентификацию пользователя.

## Плохо

```text
Callback принимает произвольные code и redirect_uri.
ID token используется как access token любого API.
Один state/verifier повторно используется всеми сессиями.
```

## Хорошо

```text
Новая транзакция: случайный verifier, S256 challenge, одноразовый state.
Связь с браузерной сессией, ожидаемым issuer и redirect_uri.
Callback проверяет связь, срок и одноразовость.
Code обменивается с прежним verifier у ожидаемого token endpoint.
OIDC-вход дополнительно проверяет ID token и nonce, если он отправлен.
```

## Почему

RFC 9700 требует PKCE для public clients и рекомендует для confidential clients; профиль примера применяет S256 в обоих случаях. RFC допускает разные корректные механизмы CSRF-защиты: обязательный state дополнительно к PKCE здесь — явный профиль, не универсальный MUST RFC. State не заменяет PKCE и проверку issuer.

## Когда применять

Для redirect-based пользовательского доступа; client_credentials и device flows имеют другой контракт. Public client не может сохранять общий client secret как доказательство своей личности. Confidential client использует зарегистрированную аутентификацию на token endpoint, хранит секрет на сервере и не раскрывает его браузеру.

В профиле каждый verifier/state случаен, уникален, имеет короткий проектный срок, связан с одной начатой сессией и потребляется один раз. Redirect URI сверяется точно с зарегистрированным; исключения вроде порта loopback native-клиента применяются только по соответствующему профилю RFC. Зафиксируйте доверенный issuer/endpoints и защиту от mix-up, не принимайте endpoint из произвольного callback.

При OIDC библиотека проверяет ID token по §3.1.3.7: issuer, audience/client_id, срок и допустимый способ проверки подлинности; nonce обязателен к сравнению, если был отправлен. В этом профиле подпись проверяется по доверенным ключам и разрешенным алгоритмам. Resource server отдельно проверяет access token: предназначение для этого API, scope и срок через выбранный JWT/introspection-контракт; opaque token нельзя просто декодировать. Public refresh token должен иметь rotation либо sender constraint; обработайте replay и параллельное обновление. Password grant не используется, scopes минимальны, коды/токены не журналируются.

## Как проверить

1. Начатая транзакция → callback с правильным code/state/verifier → один успешный обмен и нужный доступ → запись состояния без секретов.

2. Подменены state/issuer/redirect, verifier либо повторен callback → обработка → новая сессия/доступ не создаются → отказ до бизнес-эффекта.

3. Access token другой аудитории/истек; OIDC nonce не совпал; повтор старого refresh → проверка → отказ/реавторизация по провайдеру → отрицательные protocol fixtures.

## Человек

Выбирает тип клиента, доверенного issuer, scopes и профиль хранения/обновления токенов.

## Агент

Использует проверенную OAuth/OIDC-библиотеку, проверяет lifecycle транзакции и различает ID/access/refresh token.

## Источники

- [RFC 9700, §2.1–2.5, §4.4, §4.7, §4.14: PKCE, mix-up, CSRF, refresh](https://www.rfc-editor.org/rfc/rfc9700.html)
- [RFC 7636, §4: verifier/challenge и S256](https://www.rfc-editor.org/rfc/rfc7636.html)
- [OpenID Connect Core 1.0 errata 2, §3.1.3.7: ID Token Validation](https://openid.net/specs/openid-connect-core-1_0.html)
