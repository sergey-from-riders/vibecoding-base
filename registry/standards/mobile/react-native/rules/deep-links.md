---
id: "mobile.deep-links"
title: "Проверяйте входящие ссылки и возврат авторизации"
section: "mobile"
level: "required"
tags: ["deep-links", "React Native"]
technologies: ["React Native"]
reviewed_at: "2026-11-09"
order: 93
related: ["mobile.secure-storage", "mobile.offline"]
sources: ["https://reactnative.dev/docs/security"]
schema_version: 1
---

# Проверяйте входящие ссылки и возврат авторизации

## Коротко

Ссылка должна соответствовать разрешённому маршруту и начатой операции.

## Плохо

```text
Любая ссылка с code открывает авторизованную сессию.
```

## Хорошо

```text
Проверены scheme, host, path и state.
Авторизация завершается проверкой сервера.
```

## Почему

Другое приложение или сайт может подставить свои параметры.

## Когда применять

Предпочитайте подтверждённые ссылки платформы. Не передавайте секреты в push-уведомлениях.

## Как проверить

- Проверьте чужой host, подмену state и повтор старой ссылки.

## Источники

- [Первоисточник](https://reactnative.dev/docs/security)
