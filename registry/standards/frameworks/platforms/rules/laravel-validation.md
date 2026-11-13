---
schema_version: 1
id: "frameworks.laravel-validation"
title: "Laravel: Form Request и Policy"
section: "frameworks"
level: "recommended"
tags: ["laravel-validation", "Laravel", "PHP"]
technologies: ["Laravel", "PHP"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 102
related: ["security.object-access", "testing.integration"]
sources: ["https://laravel.com/docs/12.x/validation", "https://laravel.com/docs/12.x/authorization"]
---

# Laravel: Form Request и Policy

## Коротко

Для записи разделяйте проверку формы, право на конкретную модель и список изменяемых полей. Для частичного обновления отсутствие поля сохраняет старое значение; null разрешается только отдельным правилом контракта.

## Плохо

```php
// Любое присланное поле, включая owner_id, попадает в update.
$order->update($request->all());
```

## Хорошо

```php
<?php
// app/Http/Requests/UpdateOrderRequest.php
namespace App\Http\Requests;

use App\Models\Order;
use Illuminate\Foundation\Http\FormRequest;

final class UpdateOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        $order = $this->route('order');
        return $order instanceof Order
            && ($this->user()?->can('update', $order) ?? false);
    }

    public function rules(): array
    {
        return ['title' => ['sometimes', 'required', 'string', 'max:200']];
    }
}
// В методе контроллера update(UpdateOrderRequest $request, Order $order):
// $order->update($request->safe()->only(['title']));
// return response()->noContent();
```

## Почему

Form Request отклоняет неподходящий ввод до выполнения контроллера; Policy решает, разрешено ли пользователю менять именно этот заказ. Ни валидный JSON, ни наличие модели, ни ее fillable сами по себе не подтверждают право доступа.

## Когда применять

Laravel 12.x, PHP 8.2+, JSON PATCH `/orders/{order}`. В маршруте включены выбранный проектом auth middleware и implicit binding параметра `order` на `Order`. `OrderPolicy` зарегистрирована через обнаружение по соглашению либо `Gate::policy(Order::class, OrderPolicy::class)`; ее `update` проверяет право на объект. В `Order` разрешено mass assignment поля `title`. Это необходимые условия примера, а не скрытая функциональность DTO.

В данном контракте отсутствие `title` означает «не менять», `null` и пустая строка запрещены. Для POST создания используйте `required` без `sometimes`. Разрешение очистки поля требует `nullable` и отдельного решения. Стандартные middleware могут обрезать пробелы и преобразовать пустую строку в null; проверьте их фактический состав.

`safe()->only(...)` исключает посторонние поля из записи, но не обещает отклонить весь запрос с лишним полем. Если API требует строгую схему, добавьте отдельное правило отказа. Ошибки формата и схемы не подменяют аутентификацию.

## Как проверить

Отправляйте запросы через реальный маршрут с `Accept: application/json`, а не вызывайте Policy изолированно.

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Владелец меняет title на строку длиной до 200 | 204, изменен только title | HTTP-ответ и перечитанная запись |
| Владелец отправляет пустой PATCH; затем title=null и title="" | Пустой PATCH сохраняет title; оба недопустимых значения дают 422 | Снимки записи, JSON ошибок |
| Другой пользователь меняет существующий заказ | 403; при принятой политике сокрытия допустим согласованный 404 | Ответ и отсутствие записи в журнале изменений |
| Нет сессии; затем подставлен чужой owner_id | Auth middleware дает 401 для JSON; owner_id никогда не меняется | Интеграционный тест маршрута и БД |

Формат 401/403/404/422 и обработчик исключений сверяются с контрактом API проекта; пример не вводит собственный формат ошибок.

## Человек

Утверждает семантику PATCH/null, допустимые поля и политику сокрытия чужих объектов.

## Агент

Показывает маршрут, регистрацию Policy и правила формы вместе с проверкой записи. Не считает unit-тест Policy доказательством защищенности маршрута.

## Источники

- [Laravel 12: Form Request, optional fields и validated input](https://laravel.com/docs/12.x/validation)
- [Laravel 12: регистрация и применение Policy](https://laravel.com/docs/12.x/authorization)
