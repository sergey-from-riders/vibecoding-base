---
schema_version: 1
id: "frameworks.bitrix-transactions"
title: "1С-Битрикс: D7-транзакции"
section: "frameworks"
level: "recommended"
tags: ["bitrix-transactions", "1С-Битрикс", "PHP"]
technologies: ["1С-Битрикс", "PHP"]
reviewed_at: "2026-11-09"
order: 106
related: ["database.transactions", "caching.outbox"]
sources: ["https://dev.1c-bitrix.ru/api_d7/bitrix/main/db/connection/starttransaction.php", "https://dev.1c-bitrix.ru/api_d7/bitrix/main/result/issuccess.php"]
---

# 1С-Битрикс: D7-транзакции

## Коротко

Связанные изменения БД фиксируйте одной транзакцией и проверяйте Result каждого вызова.

## Плохо

```php
$first->save();
$second->save(); // ошибка игнорируется
```

## Хорошо

```php
$db = \Bitrix\Main\Application::getConnection();
$db->startTransaction();
try {
  foreach ([$first, $second] as $entity) {
    $result = $entity->save();
    if (!$result->isSuccess()) {
      throw new \RuntimeException('Save failed');
    }
  }
  $db->commitTransaction();
} catch (\Throwable $e) {
  $db->rollbackTransaction();
  throw $e;
}
```

## Почему

Ошибка второго сохранения не должна оставлять первое изменение отдельно от общего результата.

## Когда применять

D7, API сущностей с save(): Result, одна транзакционная БД/соединение. Внешние вызовы и файлы не откатываются вместе с БД. Для конкретного модуля проверьте транзакционное поведение его событий.

## Человек

Определяет атомарную бизнес-операцию и побочные действия.

## Агент

Проверяет API модуля, добавляет транзакцию и воспроизводит частичный отказ.

## Пример применения

При обновлении двух связанных сущностей тест принудительно отклоняет вторую запись. После выполнения первая остаётся без изменений.

## Как проверить

- Ошибка второго сохранения откатывает первое.
- Ошибки Result не игнорируются.

## Источники

- [Connection::startTransaction](https://dev.1c-bitrix.ru/api_d7/bitrix/main/db/connection/starttransaction.php)
- [Result::isSuccess](https://dev.1c-bitrix.ru/api_d7/bitrix/main/result/issuccess.php)
