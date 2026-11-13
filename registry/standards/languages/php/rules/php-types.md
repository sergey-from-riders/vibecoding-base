---
schema_version: 1
id: "languages.php-types"
title: "PHP: типы и проверка входных значений"
section: "languages"
level: "recommended"
tags: ["languages", "conventions"]
technologies: ["PHP 8.2+"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1201
related: ["languages.php-naming", "languages.php-autoload"]
sources: ["https://www.php.net/manual/en/language.types.declarations.php", "https://www.php.net/manual/en/language.types.integer.php"]
---

# PHP: типы и проверка входных значений

## Коротко

В новом PHP-коде описывайте типы параметров, возврата и свойств, а на внешней границе отдельно проверяйте значение. strict_types и тип int не заменяют проверку положительного количества или допустимого ID.

## Плохо

```php
function quantity($value) {
    return (int) $value; // "12items" становится 12, null становится 0.
}
$count = quantity($request['quantity']);
```

## Хорошо

```php
<?php
declare(strict_types=1);

namespace Project\Order;

function requireQuantity(mixed $value): int
{
    if (!is_int($value) || $value < 1) {
        throw new \InvalidArgumentException('quantity must be a positive integer');
    }
    return $value;
}
// Для JSON-контракта: requireQuantity(3) -> 3.
// Строка "3", null, float и массив отвергаются без приведения.
```

## Почему

Native-типы ловят несоответствие формы данных, а доменная проверка ограничивает их смысл. Приведение до проверки может скрыть исходную ошибку. Nullable-тип разрешает null, но не говорит, что поле запроса можно не передавать.

## Когда применять

Baseline примера — PHP 8.2+, JSON quantity целого типа. `declare(strict_types=1)` включается по файлам для нового контролируемого кода; для скалярных аргументов режим определяется вызывающим файлом. Один strict-файл не переводит весь legacy-проект в строгий режим, а внутренние PHP-вызовы имеют свои особенности.

HTML/query обычно дают строки: если контракт их допускает, разбирайте их явно с проверкой формата, диапазона PHP_INT_MAX и нужных ограничений. Это иной адаптер, а не повод делать `mixed` во всей бизнес-логике. После адаптера используйте конкретный тип или небольшой объект значения.

Типы массивов PHP не проверяют форму каждого элемента; где нужна структура, добавьте DTO/валидацию и документируйте shape для анализатора. Не принимайте docblock за runtime validation. Выбирайте nullable/union по реальным исходам; не добавляйте `false|null|array` только ради сокрытия ошибок.

Сигнатуры переопределенных методов, hook/callback и публичного API меняйте с учетом совместимости. PHP-язык не требует PSR naming; WordPress и Bitrix legacy не обязаны автоматически получить новые сигнатуры.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| requireQuantity(3) | Возвращает int 3 | Unit-тест на baseline PHP |
| 0, -1, "3", "12items", null, 3.5, массив | Каждый отвергнут до бизнес-операции | Таблица случаев |
| Строковый HTTP-адаптер с числом больше PHP_INT_MAX | Явный отказ без переполнения/усечения | Граничный тест адаптера |
| Вызов typed-функции из strict и non-strict файлов | Зафиксировано различие coercion; политика не полагается на один callee-файл | Два отдельных файла теста |
| Изменена сигнатура legacy hook | Сохранен контракт всех вызывающих сторон | Проверка интеграции с платформой |

Эти сценарии предназначены приложению; PHP runtime в редакционной среде отсутствует.

## Человек

Утверждает входные форматы и политику совместимости legacy-кода.

## Агент

Разделяет типизацию и валидацию, сверяет минимальную версию PHP и вызывающую сторону strict_types.

## Источники

- [PHP: type declarations](https://www.php.net/manual/en/language.types.declarations.php)
- [PHP: integers](https://www.php.net/manual/en/language.types.integer.php)
