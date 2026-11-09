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
sources: ["https://developer.wordpress.org/plugins/security/checking-user-capabilities/", "https://developer.wordpress.org/apis/security/nonces/"]
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
wp_update_post($validated_data);
```

## Почему

Знание nonce не даёт права изменять произвольную запись. Проверка capability учитывает объект и текущего пользователя.

## Когда применять

WordPress, обработчик формы в админке. Форма создаёт соответствующий wp_nonce_field; входные данные валидируются. Для REST используйте permission_callback и механизм аутентификации REST.

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

- [Документация 1](https://developer.wordpress.org/plugins/security/checking-user-capabilities/)
- [Документация 2](https://developer.wordpress.org/apis/security/nonces/)
