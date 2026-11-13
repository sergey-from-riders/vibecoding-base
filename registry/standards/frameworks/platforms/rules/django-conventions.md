---
schema_version: 1
id: "frameworks.django-conventions"
title: "Django: приложения, имена и безопасная инициализация"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["Django 5.2", "Python"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1207
related: ["frameworks.django-atomic", "backend.typed-boundaries"]
sources: ["https://docs.djangoproject.com/en/5.2/ref/applications/", "https://docs.djangoproject.com/en/5.2/intro/tutorial01/", "https://docs.djangoproject.com/en/5.2/topics/http/urls/"]
---

# Django: приложения, имена и безопасная инициализация

## Коротко

Оформляйте предметную область как Django application с устойчивым именем, URL namespace и миграциями. При импорте модулей и в AppConfig.ready не выполняйте бизнес-записи и запросы к БД.

## Плохо

```python
# orders/apps.py
from django.apps import AppConfig
from .models import Order

class OrdersConfig(AppConfig):
    name = "orders"
    def ready(self):
        Order.objects.filter(status="new").update(status="sent")
```

## Хорошо

```python
# orders/apps.py
from django.apps import AppConfig

class OrdersConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "orders"

# settings.py: INSTALLED_APPS содержит "orders.apps.OrdersConfig".
# orders/urls.py:
# app_name = "orders"
# urlpatterns = [path("<int:pk>/", views.detail, name="detail")]
# Миграции приложения хранятся в orders/migrations/.
```

## Почему

App registry и management commands инициализируют приложение в разных условиях, в том числе до миграций. Запрос или запись при startup может обращаться к неподготовленной БД и повторяться при каждом процессе.

## Когда применять

Django 5.2, Python-версия из поддерживаемого профиля проекта. Имена Python-пакетов и функций — snake_case, классов — CapWords по принятому Python-стилю. Это соглашения проекта/Python, а имена `models.py`, `apps.py` и AppConfig.name связаны с механизмами Django.

Разделяйте project configuration и приложения предметных областей; небольшой application не обязан иметь service/repository слой. `models` описывают данные, `views` — HTTP-адаптер, `urls` — маршруты, templates — представление. Если models разделены по файлам, их обнаружение и импорт остаются явными.

AppConfig.name — полный Python-путь, label должен быть уникальным и устойчивым: его изменение после миграций затрагивает ссылки Django. Не переименовывайте label как косметическую правку. Для URL используйте именованные маршруты и app_name там, где возможны совпадения.

В ready допустима регистрация signals при необходимости, но она должна быть безопасна к повторной инициализации; не используйте signal как невидимый универсальный слой бизнес-процесса. DB-операция выполняется в явном request/service/management command, а связанные записи подчиняются atomic-контракту.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Новая БД, check/migrate и запуск | Startup не требует уже созданных таблиц приложения | Лог чистой установки |
| Два приложения имеют detail route | reverse с namespace выбирает нужный URL | Тест маршрутизации |
| Повторная инициализация приложения/несколько worker | Нет повторных записей и дубликатов signals | Счетчик вызовов |
| Предложено переименование app label | Проверены зависимости миграций и обратная совместимость | План миграции, не массовая замена строки |

Проверка импорта Python без Django registry не доказывает корректную загрузку application.

## Человек

Определяет границы приложений и устойчивые имена, согласует изменения labels.

## Агент

Проверяет чистый startup, AppConfig и миграции. Не выполняет данные/внешние эффекты из ready или module import.

## Источники

- [Django 5.2: applications](https://docs.djangoproject.com/en/5.2/ref/applications/)
- [Django 5.2: first application](https://docs.djangoproject.com/en/5.2/intro/tutorial01/)
- [Django 5.2: URL namespaces](https://docs.djangoproject.com/en/5.2/topics/http/urls/)
