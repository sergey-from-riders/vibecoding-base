# Python/FastAPI + React + PostgreSQL

Приложение с API на Python/FastAPI, интерфейсом React и PostgreSQL. HTTP-контракт описывается применимыми правилами OpenAPI.

Профиль `python-react-postgres` является читаемым перечнем требований. Он не генерирует приложение и не подтверждает готовность runtime. Состав перенесен из прежнего YAML-профиля и требует адаптации к задаче.

## Базовый набор

| Модуль | Назначение |
| --- | --- |
| [languages/python](../standards/languages/python/standard.md) | Начальные требования языка, именование, импорты, типы и инструменты |
| [languages/typescript](../standards/languages/typescript/standard.md) | JavaScript/TypeScript: имена, значения, модули и асинхронность |
| [collaboration/team](../standards/collaboration/team/standard.md) | Совместная разработка |
| [integrations/external](../standards/integrations/external/standard.md) | Внешние интеграции |
| [delivery/release](../standards/delivery/release/standard.md) | Выпуск и восстановление |
| [agent/base](../standards/agent/base/standard.md) | Работа агента |
| [framework/lifecycle](../standards/framework/lifecycle/standard.md) | Жизненный цикл проекта |
| [api/openapi-modular](../standards/api/openapi-modular/standard.md) | Контракты API и OpenAPI |
| [backend/python](../standards/backend/python/standard.md) | Backend на Python |
| [frontend/react](../standards/frontend/react/standard.md) | Frontend на React |
| [database/postgres](../standards/database/postgres/standard.md) | Данные и PostgreSQL |
| [testing/tdd-strict](../standards/testing/tdd-strict/standard.md) | Проверка качества |
| [security/no-secrets](../standards/security/no-secrets/standard.md) | Безопасность |
| [observability/three-signals](../standards/observability/three-signals/standard.md) | Наблюдаемость |

Исторические диапазоны базовых модулей были `^2.1.0`. Они не являются механизмом выбора текущих версий. Для работы зафиксируйте точный commit и перечень применимых ID.

## Дополнительные темы по условию

| Когда нужны | Модуль |
| --- | --- |
| Есть административный интерфейс | [Интерфейс административных систем](../standards/ui/admin-interface/standard.md) |
| Есть очередь, фоновые задачи или отложенные действия | [Фоновые задачи и очереди](../standards/backend/worker/standard.md) |
| Есть приложение React Native | [Мобильное приложение](../standards/mobile/react-native/standard.md) |
| Используется платежный провайдер Stripe | [Платежи и Stripe](../standards/payments/stripe/standard.md) |

Эти четыре дополнения сохраняют выбор прежнего профиля. Для административного интерфейса прежде указывался диапазон `^1.0.0`, для остальных — `^2.1.0`; это исторические сведения, не гарантия совместимости.

Дополнительно рассмотрите [публикации из Markdown](../standards/content/markdown/standard.md), если они есть в проекте, и [фреймворки / CMS](../standards/frameworks/platforms/standard.md), если используется соответствующая платформа. Эти ссылки расширяют навигацию и не включают отсутствующую технологию автоматически.

## Применение в проекте

1. Запишите фактические компоненты, критические сценарии и типы данных.
2. Прочитайте правила выбранных модулей и их зависимости. Уточните область применения, значения из примеров и приемку.
3. Составьте перечень применимых ID и исключений; зафиксируйте полный commit справочника.
4. Передайте человеку и агенту нужное подмножество, а затем соберите свидетельства выполнения.

Уровень каждого правила действует в его условиях. Если критерий не определен или проверка не выполнена, пометьте это явно. Профиль не заменяет анализ требований и безопасности.

[Как работать с профилями](../../docs/stack-profiles.md) · [Каталог](../../docs/catalog.md) · [Выход из прежнего CLI](../../docs/migration-to-docs-only.md).

Для публичного сайта дополнительно рассмотрите [SEO/РФ-профиль](public-site-ru.md), проверив применимость каждой правовой операции. [Карта языков и фреймворков](../../docs/language-baselines.md).
