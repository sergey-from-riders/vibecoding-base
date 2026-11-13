# Начальные требования языков и фреймворков

Редакция от 13 ноября 2026 года. Карта охватывает языки и платформы, представленные в корпусе. Она служит маршрутом чтения; полный нормативный текст находится в связанных правилах. Наличие краткого профиля не означает полного покрытия языка или безопасности приложения.

## Имена и регистр

| Язык / область | Типы и классы | Функции, методы, переменные | Константы | Модули и исключения |
| --- | --- | --- | --- | --- |
| Python | `ReportBuilder` — PascalCase / CapWords | `build_report`, `user_id` — snake_case | `MAX_ROWS` — UPPER_SNAKE_CASE для констант модуля | `report_builder.py`; короткие lowercase package names; `self`, `cls`, `_internal`; обязательные callback/API names сохраняются |
| Go | `Invoice` либо `invoice` в зависимости от экспорта | `NewInvoice`, `newInvoice`, `userID`; MixedCaps/mixedCaps | `MaxItems` либо `maxItems`, по тем же правилам экспорта | Короткий lowercase package; `ID`, `HTTP`, `URL` сохраняют согласованный регистр; заглавная первая буква меняет API |
| JavaScript / TypeScript | `Invoice`, `InvoiceSummary` — PascalCase | `formatInvoice`, `invoiceId` — camelCase | UPPER_SNAKE_CASE только для выбранных стабильных значений уровня модуля; обычный `const invoice` остается camelCase | Имена файлов и экспортов по соглашению/фреймворку; `const` не означает глубокую неизменяемость объекта |
| PHP с принятым PSR-профилем | `OrderService` — StudlyCaps | Методы `formatOrderId`; переменные/свойства camelCase по локальному соглашению | `RETRY_LIMIT` для константы класса | PSR-1 не задает единственный регистр свойств и свободных функций; namespace и PSR-4 проверяются отдельно |
| SQL / PostgreSQL | Объекты схемы по принятому словарю | `order_items`, `created_at`, `customer_id` — выбранный snake_case | Не переносить правила констант Python на SQL | Регистр SQL keywords — оформление; quoted identifiers и регистр имеют семантику PostgreSQL |

Основания и границы: [Python naming](../registry/standards/languages/python/rules/python-naming.md), [Go naming](../registry/standards/languages/go/rules/go-naming.md), [JS/TS naming](../registry/standards/languages/typescript/rules/javascript-naming.md), [const/let](../registry/standards/languages/typescript/rules/bindings.md), [PHP naming](../registry/standards/languages/php/rules/php-naming.md), [PostgreSQL naming](../registry/standards/database/postgres/rules/naming.md). У каждой статьи есть первоисточники и проверяемые исключения.

Именование не меняет внешний JSON, таблицу, событие, публичный символ или callback без анализа совместимости. Автоматическое форматирование обычно не исправляет смысл имен и не заменяет naming review.

## Базовый маршрут языка

| Профиль | Что прочитать до реализации | Что проверить в приложении |
| --- | --- | --- |
| [Python](../registry/standards/languages/python/standard.md) | Имена, импорты, типы на границах, версии и инструменты | Импорт без побочных эффектов, runtime-валидация внешних данных, выбранный typechecker/linter и воспроизводимое окружение |
| [Go](../registry/standards/languages/go/standard.md) | Экспорт, пакеты/импорты, типы и zero values, toolchain | `gofmt`, компиляция потребителей, типизированный nil, корректные зависимости и выбранная версия |
| [JavaScript / TypeScript](../registry/standards/languages/typescript/standard.md) | Имена, const/let, null/undefined, внешние данные, Promise, модули | Typecheck не подменяет runtime-валидацию; необработанные Promise и различия окружений проверяются отдельно |
| [PHP](../registry/standards/languages/php/standard.md) | Имена, namespace/autoload, типы и внешние значения | Регистр файлов на целевой ОС, корректность автозагрузки, PHP-версия/расширения, отсутствие побочного вывода |
| [PostgreSQL](../registry/standards/database/postgres/standard.md) | Имена, ключи, constraints, типы времени/денег, транзакции и миграции | Целостность в БД, конкурентные запросы, блокировки, совместимость схемы и фактические планы запросов |

Команды, конфигурация анализаторов, зависимости и тесты находятся в приложении-потребителе. Корпус хранит описание требования и примеры в Markdown.

## Уточнения фреймворков

| Платформа | Начальное правило | Что нельзя подменять общим соглашением языка |
| --- | --- | --- |
| React | [Компоненты](../registry/standards/frontend/react/rules/component-naming.md), [Hooks](../registry/standards/frontend/react/rules/hooks.md) | PascalCase компонентов, контракт Hooks и стабильность определений |
| Next.js | [Файлы и маршруты](../registry/standards/frontend/next/rules/next-file-conventions.md) | Зарезервированные `page`, `layout`, `route` и границы server/client; App/Pages Router различаются |
| Laravel | [Структура и регистрация](../registry/standards/frameworks/platforms/rules/laravel-conventions.md) | Структура версии приложения, контейнер, конфигурация и Eloquent conventions |
| Django | [Приложения и инициализация](../registry/standards/frameworks/platforms/rules/django-conventions.md) | App labels, импорты, запуск приложения и миграции |
| FastAPI | [Routers, модели, ресурсы](../registry/standards/frameworks/platforms/rules/fastapi-conventions.md) | API-модели, router composition, lifecycle и зависимые ресурсы |
| NestJS | [Модули и DI](../registry/standards/frameworks/platforms/rules/nestjs-conventions.md) | Module/provider registration и runtime-метаданные |
| Vue | [SFC, props и события](../registry/standards/frameworks/platforms/rules/vue-conventions.md) | Имена компонентов, границы props/events и контекст шаблона |
| Nuxt | [Структура app/server](../registry/standards/frameworks/platforms/rules/nuxt-conventions.md) | Версия Nuxt, auto-import и server-only области |
| SvelteKit | [Маршруты и запрос](../registry/standards/frameworks/platforms/rules/sveltekit-conventions.md) | Специальные файлы маршрута и недопустимость общего пользовательского состояния |
| WordPress | [Плагины и hooks](../registry/standards/frameworks/platforms/rules/wordpress-conventions.md) | Собственные PHP coding standards WordPress, префиксы и контракт hooks |
| 1С-Битрикс | [local](../registry/standards/frameworks/platforms/rules/bitrix-local.md), [автозагрузка](../registry/standards/frameworks/platforms/rules/bitrix-autoload.md), [расписание](../registry/standards/frameworks/platforms/rules/bitrix-scheduling.md) | Поддерживаемые каталоги, версия Loader, legacy-классы, инициализация и цикл обновления модуля |
| React Native | [Платформенный профиль](../registry/standards/mobile/react-native/rules/react-native-conventions.md) | Native/API версии, платформенные файлы и поведение реальных устройств |

## Приемка нового проекта

До первой реализации зафиксируйте версии, выбранный стиль, границы пакетов, контракты внешних имен, способ проверки и допустимые исключения. Возьмите небольшую предметную сущность и проверьте ее импорт, использование потребителем, обработку неверного входа и работу на целевой платформе. Пустой scaffold и отсутствие ошибок форматтера не подтверждают соблюдение всего профиля.
