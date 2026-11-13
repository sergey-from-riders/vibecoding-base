---
schema_version: 1
id: "frameworks.bitrix-autoload"
title: "1С-Битрикс: namespace, загрузка классов и обработчики"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["1С-Битрикс", "PHP"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1204
related: ["frameworks.bitrix-local", "frameworks.bitrix-scheduling", "languages.php-autoload"]
sources: ["https://docs.1c-bitrix.ru/pages/framework/autoloading.html", "https://dev.1c-bitrix.ru/api_d7/bitrix/main/loader/registerautoloadclasses.php", "https://docs.1c-bitrix.ru/pages/framework/events.html", "https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33876&LESSON_PATH=3913.33876"]
---

# 1С-Битрикс: namespace, загрузка классов и обработчики

## Коротко

Собственные классы помещайте в уникальный namespace и загружайте через выбранный Loader/Composer-контракт. init.php регистрирует подключение и обработчики; он не должен выполнять бизнес-операцию на каждом запросе.

## Плохо

```php
// init.php
require $_SERVER['DOCUMENT_ROOT'] . '/local/classes/Order.php';
sendAllReminders(); // Выполняется при любом HTTP/CLI bootstrap.
// Класс Order конфликтует с другим решением в глобальном namespace.
```

## Хорошо

```php
<?php
// /local/php_interface/init.php
if (!defined('B_PROLOG_INCLUDED') || B_PROLOG_INCLUDED !== true) {
    return;
}

\Bitrix\Main\Loader::registerAutoLoadClasses(null, [
    'Project\Site\Event\ImportHandler' => __DIR__ . '/lib/Event/ImportHandler.php',
]);
\Bitrix\Main\EventManager::getInstance()->addEventHandler(
    'project.site',
    'AfterImported',
    ['Project\Site\Event\ImportHandler', 'handle']
);
// public static function handle(\Bitrix\Main\Event $event): void
// реализован в указанном файле класса.
```

## Почему

Уникальное полное имя отделяет код проекта от ядра и других решений. Регистрация до первого вызова делает загрузку воспроизводимой в HTTP и CLI. Побочный эффект в init.php запускается в неподходящих контекстах и осложняет диагностику.

## Когда применять

Bitrix Framework/D7. Пример — проектный класс вне устанавливаемого модуля: `registerAutoLoadClasses(null, ...)` использует явный абсолютный путь, доступный до первого события. Файл содержит namespace `Project\Site\Event` и класс `ImportHandler`. Событие `project.site/AfterImported` — собственное D7-событие приложения, не встроенное событие Bitrix.

Для установленного модуля `project.site` в `/local/modules/project.site` сначала проверяйте `Loader::includeModule('project.site')`. Модуль регистрирует свой namespace для lib и при наличии выполняет include.php; один `use Project\Site\...` модуль не подключает. `registerNamespace` применим к собственному пространству/пути. Не регистрируйте одинаковый класс в конкурирующих загрузчиках.

Текущий справочник Loader описывает сохранение регистра namespace и fallback к полностью lowercase-пути. В legacy-версиях соглашения и поиск отличались: проверьте установленный main на case-sensitive системе; не переносите механически PSR-4/Composer-регистр на старый lib. Явная classmap полезна при адаптации, но не требует включать Composer всему проекту.

`addEventHandler` регистрирует callback на время запроса. Постоянные связи модулей регистрируйте при установке и удаляйте при удалении; не записывайте такую регистрацию в БД на каждом хите. Для классического события выбирайте совместимый вариант API и сигнатуру аргументов, а не автоматически `Event`. init.php загружается до авторизации пользователя; действия, которым нужен пользователь, выполняются в подходящем более позднем контексте.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Событие приходит после HTTP и CLI bootstrap | Нужный класс загружен, handle вызван один раз | Две точки входа и счетчик вызовов |
| Нет модуля или неверный регистр пути на Linux | Управляемый отказ до бизнес-операции | Проверка includeModule и пути |
| Простой запрос без целевого события | Импорт/рассылка не запускаются из init.php | Журнал побочных эффектов |
| Установка, повторная установка и удаление модуля | Нет дубликатов/осиротевших постоянных handlers | Реестр событий и функциональная проба |
| Подключено классическое событие | Сигнатура и режим совместимости соответствуют документации события | Негативный/положительный вызов |

Синтаксическая проверка PHP не подтверждает реальную регистрацию Bitrix или порядок bootstrap.

## Человек

Выбирает модульную или проектную форму расширения и жизненный цикл обработчика.

## Агент

Проверяет версию Loader, namespace, путь, тип события и место регистрации. Не превращает init.php в сценарий выполнения.

## Источники

- [Bitrix: autoloading](https://docs.1c-bitrix.ru/pages/framework/autoloading.html)
- [Bitrix D7: registerAutoLoadClasses](https://dev.1c-bitrix.ru/api_d7/bitrix/main/loader/registerautoloadclasses.php)
- [Bitrix: events](https://docs.1c-bitrix.ru/pages/framework/events.html)
- [Bitrix: request bootstrap](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33876&LESSON_PATH=3913.33876)
