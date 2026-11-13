---
schema_version: 1
id: "languages.php-autoload"
title: "PHP: namespace, PSR-4 и автозагрузка"
section: "languages"
level: "recommended"
tags: ["languages", "conventions"]
technologies: ["PHP", "Composer"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1203
related: ["languages.php-naming", "frameworks.bitrix-autoload"]
sources: ["https://www.php-fig.org/psr/psr-4/", "https://getcomposer.org/doc/04-schema.md#autoload", "https://www.php.net/manual/en/language.oop5.autoload.php"]
---

# PHP: namespace, PSR-4 и автозагрузка

## Коротко

Свяжите namespace с путями через явную конфигурацию загрузчика. Для нового Composer-пакета предпочитайте PSR-4 и точное совпадение регистра; use импортирует имя, а не файл.

## Плохо

```text
Класс Acme\Billing\Invoice лежит в src/invoice.php.
use Acme\Billing\Invoice считается подключением файла.
В каждом endpoint вручную требуют разные копии Invoice.php.
```

## Хорошо

```json
{
  "autoload": {
    "psr-4": {
      "Acme\\Billing\\": "src/"
    }
  }
}
```

## Почему

Единая карта загрузки убирает зависимость от порядка ручных require. Ошибка регистра может оставаться незаметной на рабочей машине и проявиться на Linux. Namespace сам по себе не создает автозагрузку.

## Когда применять

Composer 2 и новый PHP-пакет с PSR-4. При показанной карте `Acme\Billing\Invoice` объявляется в `src/Invoice.php`, а `Acme\Billing\Service\InvoiceSender` — в `src/Service/InvoiceSender.php`. Префикс заканчивается обратным слешем; путь считается от корня пакета. Каждый сегмент пути и имя класса согласованы по регистру.

Bootstrap подключает сгенерированный `vendor/autoload.php` один раз. После изменения конфигурации/оптимизированной classmap пересоберите autoload штатной командой Composer; файлы vendor не редактируют вручную. Классы тестов размещают в autoload-dev, чтобы production-код не зависел от dev-пакетов.

PSR-4 относится к классоподобным сущностям и не автозагружает произвольную функцию по `use function`. Для функций/legacy доступны явно выбранные files/classmap или платформенный loader; их side effects должны быть понятны.

Bitrix Loader и WordPress bootstrap — другие контексты. Не утверждайте, что старый D7 с lowercase lib полностью совпадает с PSR-4, и не добавляйте параллельный loader для тех же классов без необходимости. Переезд имени/пути публичного класса требует плана совместимости.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Чистая установка production-зависимостей, первый вызов Invoice | Класс найден без ручных require | Проверка в case-sensitive файловой системе |
| Файл назван invoice.php вместо Invoice.php | Несоответствие обнаружено до выпуска | Проверка карты и сборки |
| Изменен namespace prefix или optimized classmap | После штатной пересборки все точки входа видят один класс | Smoke-тест HTTP/CLI/worker |
| Production-класс ссылается на autoload-dev | Проверка --no-dev выявляет нарушение | Запуск с production-зависимостями |

JSON примера является фрагментом composer.json приложения, а не исполняемым файлом этого репозитория стандартов.

## Человек

Определяет границу пакета и допустимый переход legacy-имен.

## Агент

Сверяет prefix, namespace, регистр и bootstrap на всех точках входа. Не считает use механизмом загрузки.

## Источники

- [PHP-FIG: PSR-4](https://www.php-fig.org/psr/psr-4/)
- [Composer: schema autoload](https://getcomposer.org/doc/04-schema.md#autoload)
- [PHP: autoloading classes](https://www.php.net/manual/en/language.oop5.autoload.php)
