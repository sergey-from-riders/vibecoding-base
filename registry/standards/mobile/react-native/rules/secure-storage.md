---
id: "mobile.secure-storage"
title: "Keychain и Keystore"
section: "mobile"
level: "required"
tags: ["secure-storage", "React Native"]
technologies: ["React Native"]
reviewed_at: "2026-11-09"
order: 92
related: ["mobile.deep-links", "mobile.offline"]
sources: ["https://reactnative.dev/docs/security", "https://developer.android.com/privacy-and-security/keystore"]
schema_version: 1
---

# Keychain и Keystore

## Коротко

Обычное локальное хранилище приложения не подходит для секретов.

## Плохо

```text
Токен в AsyncStorage и диагностическом логе.
```

## Хорошо

```text
iOS: токен в Keychain.
Android: токен зашифрован, ключ находится в Keystore.
Библиотека поддерживает эту схему и очистку при выходе.
```

## Почему

Файл приложения и резервные копии могут раскрыть открытый текст токена.

## Когда применять

Android Keystore хранит криптографические ключи, а не произвольный текст токена. Для React Native выбирайте поддерживаемую библиотеку с документированной реализацией для каждой платформы. Защищённое хранилище не заменяет срок действия и отзыв токена на сервере. Биометрия обычно разблокирует локальный доступ.

## Как проверить

- Выход удаляет локальный секрет и отзывает нужную сессию?

## Человек

Определяет срок сессии, выход из аккаунта и политику устройств.

## Агент

Реализует поведение клиента и проверяет потерю сети, повторный запуск и ограничения платформы.

Контроль результата:

- Выход удаляет локальный секрет и отзывает нужную сессию?

## Источники

- [Security · React Native](https://reactnative.dev/docs/security)
- [Android Keystore system  |  Security  |  Android Developers](https://developer.android.com/privacy-and-security/keystore)
