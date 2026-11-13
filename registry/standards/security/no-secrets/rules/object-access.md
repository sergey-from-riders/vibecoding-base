---
id: "security.object-access"
title: "Object-level authorization"
section: "security"
level: "required"
tags: ["object-access"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 70
related: ["security.sql-injection", "database.foreign-keys", "caching.private-cache", "integrations.files"]
sources: ["https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/", "https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html"]
schema_version: 1
---

# Object-level authorization

## Коротко

Авторизация проверяет subject, action, object и актуальный контекст на сервере. Совпадение tenant_id и знание UUID сами по себе не дают права на объект.

## Плохо

```sql
SELECT * FROM documents WHERE tenant_id = $1 AND document_id = $2;
-- Пользователь той же организации читает любой документ без проверки роли.
```

## Хорошо

```sql
-- Профиль: читать документ может только его владелец в активном tenant.
-- $1/$2 получены из проверенного контекста, $3 — запрошенный document_id.
SELECT document_id, title
FROM documents
WHERE tenant_id = $1 AND owner_user_id = $2 AND document_id = $3;
```

## Почему

Tenant isolation ограничивает организацию, но не описывает роли, отношения владения и допустимые действия внутри нее. Сервер должен иметь явную разрешающую политику; при отсутствии разрешения доступ закрыт. Проверка только UI или предсказуемости идентификатора не защищает альтернативный API-маршрут.

## Когда применять

Для приватных ресурсов, включая файлы, фоновые задания, bulk actions и экспорт. Пример показывает узкую политику owner-only read, а не универсальную модель доступа; административное делегирование, shared resources и публичное чтение требуют отдельных явных разрешений. tenant/user берутся из проверенной сессии и действующего членства, а не из произвольного body/header.

Применяйте одну политику к detail, list, count, search, export и каждому объекту bulk-операции. Для bulk заранее определите атомарный отказ либо безопасный частичный результат; чужие строки/их existence не должны просочиться в count или ошибки. Чтение, изменение, удаление и выдача прав — разные actions. При ошибке policy store нельзя автоматически разрешать доступ.

Проверяйте текущие права на каждом защищенном запросе; политика кэширования обязана задавать срок действия и инвалидирование при отзыве роли/членства. Для долгой операции установите момент авторизации и правило повторной проверки перед необратимым эффектом; для background job сохраняйте субъект/контекст, а не признак authorized=true навсегда. Исключения вроде полномочий служебной учетной записи документируются. Отказ 403 или скрывающий существование 404 выбирается последовательно контрактом API.

## Как проверить

1. Владелец с действующим членством → read/list/export → видит разрешенный документ → одинаковая политика всех маршрутов.

2. Другой пользователь того же tenant и пользователь другого tenant → detail/bulk/search/count → чужие данные и изменения отсутствуют → отрицательные access fixtures.

3. Роль отозвана или policy store недоступен → новый запрос/момент повторной проверки job → доступ закрыт по заданному контракту → журнал решения без данных объекта.

## Человек

Задает матрицу субъектов, действий и объектов, делегирование, сроки отзыва и семантику bulk.

## Агент

Проверяет политику в серверных точках доступа; тестирует пользователей внутри и между tenant, отзыв и альтернативные маршруты.

## Источники

- [OWASP API1:2023: проверка action/object каждого обращения](https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/)
- [OWASP Authorization: least privileges, deny by default, every request](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
