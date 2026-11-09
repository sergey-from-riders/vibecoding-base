---
schema_version: 1
id: "frameworks.laravel-eloquent"
title: "Laravel: Eloquent и N+1"
section: "frameworks"
level: "recommended"
tags: ["laravel-eloquent", "Laravel", "PHP"]
technologies: ["Laravel", "PHP"]
reviewed_at: "2026-11-09"
order: 104
related: ["database.indexes", "api.pagination"]
sources: ["https://laravel.com/docs/12.x/eloquent-relationships#eager-loading", "https://laravel.com/docs/12.x/pagination"]
---

# Laravel: Eloquent и N+1

## Коротко

Загружайте нужные связи списком и ограничивайте размер выдачи.

## Плохо

```php
foreach (Order::all() as $order) {
  echo $order->customer->name;
}
```

## Хорошо

```php
$orders = Order::with('customer')->paginate(30);
foreach ($orders as $order) {
  echo e($order->customer->name);
}
```

## Почему

Ленивая загрузка связи внутри цикла может добавлять запрос на каждую запись.

## Когда применять

Laravel 12.x; связь customer объявлена и обязательна. Фильтр доступа к заказам добавляется до paginate. Не загружайте все связи без необходимости.

## Человек

Выбирает нужные колонки и размер страницы.

## Агент

Добавляет eager loading, измеряет SQL-запросы на нескольких размерах выборки.

## Пример применения

Экран менеджера показывает 30 заказов и имена клиентов. Основная выборка и выборка клиентов выполняются отдельно, без 30 дополнительных запросов.

## Как проверить

- Количество SQL-запросов не растёт линейно с количеством строк.
- Пагинация и фильтр доступа проверены.

## Источники

- [Eloquent: Relationships](https://laravel.com/docs/12.x/eloquent-relationships#eager-loading)
- [Database: Pagination](https://laravel.com/docs/12.x/pagination)
