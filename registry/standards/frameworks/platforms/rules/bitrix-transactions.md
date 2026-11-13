---
schema_version: 1
id: "frameworks.bitrix-transactions"
title: "1С-Битрикс: D7-транзакции"
section: "frameworks"
level: "recommended"
tags: ["bitrix-transactions", "1С-Битрикс", "PHP"]
technologies: ["1С-Битрикс", "PHP"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 106
related: ["database.transactions", "caching.outbox"]
sources: ["https://dev.1c-bitrix.ru/api_d7/bitrix/main/db/connection/starttransaction.php", "https://dev.1c-bitrix.ru/api_d7/bitrix/main/result/issuccess.php", "https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33898&LESSON_PATH=3913.33898"]
---

# 1С-Битрикс: D7-транзакции

## Коротко

Связанные записи выполняйте в одной транзакции одного соединения, проверяя не только исключения, но и Result. Владелец транзакции отвечает за commit, rollback и неопределенный результат при потере соединения.

## Плохо

```php
$first->save();
$second->save(); // Result может содержать ошибку без исключения.
echo 'Сохранено';
```

## Хорошо

```php
$db = \Bitrix\Main\Application::getConnection();
// Обе ORM-сущности используют это соединение; внешней транзакции нет.
$db->startTransaction();
try {
    foreach ([$first, $second] as $entity) {
        $result = $entity->save();
        if (!$result->isSuccess()) {
            throw new \RuntimeException('Entity save failed');
        }
    }
    $db->commitTransaction();
} catch (\Throwable $error) {
    try {
        $db->rollbackTransaction();
    } catch (\Throwable $rollbackError) {
        // Обе ошибки сохраняет инфраструктурный журнал без входных данных.
        throw new \RuntimeException(
            'Rollback failed; transaction outcome requires reconciliation',
            0,
            $error
        );
    }
    throw $error;
}
```

## Почему

Транзакция защищает согласованность записей в поддерживающей ее БД. Ошибка Result не обязана прерывать выполнение сама. Письмо, HTTP-запрос или изменение файла не откатываются вместе с БД.

## Когда применять

D7: `startTransaction` документирован с main 14.0.0. Пример относится к ORM-объектам с `save(): Result` на одном соединении с транзакционными таблицами; имена сущностей, поля и БД определяет приложение. Он не открывает независимую транзакцию для каждого вложенного сервиса.

Для вложенности установите владельца и проверьте реализацию конкретного драйвера/main: наличие счетчика, savepoint и поведение при ошибке не выводятся из одного метода startTransaction. Вложенный helper не должен самовольно фиксировать внешнюю бизнес-операцию.

При ошибке commit из-за разрыва соединения нельзя по исключению заключить, что запись точно откатилась. Не выполняйте слепой повтор: сверяйте бизнес-идентификатор на новом соединении. Ошибка rollback требует отдельной диагностики и исключения поврежденного соединения из дальнейшей работы. Пример передает исходную ошибку как cause; инфраструктура должна отдельно записать и rollbackError.

Внешнее действие запускайте после подтвержденного commit; для обязательной доставки нужен транзакционный outbox. Обработчики ORM могут запускаться до commit, поэтому название события само по себе не доказывает безопасность отправки.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Обе save успешны, commit подтвержден | Обе записи видны другому соединению | Выборка после commit |
| Вторая save возвращает неуспешный Result без throw | Первая запись тоже отменена, ответ не сообщает успех | Fixture отказа Result и проверка БД |
| Исключение внутри вложенного сервиса | Внешний владелец видит ошибку; нет преждевременного commit | Проверка принятой схемы вложенности |
| Разрыв на commit или ошибка rollback | Результат не объявлен rollback/успехом без сверки; повтор защищен ключом операции | Журнал двух ошибок и сверка из нового соединения |

Сценарии исполняют на целевой СУБД и версии main. Мок метода save не подтверждает атомарность SQL или поведение драйвера.

## Человек

Определяет границы бизнес-транзакции и способ сверки неизвестного результата.

## Агент

Проверяет Result, соединения сущностей и побочные эффекты обработчиков. Не обещает откат внешнего сервиса или произвольной вложенной транзакции.

## Источники

- [Bitrix D7: startTransaction](https://dev.1c-bitrix.ru/api_d7/bitrix/main/db/connection/starttransaction.php)
- [Bitrix D7: Result::isSuccess](https://dev.1c-bitrix.ru/api_d7/bitrix/main/result/issuccess.php)
- [Bitrix: события и задачи](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33898&LESSON_PATH=3913.33898)
