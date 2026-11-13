---
id: "payments.card-data"
title: "Платежные данные"
section: "payments"
level: "required"
tags: ["card-data", "Stripe"]
technologies: ["Stripe"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 98
related: ["security.redaction", "security.secrets", "security.object-access", "payments.test-live"]
sources: ["https://docs.stripe.com/security/guide", "https://docs.stripe.com/keys", "https://docs.stripe.com/testing", "https://docs.stripe.com/payments/payment-intents"]
schema_version: 1
---

# Платежные данные

## Коротко

В обычном Stripe-профиле ввод PAN/CVC идет непосредственно в Checkout или Elements. Собственный backend, телеметрия и URL не должны получать эти реквизиты.

## Плохо

```text
Форма отправляет PAN/CVC на /api/pay; reverse proxy и error tracker
сохраняют body. Затем сервер пересылает реквизиты Stripe.
```

## Хорошо

```text
Checkout / Stripe Elements → реквизиты напрямую Stripe.
Приложение хранит нужные payment/order IDs и разрешенные last4/brand.
В логах/ошибках/replay — allowlist полей без PAN/CVC/client_secret.
Доступ к платежным объектам ограничен владельцем и служебными ролями.
```

## Почему

Путь чувствительных данных включает браузерные SDK, session replay, аналитику, proxy, traces, исключения, URL/history и резервные копии. Удаление поля из основной БД не закрывает эти каналы. Передача реквизитов напрямую Stripe уменьшает область PCI-обязанностей, но не освобождает бизнес от применимой проверки соответствия.

## Когда применять

Для интеграции без прямой обработки карточных реквизитов. PAN и CVC нельзя передавать через свой API, ставить в query, metadata, логи, тикеты или промпты. На платежных экранах отключите сбор содержимого чувствительных полей средствами replay/аналитики; проверяйте фактический payload, а не только настройку маскирования. Публичный publishable key допустим в клиенте; secret/restricted API key и webhook secret остаются на сервере.

Provider IDs и brand/last4 не равны PAN/CVC, однако связанные с человеком идентификаторы и платежные сведения имеют ограничения доступа/срока хранения. PaymentIntent client_secret обладает отдельными полномочиями: передавайте только клиенту соответствующего платежа по предусмотренному SDK-контракту, не используйте как публичный order ID и не журналируйте. Возвращайте клиенту только нужные поля, не полный объект Stripe.

Прямая обработка card data вне этого профиля требует отдельно спроектированной и подтвержденной PCI-области; нельзя объявлять ее безопасной одной токенизацией. Для проверки используйте sandbox PaymentMethod/официальные тестовые данные; не реальные карты.

## Как проверить

1. Sandbox Checkout/Elements → успешный платеж → свое приложение получает нужные IDs без PAN/CVC → инспекция разрешенных сетевых маршрутов и хранилищ.

2. Синтетический маркер введен в чувствительное поле → ошибка/replay/trace/proxy → маркер не появляется вне разрешенного маршрута → выборка всех каналов.

3. Запрос чужого payment ID либо попытка журналировать client_secret → выдача/логирование → объект недоступен, секрет исключен → access-тест и безопасный журнал.

## Человек

Выбирает платежную интеграцию, область PCI-проверки и минимальный набор хранимых реквизитов.

## Агент

Прослеживает путь ввода до Stripe и все каналы сбора данных; проверяет redaction и доступ к provider IDs.

## Источники

- [Stripe Integration security guide: low-risk integrations и shared PCI responsibility](https://docs.stripe.com/security/guide)
- [Stripe API keys: publishable, restricted, secret и webhook secrets](https://docs.stripe.com/keys)
- [Stripe Testing: тестовые PaymentMethods вместо реальных реквизитов](https://docs.stripe.com/testing)
- [Stripe Payment Intents: client_secret — scope, TLS и запрет логирования](https://docs.stripe.com/payments/payment-intents)
