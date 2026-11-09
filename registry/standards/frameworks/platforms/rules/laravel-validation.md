---
schema_version: 1
id: "frameworks.laravel-validation"
title: "Laravel: Form Request и Policy"
section: "frameworks"
level: "recommended"
tags: ["laravel-validation", "Laravel", "PHP"]
technologies: ["Laravel", "PHP"]
reviewed_at: "2026-11-09"
order: 102
related: ["security.object-access", "testing.integration"]
sources: ["https://laravel.com/docs/12.x/validation", "https://laravel.com/docs/12.x/authorization"]
---

# Laravel: Form Request и Policy

## Коротко

Валидируйте вход и отдельно проверяйте право на объект. В модель передавайте только разрешённые поля.

## Плохо

```php
$order->update($request->all());
```

## Хорошо

```php
// Контроллер: UpdateOrderRequest проверяет title
Gate::authorize('update', $order);
$order->update($request->safe()->only(['title']));
```

## Почему

Проверка формата не даёт права редактировать чужой заказ. Поля вроде owner_id нельзя принимать из произвольного тела запроса.

## Когда применять

Laravel 12.x, Form Request и зарегистрированная Policy; в модели настроен `$fillable`. Входящий DTO не заменяет объектную авторизацию.

## Человек

Определяет права ролей и редактируемые поля заказа.

## Агент

Создаёт Form Request, Policy и тесты запрещённых полей/чужих объектов.

## Пример применения

В кабинете клиент меняет название своего заказа. `UpdateOrderRequest` проверяет строку title, Policy сопоставляет владельца с текущим пользователем, контроллер записывает только title.

## Как проверить

- Чужой заказ даёт отказ.
- Лишние owner_id и is_paid не меняют запись.

## Источники

- [Validation](https://laravel.com/docs/12.x/validation)
- [Authorization](https://laravel.com/docs/12.x/authorization)
