# Интерфейс административных систем

Навигация по модулю `ui/admin-interface`. Полный текст каждого правила хранится только в `rules/`; эта страница не является их копией.

## Паспорт модуля

| Поле | Значение |
| --- | --- |
| ID | `ui/admin-interface` |
| Прежнее название | Интерфейс административных систем |
| Историческая версия содержания | `1.0.0` |
| Исторический статус | `stable` |
| Область | `ui` |
| Роли сопровождения из прежнего манифеста | `maintainers` |
| Языки | не ограничено языком |
| Среды / технологии | any |
| Число правил | 30 |

Версия и статус перенесены из прежнего `standard.yaml` как сведения об исходном модуле. Они не означают новое ревью, назначение конкретного ответственного, полноту требований или проверенную готовность приложения. Даты содержательной проверки указаны в самих правилах.

## Правила

| ID | Правило | Уровень |
| --- | --- | --- |
| `interface.table-layout` | [Табличные представления](rules/table-layout.md) | Рекомендуется |
| `interface.table-sorting` | [Сортировка таблиц](rules/table-sorting.md) | Обязательно |
| `interface.table-columns` | [Настройка столбцов](rules/table-columns.md) | Рекомендуется |
| `interface.server-thumbnails` | [Серверные превью](rules/server-thumbnails.md) | Рекомендуется |
| `interface.row-navigation` | [Навигация по строке](rules/row-navigation.md) | Обязательно |
| `interface.row-selection` | [Выделение строк](rules/row-selection.md) | Обязательно |
| `interface.sticky-header` | [Закрепленный заголовок](rules/sticky-header.md) | Рекомендуется |
| `interface.incremental-loading` | [Постепенная загрузка](rules/incremental-loading.md) | Рекомендуется |
| `interface.bulk-actions` | [Групповые действия](rules/bulk-actions.md) | Обязательно |
| `interface.manual-order` | [Ручной порядок](rules/manual-order.md) | Рекомендуется |
| `interface.natural-search` | [Поиск на естественном языке](rules/natural-search.md) | Рекомендуется |
| `interface.saved-views` | [Сохраненные представления](rules/saved-views.md) | Рекомендуется |
| `interface.search-fallback` | [Отказоустойчивый поиск](rules/search-fallback.md) | Обязательно |
| `interface.editor-layout` | [Вкладки и свойства](rules/editor-layout.md) | Рекомендуется |
| `interface.field-validation` | [Поиск свойств и валидация](rules/field-validation.md) | Обязательно |
| `interface.important-switches` | [Тумблеры важных свойств](rules/important-switches.md) | Рекомендуется |
| `interface.draft-autosave` | [Автосохранение черновика](rules/draft-autosave.md) | Обязательно |
| `interface.draft-history` | [Версии и отмена](rules/draft-history.md) | Обязательно |
| `interface.preview-publication` | [Предпросмотр и публикация](rules/preview-publication.md) | Обязательно |
| `interface.editing-locks` | [Конкурентное редактирование](rules/editing-locks.md) | Обязательно |
| `interface.media-import` | [Добавление медиа](rules/media-import.md) | Обязательно |
| `interface.media-gallery` | [Галерея и описание медиа](rules/media-gallery.md) | Рекомендуется |
| `interface.media-editing` | [Редактирование медиа](rules/media-editing.md) | Рекомендуется |
| `interface.loading-errors` | [Загрузка и ошибки](rules/loading-errors.md) | Обязательно |
| `interface.keyboard-mobile` | [Клавиатура и мобильный экран](rules/keyboard-mobile.md) | Обязательно |
| `interface.editor-performance` | [Быстрое открытие формы](rules/editor-performance.md) | Рекомендуется |
| `interface.related-records` | [Связанные записи](rules/related-records.md) | Обязательно |
| `interface.record-address` | [Адрес записи](rules/record-address.md) | Обязательно |
| `interface.agent-proposals` | [Подготовленные правки агента](rules/agent-proposals.md) | Обязательно |
| `interface.context-help` | [Контекстная справка](rules/context-help.md) | Рекомендуется |

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
