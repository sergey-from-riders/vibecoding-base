---
schema_version: 1
id: "frameworks.wordpress-permissions"
title: "WordPress: capabilities и nonce"
section: "frameworks"
level: "required"
tags: ["wordpress-permissions", "WordPress", "PHP"]
technologies: ["WordPress", "PHP"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 116
related: ["security.object-access", "testing.integration"]
sources: ["https://developer.wordpress.org/plugins/security/checking-user-capabilities/", "https://developer.wordpress.org/apis/security/nonces/", "https://developer.wordpress.org/reference/functions/wp_update_post/", "https://developer.wordpress.org/reference/hooks/admin_post_action/"]
---

# WordPress: capabilities и nonce

## Коротко

Для изменения записи проверяйте capability на канонический ID объекта и nonce конкретного действия. Nonce защищает от части CSRF-сценариев, но не дает право записи и не запрещает повтор операции.

## Плохо

```php
check_admin_referer('save_post');
wp_update_post($_POST); // Нет права edit_post и списка допустимых полей.
```

## Хорошо

```php
// В callback авторизованного admin_post_project_save_post, WordPress 6.x.
$raw_id = $_POST['post_id'] ?? null;
$post_id = is_string($raw_id)
    ? filter_var($raw_id, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]])
    : false;
if ($post_id === false) {
    wp_die('Invalid post ID', '', ['response' => 400]);
}
if (!current_user_can('edit_post', $post_id)) {
    wp_die('Forbidden', '', ['response' => 403]);
}
check_admin_referer('project_save_post_' . $post_id);

$raw_title = $_POST['post_title'] ?? null;
if (!is_string($raw_title)) {
    wp_die('Invalid title', '', ['response' => 400]);
}
$title = sanitize_text_field(wp_unslash($raw_title));
if ($title === '') {
    wp_die('Title is required', '', ['response' => 400]);
}
$result = wp_update_post(wp_slash([
    'ID' => $post_id,
    'post_title' => $title,
]), true);
if (is_wp_error($result)) {
    wp_die('Save failed', '', ['response' => 500]);
}
wp_safe_redirect(get_edit_post_link($post_id, 'raw'));
exit;
```

## Почему

Пользователь может иметь действительный nonce и не иметь права редактировать выбранную запись. Передача полного POST позволяет менять поля, которые форма не предлагала. WordPress nonce действителен некоторое время и может использоваться повторно.

## Когда применять

Контекст примера: авторизованная admin-post форма, baseline WordPress 6.0+; нужные API существуют и в более ранних версиях, но их поддержка здесь не заявляется. Callback зарегистрирован через `add_action('admin_post_project_save_post', ...)`, форма отправляет `action=project_save_post`, `post_id` и nonce с действием `project_save_post_<ID>`. Не регистрируйте этот обработчик как открытый nopriv endpoint.

Единственный ID в примере берется из проверенного POST. Если другой маршрут дополнительно задает ID в URL, сравните оба до записи и отклоните несовпадение; не проверяйте capability на одном ID, а сохраняйте другой. Для отсутствующего объекта и недостатка прав установите согласованную политику 403/404.

Input WordPress может быть slashed: перед sanitization вызывается wp_unslash, перед wp_update_post — wp_slash. Пример разрешает plain-text title; длина и более сложная семантика задаются продуктом. Sanitization не заменяет контекстное экранирование при HTML-выводе.

Повтор nonce допустим по его устройству. Для платежа, отправки или другой однократной операции нужен отдельный ключ/состояние. REST endpoint использует свой permission_callback и аутентификационный контракт; admin-ajax имеет свой путь nonce-проверки.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Владелец разрешенной записи, корректный nonce и title | Изменен только title; редирект на ожидаемую страницу | HTTP и перечитанная запись |
| Действующий nonce, но чужой post_id | 403/согласованный 404; изменений нет | Тест другого пользователя |
| Неверный/истекший nonce, массив вместо ID/title или ID больше PHP_INT_MAX | Отказ до записи; нет PHP warning, переполнения и скрытого coercion | Негативные запросы |
| Повтор того же nonce | Не считается взломом сам по себе; однократный эффект защищен отдельно | Проверка replay бизнес-операции |
| Добавлены post_author, post_status или иной ID URL | Поля не изменяются; конфликт ID отклонен | Diff записи и тест маршрута |

Отдельно проверьте доступ без сессии на настоящем admin-post: auth-поведение определяется WordPress и регистрацией hook.

## Человек

Определяет capability, разрешенные поля, политику 403/404 и необходимость защиты от повторного эффекта.

## Агент

Прослеживает один ID от проверки до сохранения, nonce action и slashing. Не выдает nonce за одноразовую авторизацию.

## Источники

- [WordPress: user capabilities](https://developer.wordpress.org/plugins/security/checking-user-capabilities/)
- [WordPress: nonces](https://developer.wordpress.org/apis/security/nonces/)
- [WordPress: wp_update_post](https://developer.wordpress.org/reference/functions/wp_update_post/)
- [WordPress: admin_post hook](https://developer.wordpress.org/reference/hooks/admin_post_action/)
