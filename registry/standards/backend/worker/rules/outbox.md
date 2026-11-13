---
id: "caching.outbox"
title: "Transactional outbox"
section: "caching"
level: "contextual"
tags: ["outbox"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 68
related: ["database.transactions", "caching.idempotent-worker"]
sources: ["https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html", "https://learn.microsoft.com/en-us/power-platform/architecture/reference-architectures/transactional-outbox-pattern"]
schema_version: 1
---

# Transactional outbox

## Коротко

Если изменение БД требует последующей доставки события, фиксируйте бизнес-запись и outbox в одной транзакции, а публикацию выполняйте с восстановлением и допустимыми повторами.

## Плохо

```text
Заказ COMMIT → процесс упал → публикация не состоялась.
Либо событие опубликовано → заказ ROLLBACK.
```

## Хорошо

```text
BEGIN: заказ + outbox(event_id, payload, pending). COMMIT.
Relay берет запись с восстанавливаемым claim/lease.
Публикует прежний event_id, получает подтверждение брокера.
Отмечает delivered только текущий владелец claim.
Повтор после сбоя обрабатывается идемпотентным получателем.
```

## Почему

Outbox атомарно сохраняет намерение отправки с изменением данных. Он не обеспечивает общую транзакцию БД с брокером и не исключает duplicate: подтверждение брокера может быть потеряно до отметки delivered. event_id остается прежним при повторе.

## Когда применять

Когда недоставка события после commit нарушает согласованность и нет другой достаточной гарантии. Не вводите outbox для каждого чтения или без требования доставки. У relay ограничьте batch/concurrency, backoff и срок claim; упавший владелец освобождается по восстановительной процедуре, устаревший claim не помечает чужую попытку завершенной.

Если важен порядок, задайте область (например aggregate_id) и sequence/проверку версии у получателя; несколько relay и retry не создают глобального порядка автоматически. Контролируйте возраст старейшей pending-записи, число ошибок и владельца разбора. Не удаляйте pending по обычному TTL; срок delivered связан с аудитом/replay и дедупликацией. Чувствительные данные в payload минимизируются и имеют срок хранения.

## Как проверить

1. Заказ и outbox создаются → rollback/commit → обе записи отсутствуют или присутствуют → транзакционная выборка.

2. Процесс упал после commit до send либо после ACK брокера до delivered → restart → событие доставлено, возможный повтор не повторяет эффект → один business result и журнал event_id.

3. Два relay, истекший claim или недоступный брокер → попытки → нет вечного зависания/необоснованного delivered, возраст backlog дает сигнал → записи claim и метрика возраста.

## Человек

Определяет необходимость доставки, область порядка и срок восстановления backlog.

## Агент

Проверяет общую транзакцию, claims, отметку после подтверждения и дедупликацию получателя; моделирует оба crash window.

## Источники

- [AWS Transactional outbox: dual write, duplicates, order, rollback](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)
- [Microsoft Dataverse outbox: запись события в той же транзакции](https://learn.microsoft.com/en-us/power-platform/architecture/reference-architectures/transactional-outbox-pattern)
