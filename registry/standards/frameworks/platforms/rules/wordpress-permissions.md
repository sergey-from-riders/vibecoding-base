---
schema_version: 1
id: "frameworks.wordpress-permissions"
title: "WordPress: capabilities и nonce"
section: "frameworks"
level: "required"
tags: ["wordpress-permissions", "WordPress", "PHP"]
technologies: ["WordPress", "PHP"]
reviewed_at: "2026-11-09"
order: 116
related: ["security.object-access", "testing.integration"]
sources: ["https://developer.wordpress.org/plugins/security/checking-user-capabilities/", "https://developer.wordpress.org/apis/security/nonces/", "https://developer.wordpress.org/reference/functions/wp_update_post/"]
---

# WordPress: capabilities и nonce

## Коротко

Проверяйте право на действие и CSRF-защиту отдельно. Nonce не заменяет авторизацию.

## Плохо

```php
check_admin_referer('save_post');
wp_update_post($data);
```

## Хорошо

```php
if (!current_user_can('edit_post', $post_id)) {
  wp_die('Forbidden', '', ['response' => 403]);
}
check_admin_referer('save_post_' . $post_id);
$result = wp_update_post(wp_slash([
  'ID' => $post_id,
  'post_title' => $validated_title,
]), true);
if (is_wp_error($result)) {
  wp_die('Save failed', '', ['response' => 500]);
}
```

## Почему

Знание nonce не даёт права изменять произвольную запись. Проверка capability учитывает объект и текущего пользователя.

## Когда применять

WordPress, обработчик формы в админке. Форма создаёт соответствующий wp_nonce_field; `$post_id` — проверенный ID из маршрута, `$validated_title` — валидированная строка без служебных слешей. В запись передаётся тот же ID, на который проверено право; wp_slash подготавливает массив для API WordPress. Для REST используйте permission_callback и механизм аутентификации REST.

## Человек

Определяет права редакторов и разрешённые поля.

## Агент

Добавляет capability, nonce, валидацию и проверяет запрещённое редактирование.

## Пример применения

Редактор сохраняет карточку товара: сервер проверяет его право на конкретную запись, nonce этой формы и список разрешённых полей.

## Как проверить

- Пользователь без edit_post получает отказ.
- Неверный nonce отклоняется.

## Источники

- [Checking User Capabilities – Plugin Handbook](https://developer.wordpress.org/plugins/security/checking-user-capabilities/)
- [Nonces – Common APIs Handbook](https://developer.wordpress.org/apis/security/nonces/)
- [wp_update_post() – Function](https://developer.wordpress.org/reference/functions/wp_update_post/)
