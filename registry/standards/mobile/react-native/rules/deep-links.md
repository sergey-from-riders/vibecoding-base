---
id: "mobile.deep-links"
title: "Deep links"
section: "mobile"
level: "required"
tags: ["deep-links", "React Native"]
technologies: ["React Native"]
reviewed_at: "2026-11-09"
order: 93
related: ["integrations.oauth", "security.object-access"]
sources: ["https://reactnative.dev/docs/security"]
schema_version: 1
---

# Deep links

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

## Человек

Определяет разрешённые адреса и ожидаемый сценарий возврата.

## Агент

Реализует поведение клиента и проверяет потерю сети, повторный запуск и ограничения платформы.

Контроль результата:

- Проверьте чужой host, подмену state и повтор старой ссылки.

## Источники

- [Security · React Native](https://reactnative.dev/docs/security)
