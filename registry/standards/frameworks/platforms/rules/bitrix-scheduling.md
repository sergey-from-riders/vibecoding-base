---
schema_version: 1
id: "frameworks.bitrix-scheduling"
title: "1С-Битрикс: агенты, cron и безопасный CLI"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["1С-Битрикс", "PHP", "cron"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1205
related: ["frameworks.bitrix-local", "frameworks.bitrix-autoload", "caching.idempotent-worker"]
sources: ["https://docs.1c-bitrix.ru/pages/framework/background-jobs.html", "https://docs.1c-bitrix.ru/pages/framework/console-commands.html", "https://www.php.net/manual/en/reserved.constants.php", "https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33876&LESSON_PATH=3913.33876"]
---

# 1С-Битрикс: агенты, cron и безопасный CLI

## Коротко

Для задачи по времени явно выберите агента, агента на cron или отдельную CLI-команду. Расписание, повтор, блокировка и наблюдение задаются отдельно; открытый HTTP-скрипт с отключенной проверкой прав не является безопасным планировщиком.

## Плохо

```php
// Публичный /cron/import.php без проверки способа вызова.
define('NOT_CHECK_PERMISSIONS', true);
require $_SERVER['DOCUMENT_ROOT'] . '/bitrix/modules/main/include/prolog_before.php';
runImport($_GET['source']);
```

## Хорошо

```php
<?php
// /srv/jobs/project-import.php, вне document root.
if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}
$root = realpath('/srv/www/site'); // Доверенная конфигурация окружения.
if ($root === false) {
    throw new \RuntimeException('Site root is missing');
}
$_SERVER['DOCUMENT_ROOT'] = $root;
define('NO_KEEP_STATISTIC', true);
require $root . '/bitrix/modules/main/include/prolog_before.php';

if (!\Bitrix\Main\Loader::includeModule('project.site')) {
    throw new \RuntimeException('Required module is unavailable');
}
\Project\Site\Job\Import::run(); // Сервис с ограниченным batch и идемпотентностью.
\CMain::FinalActions();
```

## Почему

Агенты на посещениях зависят от трафика. Cron запускает процесс независимо, но не гарантирует успешное завершение, отсутствие наложения или однократный внешний эффект. Служебный HTTP endpoint добавляет нежелательный путь запуска с правами приложения.

## Когда применять

Коробочный Bitrix Framework с доступом к серверному планировщику. Пример — отдельная пользовательская CLI-задача с bootstrap ядра, не готовая замена системному cron_events.php. В установленном project.site реализован статический Job\Import::run(), который ограничивает batch и сообщает о сбое исключением, приводящим к ненулевому exit code CLI. PHP CLI должен иметь нужные расширения, ini, пользователя и доступы; site/tenant и параметры задачи передаются доверенно, без зависимости от браузерной сессии.

Короткий повторяющийся агент возвращает строку следующего вызова; пустая строка прекращает его работу. Код и параметры агента формируются приложением, не пользовательским вводом. Для тяжелой работы используйте ограниченные порции/очередь и отдельный worker или CLI-задачу.

Перенос системных агентов на cron выполняется по документации конкретного main/окружения. Настройка `agents_use_crontab=Y` разделяет периодические агенты на хитах и непериодические на стандартном cron; она не означает «все агенты уже на cron». Полный перенос имеет другой набор настроек. Исключите дублирующие задания и проверьте системные mail/backup-задачи; не копируйте константы BX_CRONTAB вслепую.

Для собственной команды при поддержке установленной версии допустим штатный `bitrix.php` и зарегистрированная console command; ему требуется настроенный Composer. Для отдельного bootstrap показан CLI-guard до пролога и путь вне web root. Не добавляйте `NOT_CHECK_PERMISSIONS` по привычке; доменные права и service identity определяются задачей.

Задайте лимит длительности/порции, предотвращение наложения (для нескольких узлов нужна общая координация), checkpoint и повторяемость, exit code и сигнал о пропущенном/зависшем запуске. Это свойства реализации задачи, не гарантии cron.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Нет посещений сайта, наступило расписание | Нужная задача выполнена в пределах согласованного окна | Cron/process log и бизнес-результат |
| Запуск длится дольше интервала, второй узел запускает повтор | Нет конфликтного наложения/двойного эффекта по принятой схеме | Конкурентный тест и lock/checkpoint |
| Попытка HTTP-доступа к служебному пути | Нет запуска; путь отсутствует в web root или закрыт | HTTP-тест и счетчик операций |
| Ошибка в середине batch и повтор CLI | Ненулевой exit code/сигнал; продолжение с безопасной границы | Журнал и состояние checkpoint |
| Перенос агентов на cron | Нет дубликатов, нужные типы агентов и системные задачи продолжают выполняться | Снимок настроек и результаты до/после |

Пролог может активировать проектные hooks; безопасный CLI-bootstrap проверяется с реальным init.php, а не только php -l.

## Человек

Выбирает механизм и окно исполнения, политику пропущенных запусков и учетную запись задачи.

## Агент

Инвентаризирует cron и настройки агентов, проверяет HTTP-изоляцию и отказные сценарии. Не называет background job или cron гарантированной доставкой.

## Источники

- [Bitrix: agents and background jobs](https://docs.1c-bitrix.ru/pages/framework/background-jobs.html)
- [Bitrix: console commands](https://docs.1c-bitrix.ru/pages/framework/console-commands.html)
- [PHP: PHP_SAPI](https://www.php.net/manual/en/reserved.constants.php)
- [Bitrix: request bootstrap](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33876&LESSON_PATH=3913.33876)
