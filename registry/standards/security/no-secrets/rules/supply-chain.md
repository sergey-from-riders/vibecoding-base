---
id: "security.supply-chain"
title: "Software supply chain"
section: "security"
level: "recommended"
tags: ["supply-chain"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 75
related: ["security.secrets", "operations.immutable-release", "architecture.choose-dependencies"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Software_Supply_Chain_Security_Cheat_Sheet.html", "https://slsa.dev/spec/v1.2/verifying-artifacts"]
schema_version: 1
---

# Software supply chain

## Коротко

Фиксируйте и проверяйте все внешние входы сборки, включая toolchain, base image, плагины и бинарные загрузки. Lockfile описывает часть зависимостей и не доказывает происхождение готового артефакта.

## Плохо

```text
Lockfile закоммичен, но FROM runtime:latest и curl latest/tool | sh.
Наличие SBOM объявлено доказательством безопасной воспроизводимой сборки.
```

## Хорошо

```text
Реестр входов: source commit, dependency resolution, toolchain/platform,
base image digest, build plugins, downloaded binaries и trusted source.
Сборка проверяет integrity/подпись по выбранной политике.
Обновления и advisories → triage owner → исправление или срочное исключение.
Provenance проверяется отдельно для digest публикуемого артефакта.
```

## Почему

Одинаковые версии библиотек не фиксируют OS-пакеты, генераторы и сеть build scripts. Наличие хеша обнаруживает изменение только при доверенном ожидаемом значении; хеш рядом со скомпрометированным файлом не подтверждает автора. Повторяемое разрешение зависимостей, побитовая reproducible build и проверенная provenance — разные свойства.

## Когда применять

Для проектов с исполняемыми зависимостями или build pipeline; документационному каталогу без сборки не нужно добавлять package manager ради этого правила. У приложения/сервиса lock/resolution и integrity фиксируются предусмотренным экосистемой способом; библиотеки отдельно объявляют поддерживаемые диапазоны и тестируют их. Container release фиксирует base image digest и платформу; external tool/download имеет версию, доверенный источник и проверяемый digest/подпись. Скрытые сетевые установки в build требуют учета или запрета.

Составьте актуальный inventory зависимостей, toolchain, plugins и развернутых компонентов; SBOM может быть его машинным представлением, но не автоматически полным. Проверяйте advisories по версии и применимости; оцените достижимость, exploitability и влияние, не считайте scanner severity единственным решением. Подтвержденная значимая проблема получает владельца и срок обновления/изоляции; временное исключение содержит обоснование, компенсирующие меры и expiry, после которого блокировка возвращается.

Если профиль требует provenance, проверяйте signature/identity доверенного builder, subject digest, ожидаемые source/buildType/parameters и заявленный уровень по SLSA. Просто сгенерированный JSON или подпись неизвестного автора не выполняют эту проверку. Полное соответствие SLSA не выводится из данного правила. Побитовую воспроизводимость заявляйте только после отдельной сборки и сравнения артефактов в объявленной среде.

## Как проверить

1. Чистая среда с зафиксированными входами → установка/сборка → используются ожидаемые версии/digests без скрытого latest → inventory и build evidence.

2. Подменен binary/base image или subject provenance не совпадает → проверка → непроверенный артефакт не публикуется → отказ integrity/trust policy.

3. Появился применимый advisory или истекло исключение → triage/release gate → назначено исправление/изоляция, просроченное исключение не молча действует → owner/expiry/решение.

## Человек

Выбирает доверенные источники, требуемые свойства сборки, сроки исправления и владельца исключений.

## Агент

Инвентаризирует все входы, проверяет integrity и применимость advisories, отделяет lockfile от provenance и побитовой воспроизводимости.

## Источники

- [OWASP Software Supply Chain: dependency pinning, build tools inventory, deployed monitoring](https://cheatsheetseries.owasp.org/cheatsheets/Software_Supply_Chain_Security_Cheat_Sheet.html)
- [SLSA v1.2 Build: Verifying artifacts, steps 1–2](https://slsa.dev/spec/v1.2/verifying-artifacts)
