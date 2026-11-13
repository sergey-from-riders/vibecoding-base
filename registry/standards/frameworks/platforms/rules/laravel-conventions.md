---
schema_version: 1
id: "frameworks.laravel-conventions"
title: "Laravel: начальная структура и регистрация кода"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["Laravel 12", "PHP"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1206
related: ["languages.php-autoload", "frameworks.laravel-validation", "frameworks.laravel-jobs"]
sources: ["https://laravel.com/docs/12.x/structure", "https://laravel.com/docs/12.x/container", "https://laravel.com/docs/12.x/configuration"]
---

# Laravel: начальная структура и регистрация кода

## Коротко

Начинайте новый Laravel-модуль с принятых в проекте путей, PSR namespace и штатных точек регистрации. Контроллер получает зависимости через container, вход проходит Request/Policy, а представление не запускает бизнес-операцию.

## Плохо

```text
Логика заказа добавлена в vendor/laravel/framework.
routes/web.php содержит глобальные функции и ручные require всех классов.
Blade-шаблон напрямую создает заказ и отправляет письмо.
Для одного endpoint заранее созданы пустые Repository/Service/Manager/Factory.
```

## Хорошо

```text
app/Http/Controllers/OrderController.php  App\Http\Controllers\OrderController
app/Http/Requests/StoreOrderRequest.php   App\Http\Requests\StoreOrderRequest
app/Models/Order.php                     App\Models\Order
app/Policies/OrderPolicy.php             App\Policies\OrderPolicy
app/Jobs/SendReceipt.php                 App\Jobs\SendReceipt
routes/web.php                          маршруты браузерного сценария
resources/views/orders/show.blade.php    отображение переданных данных
tests/Feature/OrdersTest.php             проверка маршрута и записи
Сервис/Action добавляется, когда у операции появляется собственная граница.
```

## Почему

Штатная структура позволяет Laravel обнаруживать и загружать код предсказуемо. Необходимые границы определяются поведением: общий случай не требует обязательных дополнительных слоев поверх Eloquent.

## Когда применять

Laravel 12.x; версия PHP и Composer определяются выбранной версией framework. В примере действует стандартная PSR-4 карта `App\` -> `app/`. Классы — StudlyCaps, методы — camelCase; имена SQL-таблиц и URL следуют своему контракту и не обязаны копировать имя класса.

Директории Laravel — исходное соглашение, а не запрет иной архитектуры: framework допускает другую организацию при правильной автозагрузке и регистрации. У interface binding должно быть явное место в service provider; concrete-класс может разрешаться container без искусственного интерфейса.

В новых Laravel 12 приложениях маршрутизация/middleware задаются через штатный bootstrap, providers — через соответствующий список приложения. Не переносите инструкции про старый Http Kernel или providers из другой major-версии без сверки. API-маршруты и auth-стек подключаются по выбранному профилю, не предполагаются автоматически.

Environment читается в конфигурации, приложение использует config; проверьте поведение config cache. Не помещайте секреты в Blade или клиентскую конфигурацию. Миграции и lock-файл приложения входят в его воспроизводимую поставку; этот репозиторий содержит только описание.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Новый маршрут и controller в чистой установке | Класс загружается, dependency разрешается, маршрут доступен | route:list и HTTP smoke |
| Interface без binding или неверный регистр класса | Ошибка обнаружена при проверке проекта | Container/production install test |
| Конфигурация закеширована | Endpoint использует правильные значения, без чтения env из бизнес-кода | Тест config cache |
| Рендер страницы и повторный GET | Нет записи/отправки из шаблона | Счетчики побочных эффектов |

Иная архитектура допустима при документированных путях и тех же проверяемых границах.

## Человек

Выбирает профиль web/API и разумную границу операции, не навязывая слои без задачи.

## Агент

Сверяет версию bootstrap и PSR-4, добавляет только необходимые классы и проверяет реальный маршрут.

## Источники

- [Laravel 12: directory structure](https://laravel.com/docs/12.x/structure)
- [Laravel 12: service container](https://laravel.com/docs/12.x/container)
- [Laravel 12: configuration](https://laravel.com/docs/12.x/configuration)
