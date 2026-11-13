---
schema_version: 1
id: "caching.redis-persistence"
title: "Redis: persistence и восстановление"
section: "caching"
level: "recommended"
tags: ["redis-persistence", "Redis"]
technologies: ["Redis"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 117
related: ["caching.source-of-truth", "operations.restore"]
sources: ["https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/", "https://redis.io/docs/latest/develop/reference/eviction/"]
---

# Redis: persistence и восстановление

## Коротко

Настройте Redis по роли данных и проверяемым RPO/RTO. Восстанавливаемый кеш, очередь и единственная копия состояния требуют разных решений о persistence и eviction.

## Плохо

```text
Единственная копия принятого задания в Redis.
Persistence отключен, allkeys-lru удаляет ключи.
После сбоя приложение сообщает успех без задания.
```

## Хорошо

```text
Кеш: авторитетная БД, ограниченный прогрев; persistence по RTO.
Очередь: допустимая потеря определена, eviction не удаляет задания.
При noeviction ошибки записи обрабатываются, прием не подтверждается.
AOF/RDB и восстановление проверяются на целевой версии Redis.
```

## Почему

AOF everysec может потерять последние записи при аварии и не является гарантией RPO=0. RDB отражает снимок определенного момента. Репликация не заменяет независимую копию и проверку restore. У noeviction кончается емкость: новые записи могут завершаться ошибкой, это не бесконечное хранилище.

## Когда применять

Для Redis Open Source; поведение managed-сервиса и точная версия проверяются отдельно. Для полностью воспроизводимого кеша persistence может быть отключен, если время прогрева и нагрузка укладываются в бюджет. AOF everysec — допустимый выбор, не обязательный default любого кеша. Для единственной копии критичного задания проверьте RPO, подтверждение записи, failover и replay; если гарантии недостаточны, измените источник/модель принятия задания.

Разделяйте данные с несовместимыми eviction/retention требованиями. Контролируйте maxmemory, отказы записи, диск и persistence errors. При восстановлении проверяйте не только штатный restart, но и аварийное завершение/потерю узла в тестовой среде, а также поврежденную копию; измеряйте фактическую потерю и время. Дедупликация необходима и после восстановления.

## Как проверить

1. Пустой кеш либо штатный restart → восстановление → данные восстановлены в RTO из источника/копии → ревизия и время.

2. Контролируемый crash тестового Redis после подтвержденных записей → восстановление → измеренная потеря не превышает принятую модель RPO, повторы не дублируют эффект → сверка ключей и журнала.

3. noeviction достиг maxmemory либо persistence write failed → новая задача → отказ приема/устойчивый fallback, без ложного ACK → ошибка Redis и отсутствие потерянного подтвержденного задания.

## Человек

Выбирает допустимую потерю, время восстановления и роль каждого набора данных.

## Агент

Проверяет effective config и обработку ошибок емкости, измеряет restart/crash/restore отдельно; не объявляет AOF нулевой потерей.

## Источники

- [Redis persistence: RDB, AOF, everysec и restore](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [Redis eviction: noeviction и ошибки при maxmemory](https://redis.io/docs/latest/develop/reference/eviction/)
