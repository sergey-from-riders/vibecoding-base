---
schema_version: 1
id: "frameworks.bitrix-cache"
title: "1С-Битрикс: ключ кеша и инвалидация"
section: "frameworks"
level: "recommended"
tags: ["bitrix-cache", "1С-Битрикс", "PHP", "Redis"]
technologies: ["1С-Битрикс", "PHP", "Redis"]
reviewed_at: "2026-11-09"
order: 107
related: ["caching.private-cache", "caching.freshness"]
sources: ["https://dev.1c-bitrix.ru/api_d7/bitrix/main/data/cache/index.php"]
---

# 1С-Битрикс: ключ кеша и инвалидация

## Коротко

Ключ кеша должен различать варианты данных, а изменение источника — очищать соответствующий кеш.

## Плохо

```php
$cacheId = 'orders'; // общий для всех пользователей
```

## Хорошо

```php
$cacheId = hash('sha256', json_encode([
  'v' => 1, 'user' => $userId,
  'filter' => $normalizedFilter,
  'permissions' => $permissionVersion,
], JSON_THROW_ON_ERROR));
```

## Почему

Общий ключ персональной выдачи может показать чужие данные. TTL ограничивает возраст, но не заменяет проверку прав.

## Когда применять

D7 Cache, PHP 7.3+ для JSON_THROW_ON_ERROR; в примере значения userId и permissionVersion получены на сервере после авторизации. При смене прав нужна инвалидация или смена версии. Публичные каталоги могут использовать общий кеш.

## Человек

Определяет приватность, допустимый TTL и события обновления.

## Агент

Формирует нормализованный ключ, настраивает Cache API и проверяет очистку после записи.

## Пример применения

Личный кабинет кеширует список заказов на 30 секунд. Сохранение заказа очищает кеш владельца; отзыв прав меняет permissionVersion. Выбор Redis как движка не меняет эти правила.

## Как проверить

- Два пользователя не получают общую персональную выдачу.
- Изменение данных и прав обновляет результат.

## Источники

- [Главный модуль:Cache](https://dev.1c-bitrix.ru/api_d7/bitrix/main/data/cache/index.php)
