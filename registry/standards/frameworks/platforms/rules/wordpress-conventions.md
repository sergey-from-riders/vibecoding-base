---
schema_version: 1
id: "frameworks.wordpress-conventions"
title: "WordPress: плагины, имена и жизненный цикл hooks"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["WordPress 6", "PHP"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1213
related: ["frameworks.wordpress-permissions", "languages.php-naming", "languages.php-autoload"]
sources: ["https://developer.wordpress.org/plugins/plugin-basics/best-practices/", "https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/", "https://developer.wordpress.org/plugins/plugin-basics/activation-deactivation-hooks/", "https://developer.wordpress.org/reference/functions/register_post_type/"]
---

# WordPress: плагины, имена и жизненный цикл hooks

## Коротко

Пользовательскую функциональность WordPress оформляйте плагином с уникальными именами и штатными hooks. Не меняйте core или родительскую тему; bootstrap должен явно подключать код и учитывать жизненный цикл плагина.

## Плохо

```php
// wp-includes/post.php изменен ради проекта.
function init() { /* имя конфликтует с другими plugins */ }
register_post_type('catalog'); // Вызвано сразу при импорте произвольного файла.
```

## Хорошо

```php
<?php
/**
 * Plugin Name: Project Catalog
 */
namespace Project\Catalog;

if (!defined('ABSPATH')) {
    exit;
}
add_action('init', __NAMESPACE__ . '\register_catalog');

function register_catalog(): void
{
    register_post_type('project_item', [
        'label' => 'Каталог',
        'public' => true,
        'show_in_rest' => true,
        'supports' => ['title'],
    ]);
}
```

## Почему

Core и родительская тема обновляются независимо от проекта. Уникальные имена уменьшают коллизии с другими плагинами, а hook определяет, когда код выполняется относительно загрузки WordPress.

## Когда применять

Baseline WordPress 6.0+, PHP 7.4+ для показанного bootstrap; production выбирает поддерживаемый совместимый набор версий отдельно. Главный файл лежит в `wp-content/plugins/project-catalog/` и активирован как плагин. Пример регистрирует публичный тип записи; это явное решение, не безопасный default для любых данных.

Для template/style правок дочерняя тема подходит по своему контракту; сохраняемая бизнес-функциональность не должна исчезать при смене темы. mu-plugin имеет другой цикл загрузки/активации, его не подменяют обычным плагином без проверки.

Выберите WordPress coding standards для интеграционного кода: функции/методы с разделением подчеркиванием, уникальный префикс или namespace; имена hooks/options/transients/post types тоже должны избегать коллизий. PHP namespace не префиксует строковое имя hook/option автоматически. Не объявляйте PSR-1 camelCase обязательным для существующего WordPress API.

Namespace сам не загружает файл: нужен явный bootstrap/autoload. Для расширяющегося плагина классы и логика выносятся из главного файла, без запуска миграции на каждом хите. Activation/deactivation/uninstall имеют разные задачи; удаление пользовательских данных при uninstall требует явной политики. Rewrite rules обновляются в соответствующем lifecycle, не каждый запрос.

Регистрируя REST/форму, отдельно проверяйте permission_callback/capability и nonce по контексту; название hook не дает авторизацию.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Активация плагина и обычный init | Тип записи существует с выбранными параметрами | WP-тест/админка и REST по контракту |
| Активен другой плагин со своей функциональностью | Нет redeclare и совпадения ключей | Интеграционная проверка |
| Смена темы и обновление core | Функциональность плагина остается, core diff отсутствует | Стенд обновления |
| Deactivate/reactivate/uninstall | Поведение и сохранение/удаление данных соответствуют принятой политике | Lifecycle-сценарии |

Этот фрагмент не реализует миграции, меню, отдельные разрешения или регистрацию activation hook; их нельзя считать уже проверенными.

## Человек

Выбирает публичность данных, тип расширения и политику удаления.

## Агент

Сверяет namespace и строковые ключи, порядок hooks и lifecycle. Не меняет core и не переносит слепо PSR-соглашения на WordPress.

## Источники

- [WordPress: plugin best practices](https://developer.wordpress.org/plugins/plugin-basics/best-practices/)
- [WordPress: PHP coding standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/)
- [WordPress: activation/deactivation hooks](https://developer.wordpress.org/plugins/plugin-basics/activation-deactivation-hooks/)
- [WordPress: register_post_type](https://developer.wordpress.org/reference/functions/register_post_type/)
