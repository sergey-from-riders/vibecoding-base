---
id: "mobile.deep-links"
title: "Deep links"
section: "mobile"
level: "required"
tags: ["deep-links", "React Native"]
technologies: ["React Native"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 93
related: ["integrations.oauth", "security.object-access"]
sources: ["https://reactnative.dev/docs/linking", "https://www.rfc-editor.org/rfc/rfc8252", "https://developer.android.com/training/app-links/verify-applinks", "https://developer.apple.com/documentation/xcode/supporting-associated-domains"]
schema_version: 1
---

# Deep links

## Коротко

Разбирайте входящую ссылку по allowlist маршрутов. Обычная навигация и OAuth callback имеют разные условия: только callback связывается с начатой авторизационной операцией и ее защитными параметрами.

## Плохо

```text
Любая ссылка с параметром code -> сохранить его как сессию.
Проверка: URL содержит строку trusted.example.
Одна ссылка на создание заказа обработана и getInitialURL, и listener.
```

## Хорошо

```text
https://app.example/orders/42:
  точный scheme/host/path -> проверенный ID -> навигация;
  данные заказа и право чтения подтверждает сервер.
https://app.example/oauth/callback?code=...&state=...:
  точный redirect URI -> активная непросроченная операция;
  state соответствует операции, code обменивается с PKCE;
  результат принят один раз, секретные параметры не журналируются.
Холодный запуск и url event проходят один и тот же диспетчер.
```

## Почему

Подтверждение домена уменьшает риск перехвата ссылки другим приложением, но не делает ее параметры доверенными. Повтор доставки ссылки и два пути ее получения не должны повторять бизнес-операцию.

## Когда применять

React Native на iOS/Android, с выбранным роутером и native linking-настройками. Поддержите `Linking.getInitialURL()` для холодного старта и событие `url` для уже запущенного приложения; учитывайте готовность навигации и удаляйте listener при завершении его жизненного цикла.

Для Universal Links/App Links проверяется связь домена и подписанного приложения: iOS associated domains + apple-app-site-association, Android assetlinks.json и проверка домена. Custom scheme доступен и другим приложениям, поэтому не считайте его доказательством владельца.

Используйте URL-parser, точный allowlist scheme/host/path, ожидаемый тип ID и правила query. Не принимайте substring-проверку домена, неожиданный userinfo, двойное декодирование или дублирующиеся security-параметры. Обычной ссылке на экран не нужен OAuth state; вход в приложение для приватного экрана следует из его модели доступа.

OAuth для native public client использует внешний user-agent и PKCE по RFC 8252. Для выбранного профиля callback также связан с одноразовым локальным state, redirect URI и временем операции; code не является токеном сессии. Не допускайте повторного обмена/эффекта по уже завершенной операции. Срок state и способ безопасного восстановления после перезапуска определяет auth-библиотека и приложение.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Корректная обычная ссылка при холодном и теплом запуске | Один ожидаемый экран; запрос доступа проверяет сервер | Device-тесты обеих платформ |
| Чужой host, suffix-домен, неправильный путь/ID или дублированный state | Ссылка отклонена до чувствительного действия | Таблица URL и счетчик действий |
| OAuth callback с чужим/истекшим state или неверным PKCE | Сессия не создается | Тест auth-flow и ответа token endpoint |
| Один callback доставлен повторно и через оба входа | Операция завершается один раз; повтор безопасно игнорируется | Журнал operation ID без code/token |
| Домен не прошел платформенную проверку | Нет ложного заявления о verified link; безопасный fallback | Результат native domain verification |

Unit-тест URL-parser не заменяет проверку связки домен, подпись приложения и native entry point.

## Человек

Утверждает разрешенные ссылки, auth-flow и поведение для уже выполненной операции.

## Агент

Отделяет навигацию от авторизации, проверяет оба пути Linking и платформенное подтверждение домена.

## Источники

- [React Native: Linking](https://reactnative.dev/docs/linking)
- [RFC 8252: native OAuth](https://www.rfc-editor.org/rfc/rfc8252)
- [Android: verify App Links](https://developer.android.com/training/app-links/verify-applinks)
- [Apple: associated domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains)
