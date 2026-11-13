---
schema_version: 1
id: "languages.php-naming"
title: "PHP: именование и границы PSR-1"
section: "languages"
level: "recommended"
tags: ["languages", "conventions"]
technologies: ["PHP"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1202
related: ["languages.php-types", "languages.php-autoload", "frameworks.wordpress-conventions"]
sources: ["https://www.php-fig.org/psr/psr-1/", "https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/"]
---

# PHP: именование и границы PSR-1

## Коротко

Для нового PHP-пакета выберите именование и применяйте его последовательно. PSR-1 задает имена классов, методов и констант, но это соглашение совместимости, а не синтаксическое требование PHP.

## Плохо

```php
namespace Project\Order;
class order_service {
    public const retryLimit = 3;
    public function Get_order($Order_ID) { /* ... */ }
}
```

## Хорошо

```php
<?php
namespace Project\Order;

final class OrderService
{
    public const RETRY_LIMIT = 3;

    public function formatOrderId(int $orderId): string
    {
        return 'order-' . $orderId;
    }
}
```

## Почему

Предсказуемое имя помогает искать определение и отличать класс от метода или константы. Единый стиль облегчает автозагрузку и чтение, но массовое переименование публичного API может сломать пользователей без изменения поведения.

## Когда применять

Новый код, для которого проект принял PSR-1: классы `StudlyCaps`, методы `camelCase`, константы класса `UPPER_SNAKE_CASE`. Для переменных и свойств пример выбирает `camelCase` как соглашение проекта: PSR-1 намеренно не навязывает стиль свойств.

Имена отражают назначение: `OrderService` и `formatOrderId`, а не случайные сокращения. Уточняйте единицы и смысл там, где они важны, например `timeoutSeconds`. Выбор английских идентификаторов и доменных терминов фиксируется командой; это не ограничение языка.

Для WordPress применяйте его coding standards и префиксы/namespace плагина. В Bitrix сохраняйте контрактные имена классического API, установщика, событий и существующих расширений. Новый изолированный PSR-пакет может жить рядом с legacy через адаптер; глобальное переименование старых hooks или методов из этого правила не следует.

Файл объявления класса не должен сам выводить HTML, создавать соединение или запускать импорт. Bootstrap платформы и исполняемая точка входа отделяются от объявления; PSR-1 формулирует это как SHOULD, а шаблон с PHP/HTML имеет другой контекст.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Новый класс/метод/константа в PSR-пакете | Соответствуют принятому стилю и назначению | Diff и настроенный ruleset приложения |
| Свойство camelCase, которое анализатор ошибочно считает не-PSR | Нет ложного требования от PSR-1; применяется локальное соглашение | Конфигурация проверки |
| Адаптер к legacy hook/классу WordPress или Bitrix | Контрактное имя сохранено | Интеграционный вызов |
| Autoload класса без вызова методов | Нет вывода и внешнего I/O | Проверка подключения файла |

Стиль не измеряется числом исправленных имен; публичные переименования требуют отдельной миграции.

## Человек

Выбирает стандарт именования по границам пакета и владеет словарем домена.

## Агент

Не выдает предпочтения проекта за требования PHP/PSR; сохраняет публичные legacy-имена.

## Источники

- [PHP-FIG: PSR-1](https://www.php-fig.org/psr/psr-1/)
- [WordPress: PHP coding standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/)
