# 07. DB Naming Conventions (Mandatory)

Этот документ — обязательный контракт для всех агентов и разработчиков.
Любая миграция или изменение схемы, нарушающее эти правила, считается ошибкой.

## 1) Базовый принцип
Название сущности определяет название ключа:
- table `users` -> primary key `user_id`
- table `companies` -> primary key `company_id`
- table `sessions` -> primary key `session_id`

Идентификаторы сущностей всегда `uuid`.

## 2) Правила именования таблиц
- Только `snake_case`.
- Только множественное число для entity tables.
- Примеры:
  - `users`
  - `companies`
  - `sessions`
  - `auth_events`

## 3) Правила именования PK
- PK всегда `<entity_singular>_id`.
- Тип PK всегда `uuid`.
- Рекомендуемый default: `gen_random_uuid()`.
- Запрещено:
  - `id`
  - `uuid`
  - `user_uuid`
  - `users_id`

## 4) Правила именования FK
- FK всегда называется по целевой сущности: `<target_entity_singular>_id`.
- Тип FK всегда `uuid`.
- Примеры:
  - `sessions.user_id -> users.user_id`
  - `companies.owner_user_id -> users.user_id`
  - `users.current_company_id -> companies.company_id`

## 5) Join / relation tables
- Имена таблиц также в snake_case.
- В relation table используются canonical FK имена:
  - `company_id`
  - `user_id`
- Обычно composite PK из FK:
  - `PRIMARY KEY (company_id, user_id)`
- Отдельный surrogate `*_id` добавляется только при реальной необходимости, и если добавляется — тоже `uuid`.

## 5.1) Version tables
Для бизнес-сущностей обязательно используются таблицы версий:
- `<entity_singular>_versions`

Именование ключей:
- PK: `<entity_singular>_version_id` (`uuid`)
- Entity FK-like column: `<entity_singular>_id` (`uuid`)
- Номер версии: `version_no` (`integer`)

Пример:
- `user_versions.user_version_id`
- `user_versions.user_id`

## 6) Типы идентификаторов
- Domain entity identifiers: только `uuid`.
- Нельзя использовать `serial/bigserial/int` для ID доменных сущностей.

## 7) Служебные поля времени (рекомендуемый стандарт)
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`
- `deleted_at timestamptz null` (для soft delete)

## 8) Ограничения и индексы (нейминг)
- Индексы: `idx_<table>_<column>[_<suffix>]`
- FK constraints: `<table>_<column>_fkey`
- Checks: `<table>_<meaning>_check`

## 9) Good / Bad examples

Good:
```sql
CREATE TABLE users (
  user_id uuid PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE TABLE sessions (
  session_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(user_id)
);
```

Bad:
```sql
CREATE TABLE users (
  id bigserial PRIMARY KEY
);

CREATE TABLE sessions (
  id uuid PRIMARY KEY,
  user_uuid uuid
);
```

## 10) Mandatory checklist before merge
1. Каждая entity table имеет PK вида `<entity>_id`.
2. Все PK/FK для доменных сущностей имеют тип `uuid`.
3. Нет `id`/`uuid` generic-колонок для ключей.
4. FK колонки названы по целевой сущности (`user_id`, `company_id`, ...).
5. Миграция не принимается, если нарушен хотя бы один пункт.
