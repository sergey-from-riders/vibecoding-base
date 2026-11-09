---
id: "integrations.oauth"
title: "OAuth и PKCE"
section: "integrations"
level: "required"
tags: ["oauth", "OAuth"]
technologies: ["OAuth"]
reviewed_at: "2026-11-09"
order: 60
related: ["integrations.timeouts", "integrations.retries"]
sources: ["https://www.rfc-editor.org/rfc/rfc9700.html"]
schema_version: 1
---

# OAuth и PKCE

## Коротко

Для делегированного доступа проверяйте получателя токена и связывайте ответ с начатой авторизацией.

## Плохо

```text
Общий токен всем приложениям.
Произвольный redirect_uri.
```

## Хорошо

```text
Authorization Code + PKCE.
Точный redirect_uri, проверка issuer и state.
```

## Почему

Непроверенный адрес возврата или чужой токен может привести к захвату доступа.

## Когда применять

Состав проверок зависит от клиента и провайдера. Не используйте password grant; минимизируйте scopes.

## Как проверить

- Проверьте подмену state, redirect_uri и токена другой аудитории.

## Человек

Регистрирует приложение и выбирает минимальные разрешения.

## Агент

Реализует интеграцию по документации установленной версии и проверяет отказ, тайм-аут и повтор.

Контроль результата:

- Проверьте подмену state, redirect_uri и токена другой аудитории.

## Источники

- [RFC 9700: Best Current Practice for OAuth 2.0 Security](https://www.rfc-editor.org/rfc/rfc9700.html)
