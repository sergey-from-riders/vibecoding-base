---
id: "database.time-money"
title: "Храните момент времени и деньги без двусмысленности"
section: "database"
level: "recommended"
tags: ["time-money", "SQL"]
technologies: ["SQL"]
reviewed_at: "2026-11-09"
order: 26
related: ["database.identifiers", "database.naming"]
sources: ["https://www.postgresql.org/docs/18/ddl.html"]
schema_version: 1
---

# Храните момент времени и деньги без двусмысленности

## Коротко

Для денег задавайте валюту и точность, для времени различайте момент и местное расписание.

## Плохо

```text
price = 0.1 + 0.2
meeting = "09.11.2026 10:00"
```

## Хорошо

```text
amount_minor = 30; currency = "RUB"
created_at timestamptz
meeting_zone = "Europe/Moscow"
```

## Почему

Двоичная дробь может округляться неожиданно; время без зоны не всегда определяет момент.

## Когда применять

Для денег подходят integer minor units или numeric с политикой округления. Для будущего местного расписания храните также часовую зону; timestamptz её название не сохраняет.

## Как проверить

- Проверены округление, валюта и переходы часового пояса?

## Источники

- [Первоисточник](https://www.postgresql.org/docs/18/ddl.html)
