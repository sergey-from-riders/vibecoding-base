---
id: "security.supply-chain"
title: "Software supply chain"
section: "security"
level: "recommended"
tags: ["supply-chain"]
technologies: []
reviewed_at: "2026-11-09"
order: 75
related: ["operations.immutable-release", "architecture.choose-dependencies"]
sources: ["https://slsa.dev/spec/v1.2/"]
schema_version: 1
---

# Software supply chain

## Коротко

Фиксируйте воспроизводимый набор зависимостей и обновляйте его с проверками.

## Плохо

```text
Сборка каждый раз устанавливает произвольный latest.
```

## Хорошо

```text
Lockfile + зафиксированный runtime.
Обновления проходят проверку уязвимостей и тесты.
```

## Почему

Один исходный коммит должен позволять объяснить, что вошло в сборку.

## Когда применять

SBOM и provenance зависят от зрелости выпуска. Наличие файла не доказывает соответствие уровню SLSA.

## Как проверить

- В чистой среде устанавливаются те же зависимости?

## Человек

Выбирает доверенные источники и допустимый риск обновления.

## Агент

Реализует серверные ограничения и проверяет запрещённый запрос наряду с разрешённым.

Контроль результата:

- В чистой среде устанавливаются те же зависимости?

## Источники

- [SLSA • SLSA specification](https://slsa.dev/spec/v1.2/)
