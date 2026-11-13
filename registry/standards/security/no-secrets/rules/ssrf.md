---
id: "security.ssrf"
title: "SSRF-защита"
section: "security"
level: "required"
tags: ["ssrf"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 73
related: ["integrations.files", "integrations.timeouts", "security.resource-limits"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html"]
schema_version: 1
---

# SSRF-защита

## Коротко

Недоверенный URL не должен определять произвольное серверное подключение. Политика назначения проверяется до и во время connect, включая DNS, redirects, retries и proxy.

## Плохо

```text
if url.startswith("https://trusted.example"):
    http.get(url)  # повторный DNS и redirects идут без проверки назначения
```

## Хорошо

```text
Профиль: только HTTPS:443 к точным разрешенным host, без userinfo.
Разобрать URL стандартным parser → проверить origin/путь по политике.
Разрешить A/AAAA → проверить все адреса → connect только к проверенным.
Сохранить исходные Host/SNI и проверку сертификата.
Redirect отключен; лимиты времени и bytes до/после decompression.
```

## Почему

Prefix совпадает с чужим доменом вроде trusted.example.attacker.invalid. Даже правильный hostname может после проверки разрешиться в другой IP: отдельный непроверенный DNS lookup при connect создает TOCTOU. Redirect, IPv6 или proxy могут изменить фактическое назначение без изменения первоначальной проверки.

## Когда применять

Для URL импортов, preview, webhook destinations, image fetch и других запросов, влияющих на сеть сервера. Если набор сервисов известен, принимайте service ID/относительный путь и используйте серверный URL; точная allowlist origins предпочтительнее произвольного URL. Пример — узкий HTTPS:443 профиль, не запрет всех легитимных внутренних интеграций: внутренние адреса допускаются только отдельным явным разрешением.

При необходимости URL используйте один согласованный parser; разрешите конкретные схемы/порты, запретите userinfo и непредусмотренные URL forms. Нормализуйте IP, включая IPv4-mapped IPv6; проверяйте все A/AAAA и запрещенные loopback/private/link-local/metadata/служебные сети для public-fetch профиля. Ошибка DNS/неизвестная классификация не считается разрешением. Соединение, fallback и retry должны использовать только проверенные IP с сохранением TLS hostname verification, либо эквивалентный контролируемый egress proxy. Нельзя отключать TLS ради pinning.

Redirect по умолчанию выключен; если нужен, ограничьте hops и повторите политику каждого назначения, не пересылайте credentials/cookies в другой origin. Ограничьте connect/total timeout, response headers и байты до/после распаковки. Принудительный egress firewall/proxy закрывает доступ к запрещенным сетям, включая обход через настройки окружения HTTP-клиента. Для произвольного public-fetch нужна изолированная сетевая роль; одной blocklist строк недостаточно.

## Как проверить

1. Разрешенный host с допустимыми IP → fetch → соединение только с проверенным адресом при валидном TLS → наблюдение actual peer/egress.

2. Домен меняет DNS между validation/connect; mixed A/AAAA содержит private IP → попытка → запрещенный peer не достигается → контролируемый DNS/сеть тестового стенда.

3. Redirect на metadata, userinfo/неразрешенный порт, compressed oversized response → fetch → отказ/обрыв в бюджете без передачи credentials → destination и byte/time metrics.

## Человек

Задает допустимые назначения, сетевые роли, исключения внутренних сервисов и ресурсные бюджеты fetch.

## Агент

Проверяет actual connection policy, DNS rebinding, redirect/fallback и egress, не подменяя это проверкой строкового prefix.

## Источники

- [OWASP SSRF Prevention: allowlist, DNS rebinding, connection-time validation, network layer](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
