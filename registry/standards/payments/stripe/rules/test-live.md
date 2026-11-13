---
id: "payments.test-live"
title: "Платежные окружения"
section: "payments"
level: "required"
tags: ["test-live", "Stripe"]
technologies: ["Stripe"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 100
related: ["payments.payment-truth", "payments.payment-events", "security.secrets", "integrations.webhooks"]
sources: ["https://docs.stripe.com/keys", "https://docs.stripe.com/api/versioning", "https://docs.stripe.com/webhooks", "https://docs.stripe.com/testing"]
schema_version: 1
---

# Платежные окружения

## Коротко

Stripe sandbox/live, account и webhook endpoint являются частью доверенного контекста. Неизвестная или противоречивая конфигурация блокирует платежные операции.

## Плохо

```text
Если STRIPE_MODE отсутствует, использовать live; взять первый whsec.
Событие с любым livemode применить к заказу по совпавшему ID.
```

## Хорошо

```text
Конфигурация: mode + account + key reference + endpoint secret reference.
Проверка запуска: все значения заданы и согласованы; иначе отказ.
Прием события: подлинность, livemode и account/context совпадают.
Реестр версий: SDK, request API, event destination API/format.
Sandbox сценарии проходят до отдельного разрешенного live-включения.
```

## Почему

API-ключ определяет доступный режим и аккаунт, а webhook secret не является API-ключом. Версия SDK, API-запроса и события выбираются разными механизмами; обновление одного не доказывает совместимость остальных. Общий prefix whsec не позволяет определить mode/account, поэтому нужен явный реестр конфигурации.

## Когда применять

Для любой интеграции Stripe, включая Connect и несколько sandbox. Секреты и объекты окружений изолируйте; используйте отдельные references и разрешения deploy. Не выбирайте live по умолчанию и не подставляйте запасной секрет из другого окружения. Для account-level и Connect/organization событий проверьте соответствующий документированный account/context, а не наличие произвольного поля во всех форматах. После проверки подписи сопоставьте livemode, account, связанный payment и локальный заказ; неизвестный контекст не вызывает бизнес-эффект.

Зафиксируйте поддерживаемые версии: установленный SDK/lock, фактическая request API version, версия и snapshot/thin-формат event destination. Способ pin/override зависит от SDK; не предполагайте, что произвольный override совместим с генерируемыми типами. При обновлении используйте реальные сохраненные обезличенные fixtures выбранных форматов и sandbox сценарии: success, decline, requires_action, delayed result, duplicates, refund. Старые snapshot events не переписываются при смене API version.

Sandbox не перемещает реальные деньги и не доказывает все особенности live-провайдеров. Тестирование реальными реквизитами в live не является приемкой этого профиля. Поведение при неверном окружении — отказ запуска/операции либо quarantine события с сигналом владельцу, без автоматического переключения режима.

## Как проверить

1. Полностью согласованный sandbox конфиг → сценарий test PaymentMethod → только sandbox объекты/эффекты → сохраненный mode/account.

2. Пустой mode, смешанные key/secret либо live-событие на sandbox endpoint → запуск/прием → отказ или quarantine без выдачи → диагностический код без секрета.

3. Обновлен SDK/request API, остался старый webhook fixture → контрактная проверка → несовместимость обнаружена до live; повтор старого event не меняет формат → результаты fixtures.

## Человек

Выбирает аккаунты/окружения, согласует матрицу версий и разрешает включение реальной оплаты.

## Агент

Проверяет fail-closed конфигурацию, принадлежность объекта/события и совместимость SDK с обоими API-контрактами.

## Источники

- [Stripe API keys: sandbox/live separation и отдельные webhook secrets](https://docs.stripe.com/keys)
- [Stripe API versioning: SDK, request overrides и endpoint versions](https://docs.stripe.com/api/versioning)
- [Stripe Webhooks: event format/version и secret per endpoint/mode](https://docs.stripe.com/webhooks)
- [Stripe Testing: sandbox и ограничения live testing](https://docs.stripe.com/testing)
