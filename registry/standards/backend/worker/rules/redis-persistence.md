---
schema_version: 1
id: "caching.redis-persistence"
title: "Redis: persistence и восстановление"
section: "caching"
level: "recommended"
tags: ["redis-persistence", "Redis"]
technologies: ["Redis"]
reviewed_at: "2026-11-09"
order: 117
related: ["caching.source-of-truth", "operations.restore"]
sources: ["https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/", "https://redis.io/docs/latest/develop/reference/eviction/"]
---

# Redis: persistence и восстановление

## Коротко

Настройте восстановление Redis в соответствии с ролью данных. Кеш и единственная копия задания требуют разных гарантий.

## Плохо

```text
Redis = единственная копия данных
Persistence = off
Восстановление = не проверено
```

## Хорошо

```text
Источник = GitHub / основная БД
Redis = проверенная текущая и предыдущая версии
AOF = everysec
Восстановление = из источника или исправной копии
```

## Почему

AOF everysec уменьшает окно потери, но не гарантирует нулевую потерю при аварии. Репликация тоже не заменяет резервную копию.

## Когда применять

Redis OSS, AOF и RDB. Для восстанавливаемого кеша persistence выбирается по требованиям запуска. Для очередей отдельно оценивайте потерю последних записей, повторную обработку и noeviction; не смешивайте их с вытесняемым кешем без анализа.

## Человек

Определяет допустимую потерю данных, срок восстановления и владельца источника.

## Агент

Настраивает persistence и лимиты, проверяет перезапуск и восстановление без изменения исходного источника.

## Пример применения

Справочник хранит в Redis два проверенных снимка Markdown. Новый снимок публикуется атомарно, повреждённый отклоняется. При недоступности Redis сайт использует последнюю исправную дисковую копию.

## Как проверить

- После перезапуска данные восстанавливаются.
- Недоступность Redis имеет проверенный резервный сценарий.
- Ограничение памяти не удаляет единственную копию задания.

## Источники

- [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [Key eviction](https://redis.io/docs/latest/develop/reference/eviction/)
