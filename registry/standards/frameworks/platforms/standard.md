# Фреймворки и CMS

Навигация по модулю `frameworks/platforms`. Полный текст каждого правила хранится только в `rules/`; эта страница не является их копией.

## Паспорт модуля

| Поле | Значение |
| --- | --- |
| ID | `frameworks/platforms` |
| Прежнее название | Фреймворки и CMS |
| Историческая версия содержания | `2.1.1` |
| Исторический статус | `stable` |
| Область | `frameworks` |
| Роли сопровождения из прежнего манифеста | `maintainers` |
| Языки | не ограничено языком |
| Среды / технологии | any |
| Число правил | 15 |

Версия и статус перенесены из прежнего `standard.yaml` как сведения об исходном модуле. Они не означают новое ревью, назначение конкретного ответственного, полноту требований или проверенную готовность приложения. Даты содержательной проверки указаны в самих правилах.

## Правила

| ID | Правило | Уровень |
| --- | --- | --- |
| `frameworks.laravel-validation` | [Laravel: Form Request и Policy](rules/laravel-validation.md) | Рекомендуется |
| `frameworks.laravel-jobs` | [Laravel: транзакция и afterCommit](rules/laravel-jobs.md) | Рекомендуется |
| `frameworks.laravel-eloquent` | [Laravel: Eloquent и N+1](rules/laravel-eloquent.md) | Рекомендуется |
| `frameworks.bitrix-local` | [1С-Битрикс: /local и расширения](rules/bitrix-local.md) | Рекомендуется |
| `frameworks.bitrix-transactions` | [1С-Битрикс: D7-транзакции](rules/bitrix-transactions.md) | Рекомендуется |
| `frameworks.bitrix-cache` | [1С-Битрикс: ключ кеша и инвалидация](rules/bitrix-cache.md) | Рекомендуется |
| `frameworks.bitrix24-webhook` | [Bitrix24: серверный вебхук](rules/bitrix24-webhook.md) | Обязательно |
| `frameworks.bitrix24-limits` | [Bitrix24: лимиты и повтор запросов](rules/bitrix24-limits.md) | Рекомендуется |
| `frameworks.django-atomic` | [Django: atomic и on_commit](rules/django-atomic.md) | Рекомендуется |
| `frameworks.fastapi-io` | [FastAPI: async и блокирующий I/O](rules/fastapi-io.md) | Рекомендуется |
| `frameworks.nestjs-validation` | [NestJS: ValidationPipe и DTO](rules/nestjs-validation.md) | Рекомендуется |
| `frameworks.vue-computed` | [Vue: computed и производное состояние](rules/vue-computed.md) | Рекомендуется |
| `frameworks.nuxt-ssr-data` | [Nuxt: useAsyncData и SSR](rules/nuxt-ssr-data.md) | Рекомендуется |
| `frameworks.sveltekit-server` | [SvelteKit: server-only modules](rules/sveltekit-server.md) | Рекомендуется |
| `frameworks.wordpress-permissions` | [WordPress: capabilities и nonce](rules/wordpress-permissions.md) | Обязательно |

## Зависимости и область применения

В прежнем манифесте явные зависимости не перечислены. Это не отменяет применимые требования других тем: проверяйте контекст проекта и связанные ID каждого правила.

Диапазоны сохранены для истории. В документационной модели они не разрешаются автоматически; для применения фиксируйте один точный commit корпуса и выбранные ID. Условия конкретного правила имеют значение независимо от включения всего модуля.

## Профили

- [go-next-postgres](../../../stacks/go-next-postgres.md).
- [python-react-postgres](../../../stacks/python-react-postgres.md).

Ссылки отражают прежнюю совместимость профилей как отправную точку выбора. Часть модулей подключается по условию; наличие ссылки не делает все правила обязательными для каждого проекта.

## Проверка и сопровождение

Репозиторий хранит документацию. Автоматическое выполнение правил, runtime-тесты и блокирующий CI здесь не заявляются. Проверки результата реализуются в проекте-потребителе; формат публикации проверяется его импортером по [контракту](../../../../docs/content-contract.md).

[История модуля](CHANGELOG.md) · [Каталог](../../../../docs/catalog.md) · [Правила изменений](../../../../docs/contributing-standards.md) · [Текущий аудит](../../../../docs/audit-2026-11-13.md).
