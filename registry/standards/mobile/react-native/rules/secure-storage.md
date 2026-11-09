---
id: "mobile.secure-storage"
title: "Храните токены в защищённом хранилище платформы"
section: "mobile"
level: "required"
tags: ["secure-storage", "React Native"]
technologies: ["React Native"]
reviewed_at: "2026-11-09"
order: 92
related: ["mobile.deep-links", "mobile.offline"]
sources: ["https://reactnative.dev/docs/security"]
schema_version: 1
---

# Храните токены в защищённом хранилище платформы

## Коротко

Обычное локальное хранилище приложения не подходит для секретов.

## Плохо

```text
Токен в AsyncStorage и диагностическом логе.
```

## Хорошо

```text
Токен в Keychain/Keystore через проверенную библиотеку.
```

## Почему

Файл приложения и резервные копии могут раскрыть открытый текст токена.

## Когда применять

Защищённое хранилище не заменяет срок действия и отзыв токена на сервере. Биометрия обычно разблокирует локальный доступ.

## Как проверить

- Выход удаляет локальный секрет и отзывает нужную сессию?

## Источники

- [Первоисточник](https://reactnative.dev/docs/security)
