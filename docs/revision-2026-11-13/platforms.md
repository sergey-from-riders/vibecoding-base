# Содержательная редакция PHP, платформ и React Native

> Исторический отчет подготовки присланной редакции. Указанные здесь доступы, окружение, отсутствие публикации и результаты запусков относятся к тому этапу. Дополнительные исправления и проверки при принятии: [интеграционное ревью](../integration-review-2026-11-13.md).

Дата проверки: 2026-11-13. Базовый commit существующих правил: `c26db4253f9dbd1c411bd5aeefd56e9da96e2186`. Уточнены все 19 назначенных исходных правил: 15 платформенных и 4 мобильных. Добавлены 14 кандидатов: 3 PHP, 10 платформенных и 1 React Native. Это локальная редакция документации, а не подтверждение публикации на GitHub или eval.su.

## Границы результата

Сохранены исходные ID, пути, section, published_at и schema1. У новых ID нет published_at до подтвержденной первой публикации. reviewed_at отражает чтение источников и содержательное ревью; он не означает выполнение всех приемочных сценариев. Старые [карточки платформенного аудита](../audit-2026-11-13/frameworks-platforms.md) и [мобильного аудита](../audit-2026-11-13/mobile-react-native.md) остаются исторической оценкой исходного текста.

## Проверенные предположения

| Предположение | Результат проверки и решение |
| --- | --- |
| Весь проект Bitrix нужно перенести в /local | Не подтверждено. Документация перечисляет точки расширения; публичные страницы, upload и ядро имеют собственные пути. Правило перечисляет границы и миграцию init.php. |
| Bitrix требует любой непубликуемый модуль хранить в local | Такое универсальное требование не установлено. /local/modules поддерживается и рекомендован для собственного кода; происхождение и lifecycle legacy/поставляемых модулей проверяются отдельно. |
| Новый local init.php дополняет старый автоматически | Опровергнуто для общего init.php: local имеет приоритет, старые регистрации нужно сохранить осознанно. |
| namespace/use сами загружают класс или модуль | Опровергнуто. Требуются Composer/Loader mapping и, для установленного Bitrix-модуля, includeModule. |
| agents_use_crontab=Y переносит все агенты на cron | Опровергнуто: описан частичный режим; полный перенос имеет другую настройку. Cron также не гарантирует успех, отсутствие наложения или однократный эффект. |
| afterCommit/on_commit гарантирует доставку | Опровергнуто. Они задают порядок после commit; окно потери сообщения требует outbox или другого протокола надежной доставки. |
| Серверный файл или middleware сам гарантирует право на объект | Опровергнуто. Авторизация, фильтр владельца и выбор выходных полей заданы отдельно для соответствующих платформ. |
| Синтаксически верный JS/TS или JSON доказывает mobile release | Опровергнуто. Native dependencies, secure storage, links и OTA требуют сборки и устройств выбранного профиля. |

Решения выше основаны на первичных источниках, перечисленных у соответствующих ID ниже. Новые соглашения о структуре не требуют создавать пустые абстрактные слои.

## Фактическая проверка

- 33 карточки прошли локальную структурную проверку: JSON frontmatter, идентичность исходных метаданных, 9 разрешенных H2, по одному fenced-примеру для «Плохо»/«Хорошо», источники, related и таблицы приемки. Проверено отсутствие случайного общего отступа в прозе и перед <?php.
- 8 Python-фрагментов разобраны ast.parse; 2 JSON-фрагмента декодированы. 10 JS/script-фрагментов проверены node --check, из них 7 предварительно разобраны как erasable TypeScript. Это не typecheck, SFC-компиляция или разрешение imports.
- Хороший пример APIRouter исполнен: GET /health — 200 и ожидаемый JSON, POST — 405, неизвестный маршрут — 404; OpenAPI ссылается на HealthResponse.
- Для FastAPI I/O проверено место выполнения контролируемой SDK fixture: sync endpoint — worker thread, async endpoint с обычным вызовом — поток event loop. Реальный SDK не использовался.
- Среда выполнения этих примеров: fastapi 0.141.1, starlette 1.6.0, pydantic 2.13.4, httpx 0.28.1, anyio 4.14.2. Starlette выдал предупреждение об устаревании интеграции TestClient/httpx; это не ошибка результата, но используемая среда зафиксирована.
- PHP/Composer, Bitrix, Laravel, WordPress, Django, NestJS, Vue/Nuxt/SvelteKit runtime и React Native/device build не запускались. Внешние сервисы, БД, deploy и приемка импортера eval.su не проверялись.

## По каждому правилу

### `frameworks.laravel-validation` — Laravel: Form Request и Policy

[Полный текст](../../registry/standards/frameworks/platforms/rules/laravel-validation.md) · редакция существующего правила.

Разделены POST/PATCH, отсутствие/null/пустая строка и исключение лишних полей из записи. Явно заданы auth middleware, model binding, регистрация Policy, доступ к объекту и проверка 401/403/404/422 через маршрут.

Источники и проверенные разделы:

- [Laravel 12: Form Request, optional fields и validated input](https://laravel.com/docs/12.x/validation) — Form Request Validation; Authorizing Form Requests; Validating When Present; Working With Validated Input.
- [Laravel 12: регистрация и применение Policy](https://laravel.com/docs/12.x/authorization) — Registering Policies; Authorizing Actions Using Policies.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.laravel-jobs` — Laravel: транзакция и afterCommit

[Полный текст](../../registry/standards/frameworks/platforms/rules/laravel-jobs.md) · редакция существующего правила.

Уточнены after_commit=true/false, вложенная транзакция и внешний commit. afterCommit отделен от outbox, а ShouldBeUnique — от идемпотентности внешней отправки; добавлены rollback и окно потери задания.

Источники и проверенные разделы:

- [Laravel 12: задания и транзакции](https://laravel.com/docs/12.x/queues) — Jobs and Database Transactions; Specifying Commit Dispatch Behavior Inline; Unique Jobs.
- [Laravel 12: транзакции БД](https://laravel.com/docs/12.x/database#database-transactions) — Database Transactions.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.laravel-eloquent` — Laravel: Eloquent и N+1

[Полный текст](../../registry/standards/frameworks/platforms/rules/laravel-eloquent.md) · редакция существующего правила.

Бюджет запросов включает count, сериализатор, вложенные и полиморфные связи. Добавлены nullable customer, фильтр tenant до пагинации и сравнение полного ответа для 1 и 30 записей.

Источники и проверенные разделы:

- [Laravel 12: eager loading и lazy loading](https://laravel.com/docs/12.x/eloquent-relationships#eager-loading) — Eager Loading; Nested Eager Loading; Preventing Lazy Loading.
- [Laravel 12: способы пагинации](https://laravel.com/docs/12.x/pagination) — Paginating Eloquent Results; simplePaginate.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.bitrix-local` — 1С-Битрикс: /local и расширения

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix-local.md) · редакция существующего правила.

Названы поддерживаемые точки /local, приоритет поиска и ограничение по версии main. Уточнено замещение общего init.php, сохранение публичных страниц/upload и отсутствие универсального требования Bitrix переносить все непубликуемые модули.

Источники и проверенные разделы:

- [Bitrix: структура директорий](https://docs.1c-bitrix.ru/pages/get-started/directory-structure.html) — Папка /local; Что можно хранить; Особенности работы; Публичные страницы.
- [Bitrix: безопасная кастомизация](https://docs.1c-bitrix.ru/pages/get-started/how-customize.html) — Где размещать изменения; Обработчики событий; Компоненты и модули.
- [Bitrix: появление поддержки /local](https://dev.1c-bitrix.ru/community/blogs/vad/local-folder.php) — Официальное объявление поддержки в версии 14.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.bitrix-transactions` — 1С-Битрикс: D7-транзакции

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix-transactions.md) · редакция существующего правила.

Обязательны одно соединение и проверка ORM Result. Описаны rollback, ошибка rollback, внешняя/вложенная транзакция, события до commit и сверка неопределенного исхода commit.

Источники и проверенные разделы:

- [Bitrix D7: startTransaction](https://dev.1c-bitrix.ru/api_d7/bitrix/main/db/connection/starttransaction.php) — Версия; контракт; исключения.
- [Bitrix D7: Result::isSuccess](https://dev.1c-bitrix.ru/api_d7/bitrix/main/result/issuccess.php) — Статус результата.
- [Bitrix: события и задачи](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33898&LESSON_PATH=3913.33898) — Отправка события после commit; отсутствие надежной доставки у background job.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.bitrix-cache` — 1С-Битрикс: ключ кеша и инвалидация

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix-cache.md) · редакция существующего правила.

Ключ учитывает серверный контекст, нормализованный фильтр и актуальную версию прав. Указаны abortDataCache, очистка после commit, позднее заполнение старым значением и границы TTL/защиты от stampede.

Источники и проверенные разделы:

- [Bitrix D7: Cache](https://dev.1c-bitrix.ru/api_d7/bitrix/main/data/cache/index.php) — initCache; startDataCache; abortDataCache; endDataCache.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.bitrix24-webhook` — Bitrix24: серверный вебхук

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix24-webhook.md) · редакция существующего правила.

Ограничены серверный endpoint, портал, метод, поля и права вебхука. Секрет в URL скрывается также из APM/proxy; ротация и идемпотентная локальная операция отделены от неатомарного find-then-create.

Источники и проверенные разделы:

- [Bitrix24: входящие вебхуки](https://apidocs.bitrix24.ru/local-integrations/local-webhooks.html) — Права владельца и scope; срок действия; секрет в URL; запрет публикации в клиентском коде.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.bitrix24-limits` — Bitrix24: лимиты и повтор запросов

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix24-limits.md) · редакция существующего правила.

Разделены QUERY_LIMIT_EXCEEDED, OPERATION_TIME_LIMIT и окно operating_reset_at. Частичный batch HTTP 200 разбирается по command_id, учитываются halt, неопределенный исход, deadline и ограниченный повтор.

Источники и проверенные разделы:

- [Bitrix24: лимиты REST API](https://apidocs.bitrix24.ru/limits.html) — Интенсивность; ресурсоемкость; QUERY_LIMIT_EXCEEDED; OPERATION_TIME_LIMIT; operating_reset_at.
- [Bitrix24: batch](https://apidocs.bitrix24.ru/settings/how-to-call-rest-api/batch.html) — Возвращаемые данные; result_error; halt; частичный успех.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.django-atomic` — Django: atomic и on_commit

[Полный текст](../../registry/standards/frameworks/platforms/rules/django-atomic.md) · редакция существующего правила.

Явно выбран database alias; on_commit привязан к тому же соединению и захватывает ID. Разделены savepoint, внешний commit, ошибка callback, надежная доставка и ограничения TestCase.

Источники и проверенные разделы:

- [Django 5.2: transactions](https://docs.djangoproject.com/en/5.2/topics/db/transactions/) — atomic; Savepoints; Timing of execution; Exception handling; Use in tests.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Оба Python-фрагмента разобраны Python 3.12 ast.parse; зависимости Django этим не выполнялись.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.fastapi-io` — FastAPI: async и блокирующий I/O

[Полный текст](../../registry/standards/frameworks/platforms/rules/fastapi-io.md) · редакция существующего правила.

Разделены sync endpoint, async endpoint и обычная sync-функция внутри него. Уточнены общий thread pool, timeouts SDK, предел параллелизма, отмена запроса и отдельная обработка CPU-нагрузки.

Источники и проверенные разделы:

- [FastAPI: async и синхронные функции](https://fastapi.tiangolo.com/async/) — Path operation functions; Dependencies; Other utility functions.
- [Starlette: thread pool](https://starlette.dev/threadpool/) — anyio.to_thread.run_sync; общая емкость; ограничения параллелизма.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Оба Python-фрагмента разобраны Python 3.12 ast.parse; зависимости Django этим не выполнялись.
- `executed-fixture`: Через HTTPX ASGITransport проверены оба endpoint с контролируемым in-memory SDK: def вызывает fixture в worker thread, async def — в потоке event loop. Реальный SDK и его timeouts не выполнялись.

Ограничения: SDK заменен локальной fixture для проверки диспетчеризации. Нагрузка, исчерпание пула, timeouts и отмена реального SDK не проверялись.

### `frameworks.nestjs-validation` — NestJS: ValidationPipe и DTO

[Полный текст](../../registry/standards/frameworks/platforms/rules/nestjs-validation.md) · редакция существующего правила.

Пример использует реальный DTO-класс, отключенное неявное преобразование, строгие лишние поля и проверку пустой строки. Указаны value import, nested DTO, body limits и отдельная авторизация.

Источники и проверенные разделы:

- [NestJS: ValidationPipe](https://docs.nestjs.com/techniques/validation) — Auto-validation; type-only imports; whitelist; transformation; validator options.
- [NestJS: guards](https://docs.nestjs.com/guards) — Authorization responsibility.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.vue-computed` — Vue: computed и производное состояние

[Полный текст](../../registry/standards/frameworks/platforms/rules/vue-computed.md) · редакция существующего правила.

Производное значение сделано чистым computed от глубокого ref. Разобраны начальная загрузка, вложенное изменение, замена массива, пустое состояние, shallowRef и нереактивные зависимости.

Источники и проверенные разделы:

- [Vue: computed properties](https://vuejs.org/guide/essentials/computed.html) — Computed Caching; Date.now; Getters should be side-effect free; Avoid mutating computed value.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Оба JavaScript-фрагмента проверены node --check; Vue runtime не запускался.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.nuxt-ssr-data` — Nuxt: useAsyncData и SSR

[Полный текст](../../registry/standards/frameworks/platforms/rules/nuxt-ssr-data.md) · редакция существующего правила.

SSR-загрузка получает контекст текущего запроса через useRequestFetch и передает AbortSignal. Уточнены truthy результат, общий key/согласованные опции, private cache и гонка смены аккаунта.

Источники и проверенные разделы:

- [Nuxt 4: useAsyncData](https://nuxt.com/docs/4.x/api/composables/use-async-data) — SSR payload; handler result; reactive key; Shared State and Option Consistency; clear.
- [Nuxt 4: data fetching](https://nuxt.com/docs/4.x/getting-started/data-fetching) — SSR and hydration; useRequestFetch and cookies.
- [Nuxt 4: useRequestFetch](https://nuxt.com/docs/4.x/api/composables/use-request-fetch) — Request context forwarding.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Доступный erasable TypeScript/script subset разобран Node stripTypeScriptTypes и node --check. Это не typecheck, SFC-компиляция или разрешение framework imports.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.sveltekit-server` — SvelteKit: server-only modules

[Полный текст](../../registry/standards/frameworks/platforms/rules/sveltekit-server.md) · редакция существующего правила.

Server-only импорт отделен от авторизации и выбора возвращаемых полей. Пример ограничен SvelteKit 2; описаны различия alias в версии 3, транзитивные импорты, production build и TEST=true.

Источники и проверенные разделы:

- [SvelteKit: server-only modules](https://svelte.dev/docs/kit/server-only-modules) — Direct/indirect imports; legacy SvelteKit 2; TEST=true limitation.
- [SvelteKit: load](https://svelte.dev/docs/kit/load) — Server load; serialization and locals.
- [SvelteKit 3: migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3) — Alias $lib -> #lib; generated types migration.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Доступный erasable TypeScript/script subset разобран Node stripTypeScriptTypes и node --check. Это не typecheck, SFC-компиляция или разрешение framework imports.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.wordpress-permissions` — WordPress: capabilities и nonce

[Полный текст](../../registry/standards/frameworks/platforms/rules/wordpress-permissions.md) · редакция существующего правила.

Nonce привязан к каноническому положительному post_id; отдельно проверяется capability объекта. Добавлены валидация ID без переполнения, unslash/slash, ошибка wp_update_post и безопасный redirect; nonce не считается одноразовым.

Источники и проверенные разделы:

- [WordPress: user capabilities](https://developer.wordpress.org/plugins/security/checking-user-capabilities/) — Capability checks for submitted data.
- [WordPress: nonces](https://developer.wordpress.org/apis/security/nonces/) — Lifetime; replay; not authentication or authorization.
- [WordPress: wp_update_post](https://developer.wordpress.org/reference/functions/wp_update_post/) — wp_error parameter; slashed input.
- [WordPress: admin_post hook](https://developer.wordpress.org/reference/hooks/admin_post_action/) — Authenticated admin-post action handler.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `mobile.secure-storage` — Keychain и Keystore

[Полный текст](../../registry/standards/mobile/react-native/rules/secure-storage.md) · редакция существующего правила.

Уточнены различия Keychain/Keystore, доступность и backup/reinstall. Запись секрета может отказать; logout, локальная очистка, отзыв сессии и биометрическая инвалидация проверяются отдельно.

Источники и проверенные разделы:

- [React Native: security](https://reactnative.dev/docs/security) — Sensitive info; AsyncStorage; secure storage.
- [Android: Keystore](https://developer.android.com/privacy-and-security/keystore) — Cryptographic keys and access control.
- [Expo SecureStore](https://docs.expo.dev/versions/latest/sdk/securestore/) — Platform storage; Data persistence; Android Auto Backup; accessibility; requireAuthentication.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Доступный erasable TypeScript/script subset разобран Node stripTypeScriptTypes и node --check. Это не typecheck, SFC-компиляция или разрешение framework imports.

Ограничения: Device/native runtime, Expo release build, ОС, провайдер OAuth и сервер синхронизации не запускались. Синтаксис или JSON не доказывает поведение на устройстве.

### `mobile.deep-links` — Deep links

[Полный текст](../../registry/standards/mobile/react-native/rules/deep-links.md) · редакция существующего правила.

Обычная навигация отделена от OAuth redirect/state/PKCE. Проверяются точные URI, параметры, повтор, cold/warm start и подтверждение домена; право на объект остается у сервера.

Источники и проверенные разделы:

- [React Native: Linking](https://reactnative.dev/docs/linking) — getInitialURL; addEventListener url; incoming links.
- [RFC 8252: native OAuth](https://www.rfc-editor.org/rfc/rfc8252) — Sections 4, 7, 8.1: external user-agent, redirects, PKCE.
- [Android: verify App Links](https://developer.android.com/training/app-links/verify-applinks) — Domain association and verification.
- [Apple: associated domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains) — Associated domains entitlement and apple-app-site-association.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Device/native runtime, Expo release build, ОС, провайдер OAuth и сервер синхронизации не запускались. Синтаксис или JSON не доказывает поведение на устройстве.

### `mobile.offline` — Офлайн-синхронизация

[Полный текст](../../registry/standards/mobile/react-native/rules/offline.md) · редакция существующего правила.

Намерение и черновик сохраняются атомарно, ключ операции переживает перезапуск. Добавлены порядок зависимостей, неизвестный исход, конфликт версии, удаление и запрет отправлять очередь аккаунта A от имени B.

Источники и проверенные разделы:

- [Android: offline-first architecture](https://developer.android.com/topic/architecture/data-layer/offline-first) — Queued/lazy writes; synchronization; conflict resolution; queues.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Device/native runtime, Expo release build, ОС, провайдер OAuth и сервер синхронизации не запускались. Синтаксис или JSON не доказывает поведение на устройстве.

### `mobile.native-release` — Мобильный релиз

[Полный текст](../../registry/standards/mobile/react-native/rules/native-release.md) · редакция существующего правила.

Связаны native runtime и OTA update; fingerprint не объявлен полной гарантией. Указаны preview/release matrix, постепенный rollout, метрики остановки, ограничения rollback и совместимость API/локальных данных.

Источники и проверенные разделы:

- [Expo: runtime versions and updates](https://docs.expo.dev/eas-update/runtime-versions/) — Native/update layers; fingerprint policy; gradually roll out; preview builds.
- [Expo: rollbacks](https://docs.expo.dev/eas-update/rollbacks/) — Rollback/republication and client update behavior.
- [Expo: error recovery](https://docs.expo.dev/eas-update/error-recovery/) — Recovery limits and state compatibility.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: JSON-фрагмент декодирован стандартным json parser.

Ограничения: Device/native runtime, Expo release build, ОС, провайдер OAuth и сервер синхронизации не запускались. Синтаксис или JSON не доказывает поведение на устройстве.

### `languages.php-types` — PHP: типы и проверка входных значений

[Полный текст](../../registry/standards/languages/php/rules/php-types.md) · новый кандидат без published_at.

Добавлен начальный PHP-профиль: типизированные границы, caller-sensitive strict_types, различие отсутствия/null, ограничение mixed и явный разбор внешнего ввода без слепого cast.

Источники и проверенные разделы:

- [PHP: type declarations](https://www.php.net/manual/en/language.types.declarations.php) — Type declarations; strict typing; caller scope; nullable and union types.
- [PHP: integers](https://www.php.net/manual/en/language.types.integer.php) — Integer range; overflow; conversion.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `languages.php-naming` — PHP: именование и границы PSR-1

[Полный текст](../../registry/standards/languages/php/rules/php-naming.md) · новый кандидат без published_at.

Языковые возможности отделены от PSR-1 и соглашений проекта. Указаны классы/методы/константы, отсутствие требования PSR-1 к стилю свойств и сохранение WordPress/Bitrix legacy-контрактов.

Источники и проверенные разделы:

- [PHP-FIG: PSR-1](https://www.php-fig.org/psr/psr-1/) — Class names; class constants; methods; intentionally unspecified property style; side effects.
- [WordPress: PHP coding standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/) — Naming conventions; namespace and import statements.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `languages.php-autoload` — PHP: namespace, PSR-4 и автозагрузка

[Полный текст](../../registry/standards/languages/php/rules/php-autoload.md) · новый кандидат без published_at.

Разделены namespace, import use и загрузчик. Показано соответствие PSR-4 prefix/path/case, генерация Composer autoload, production/dev и исключения classmap/files/Bitrix Loader.

Источники и проверенные разделы:

- [PHP-FIG: PSR-4](https://www.php-fig.org/psr/psr-4/) — Namespace prefix; base directory; case-sensitive class and file path.
- [Composer: schema autoload](https://getcomposer.org/doc/04-schema.md#autoload) — PSR-4; classmap; files; autoload-dev.
- [PHP: autoloading classes](https://www.php.net/manual/en/language.oop5.autoload.php) — Class autoload and spl_autoload_register.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: JSON-фрагмент декодирован стандартным json parser.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.bitrix-autoload` — 1С-Битрикс: namespace, загрузка классов и обработчики

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix-autoload.md) · новый кандидат без published_at.

Добавлены уникальный namespace, явная classmap, includeModule, версия Loader и регистр пути. Разделены runtime и постоянная регистрация handlers, D7/legacy события и ранний init.php без бизнес-эффектов.

Источники и проверенные разделы:

- [Bitrix: autoloading](https://docs.1c-bitrix.ru/pages/framework/autoloading.html) — includeModule; namespace/lib mapping; legacy lowercase; classmap; registerNamespace.
- [Bitrix D7: registerAutoLoadClasses](https://dev.1c-bitrix.ru/api_d7/bitrix/main/loader/registerautoloadclasses.php) — null module and class/path map.
- [Bitrix: events](https://docs.1c-bitrix.ru/pages/framework/events.html) — Registration; init.php; legacy events and compatibility.
- [Bitrix: request bootstrap](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33876&LESSON_PATH=3913.33876) — init.php before authorization; local init priority.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.bitrix-scheduling` — 1С-Битрикс: агенты, cron и безопасный CLI

[Полный текст](../../registry/standards/frameworks/platforms/rules/bitrix-scheduling.md) · новый кандидат без published_at.

Разделены агент на хитах, агент на cron и собственная CLI-задача. Уточнены частичный/полный перенос, доверенный bootstrap вне web root, CLI guard, повторы, блокировка, checkpoint и ненулевой исход сбоя.

Источники и проверенные разделы:

- [Bitrix: agents and background jobs](https://docs.1c-bitrix.ru/pages/framework/background-jobs.html) — Agent return value; partial/full cron transfer; duplicate standard cron; background job limits.
- [Bitrix: console commands](https://docs.1c-bitrix.ru/pages/framework/console-commands.html) — Composer requirement; custom commands; scheduling.
- [PHP: PHP_SAPI](https://www.php.net/manual/en/reserved.constants.php) — PHP_SAPI identifies server API.
- [Bitrix: request bootstrap](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33876&LESSON_PATH=3913.33876) — prolog_before and request lifecycle.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `frameworks.laravel-conventions` — Laravel: начальная структура и регистрация кода

[Полный текст](../../registry/standards/frameworks/platforms/rules/laravel-conventions.md) · новый кандидат без published_at.

Добавлены стандартные namespaces/директории, назначение controllers/requests/models/policies/jobs, composition через container и граница env/config при config:cache без требования лишних слоев.

Источники и проверенные разделы:

- [Laravel 12: directory structure](https://laravel.com/docs/12.x/structure) — Default directories; freedom of organization; providers.
- [Laravel 12: service container](https://laravel.com/docs/12.x/container) — Dependency injection; interface bindings.
- [Laravel 12: configuration](https://laravel.com/docs/12.x/configuration) — Configuration caching; env use in configuration.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.django-conventions` — Django: приложения, имена и безопасная инициализация

[Полный текст](../../registry/standards/frameworks/platforms/rules/django-conventions.md) · новый кандидат без published_at.

Добавлены AppConfig/INSTALLED_APPS, миграции приложения и URL namespace. Запрещены I/O при импорте/ready; сохранение app label и повторная регистрация signals рассмотрены отдельно.

Источники и проверенные разделы:

- [Django 5.2: applications](https://docs.djangoproject.com/en/5.2/ref/applications/) — AppConfig.name/label; ready; registry initialization; avoid DB queries at startup.
- [Django 5.2: first application](https://docs.djangoproject.com/en/5.2/intro/tutorial01/) — Project vs app; URLs; startapp layout.
- [Django 5.2: URL namespaces](https://docs.djangoproject.com/en/5.2/topics/http/urls/) — URL namespaces; reversing namespaced URLs.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Оба Python-фрагмента разобраны Python 3.12 ast.parse; зависимости Django этим не выполнялись.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.fastapi-conventions` — FastAPI: routers, модели и жизненный цикл ресурсов

[Полный текст](../../registry/standards/frameworks/platforms/rules/fastapi-conventions.md) · новый кандидат без published_at.

Добавлены composition root, APIRouter, модели входа/выхода, Depends и lifespan. Небольшой пример health endpoint полностью исполняется; обязательная избыточная структура каталогов не вводится.

Источники и проверенные разделы:

- [FastAPI: bigger applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/) — APIRouter; include_router; shared dependencies.
- [FastAPI: lifespan events](https://fastapi.tiangolo.com/advanced/events/) — Lifespan with yield; alternative deprecated events.
- [FastAPI: response model](https://fastapi.tiangolo.com/tutorial/response-model/) — Output validation and filtering.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Оба Python-фрагмента разобраны Python 3.12 ast.parse; зависимости Django этим не выполнялись.
- `executed`: Хороший фрагмент исполнен без изменения: GET /health -> 200 и {status: ok}, POST /health -> 405, неизвестный путь -> 404, OpenAPI ссылается на HealthResponse.

Ограничения: Исполнен только указанный health-пример и его HTTP/OpenAPI-контракт. Lifespan с реальными ресурсами, зависимости запроса, безопасность и приложение потребителя не проверялись.

### `frameworks.nestjs-conventions` — NestJS: модули, имена и внедрение зависимостей

[Полный текст](../../registry/standards/frameworks/platforms/rules/nestjs-conventions.md) · новый кандидат без published_at.

Добавлены module/controller/provider, явные exports/imports и DI tokens вместо интерфейсов как runtime-токенов. Singleton state отделен от контекста запроса; пример задает минимальный модуль.

Источники и проверенные разделы:

- [NestJS: modules](https://docs.nestjs.com/modules) — Module metadata; shared providers; exports/imports.
- [NestJS: providers](https://docs.nestjs.com/providers) — Dependency injection; registration; scopes.
- [NestJS: custom providers](https://docs.nestjs.com/fundamentals/custom-providers) — Tokens and bindings.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.vue-conventions` — Vue: SFC, props, события и имена компонентов

[Полный текст](../../registry/standards/frameworks/platforms/rules/vue-conventions.md) · новый кандидат без published_at.

Добавлены SFC/TypeScript, readonly props, типизированные emits и именование компонента/composable. Различия Vue 3.3/3.5 и допустимость Options API указаны без принудительного переписывания проекта.

Источники и проверенные разделы:

- [Vue: script setup](https://vuejs.org/api/sfc-script-setup.html) — defineProps/defineEmits; Vue 3.3 syntax; reactive destructure in 3.5.
- [Vue: props](https://vuejs.org/guide/components/props.html) — One-Way Data Flow; nested object mutation.
- [Vue: composables](https://vuejs.org/guide/reusability/composables.html) — Naming and lifecycle cleanup.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.
- `syntax-checked`: Доступный erasable TypeScript/script subset разобран Node stripTypeScriptTypes и node --check. Это не typecheck, SFC-компиляция или разрешение framework imports.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.nuxt-conventions` — Nuxt: структура app/server и правила регистрации

[Полный текст](../../registry/standards/frameworks/platforms/rules/nuxt-conventions.md) · новый кандидат без published_at.

Добавлена структура Nuxt 4 app/server/shared, файловые маршруты и suffix HTTP-методов. Разделены route middleware/API authorization и private/public runtimeConfig; .nuxt/.output не редактируются.

Источники и проверенные разделы:

- [Nuxt 4: pages](https://nuxt.com/docs/4.x/directory-structure/app/pages) — File routing; optional pages; app/pages.
- [Nuxt 4: server](https://nuxt.com/docs/4.x/directory-structure/server) — server/api; routes; HTTP method suffix; separation from app.
- [Nuxt 4: runtime config](https://nuxt.com/docs/4.x/guide/going-further/runtime-config) — Private/public configuration and payload.
- [Nuxt 4: shared directory](https://nuxt.com/docs/4.x/directory-structure/shared) — Shared code restrictions and auto imports.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.sveltekit-conventions` — SvelteKit: файлы маршрутов и контекст запроса

[Полный текст](../../registry/standards/frameworks/platforms/rules/sveltekit-conventions.md) · новый кандидат без published_at.

Добавлены +page/+layout/+server, server load/actions и request locals. Уточнены версии 2/3, aliases/config/adapter и запрет общего изменяемого состояния пользователя на сервере.

Источники и проверенные разделы:

- [SvelteKit: project structure](https://svelte.dev/docs/kit/project-structure) — src/routes; lib/server; hooks; static assets.
- [SvelteKit: routing](https://svelte.dev/docs/kit/routing) — +page; +layout; server files; +server handlers.
- [SvelteKit: state management](https://svelte.dev/docs/kit/state-management) — Avoid shared state on the server.
- [SvelteKit 3: migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3) — Major-specific config; aliases; generated types.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Полный framework runtime/build и приложение потребителя не запускались. Приемочные сценарии записаны как требуемые проверки, а не как уже пройденные.

### `frameworks.wordpress-conventions` — WordPress: плагины, имена и жизненный цикл hooks

[Полный текст](../../registry/standards/frameworks/platforms/rules/wordpress-conventions.md) · новый кандидат без published_at.

Добавлены собственный plugin/child theme, namespace и уникальные string IDs, регистрация на init и осознанная публичность post type. Разделены activation/deactivation/uninstall и исключения MU plugins.

Источники и проверенные разделы:

- [WordPress: plugin best practices](https://developer.wordpress.org/plugins/plugin-basics/best-practices/) — Naming collisions; organization; direct file access.
- [WordPress: PHP coding standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/) — Naming conventions; namespace declarations.
- [WordPress: activation/deactivation hooks](https://developer.wordpress.org/plugins/plugin-basics/activation-deactivation-hooks/) — Activation; deactivation; rewrite rules.
- [WordPress: register_post_type](https://developer.wordpress.org/reference/functions/register_post_type/) — init timing; post type name; public and REST arguments.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: PHP/Composer и платформа не установлены: PHP синтаксически не исполнялся. У полнофайловых примеров отдельно проверено отсутствие вывода/отступа перед <?php. Реальная БД, права, hooks и failure paths требуют стенда проекта.

### `mobile.react-native-conventions` — React Native: компоненты, типы и платформенный профиль

[Полный текст](../../registry/standards/mobile/react-native/rules/react-native-conventions.md) · новый кандидат без published_at.

Добавлены native primitives, .tsx/.ts, props/hooks/компоненты и platform-specific files. Уточнены профиль React Native/Expo/OS и различие typecheck, транспиляции и реального native build.

Источники и проверенные разделы:

- [React Native: TypeScript](https://reactnative.dev/docs/typescript) — TypeScript profile; transformation and type checking.
- [React Native: platform-specific code](https://reactnative.dev/docs/platform-specific-code) — Platform; platform-specific file extensions.
- [React Native: core components](https://reactnative.dev/docs/intro-react-native-components) — Native components vs web components.

Фактическая проверка:

- `source-reviewed`: Применимые утверждения, условия API и профиль версии сопоставлены с указанными первичными источниками.
- `manual-reviewed`: Проверены смысл пары примеров, импорты/предпосылки, границы применимости и отрицательные сценарии.
- `schema-checked`: PASS: frontmatter JSON/schema1, ID/path, 9 H2, fenced-примеры, таблица приемки, sources, related, сохранение исходных published_at и отсутствие published_at у новых ID.

Ограничения: Device/native runtime, Expo release build, ОС, провайдер OAuth и сервер синхронизации не запускались. Синтаксис или JSON не доказывает поведение на устройстве.
