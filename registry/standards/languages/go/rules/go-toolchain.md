---
schema_version: 1
id: "languages.go-toolchain"
title: "Go: версия toolchain и граф модулей"
section: "languages"
level: "recommended"
tags: ["go", "toolchain", "modules", "basics"]
technologies: ["Go"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1004
related: ["languages.go-imports", "security.supply-chain", "backend.bounded-concurrency"]
sources: ["https://go.dev/doc/toolchain", "https://go.dev/ref/mod"]
---

# Go: версия toolchain и граф модулей

## Коротко

У Go-проекта есть объявленный minimum Go version, выбранная toolchain для проверки и контролируемый граф модулей. go.sum не является полным lockfile и не фиксирует компилятор.

## Плохо

```text
go get -u ./... на каждой сборке.
Версия Go берется из latest; go.sum удаляется при конфликте.
Локальный replace ../shared попадает в release незаметно.
```

## Хорошо

```text
В среде с выбранной версией Go:
  go version
  go env GOTOOLCHAIN GOMOD
  go mod verify
  go test -mod=readonly ./...
  go vet ./...
Изменения go.mod/go.sum и toolchain проходят review отдельно от сборки.
```

## Почему

Начиная с Go 1.21 go directive задает минимальную версию, а toolchain/GOTOOLCHAIN влияют на фактически используемый compiler, включая автоматическое переключение. go.mod участвует в minimum version selection; go.sum хранит проверочные суммы, а не произвольное обещание зафиксировать все входы сборки.

## Когда применять

Для Go modules. Сохраняйте go.mod и нужный go.sum; при отсутствии внешних зависимостей пустой go.sum не требуется. Минимальная версия выбирается по используемому языку/API, фактическая CI/release toolchain и supported platforms фиксируются отдельно. Если automatic download toolchain разрешен, его политика и выбранная версия должны быть видны; при запрете несовместимая версия должна явно отказать.

После намеренного изменения зависимостей выполняйте tidy и review diff, проверяйте replace/exclude и роль go.work. Локальный workspace не должен скрывать отсутствующий или другой release module. Версии внешних generators/linters также фиксируются; не выполняйте update latest при каждой сборке. go mod verify обнаруживает изменения загруженного module cache, но не доказывает отсутствие уязвимостей/вредоносного кода и не заменяет supply-chain policy.

В примере команды выполняются в модуле приложения-потребителя. go test проверяет текущие build tags/platform; матрица поддерживаемых вариантов задается проектом. Race detector используется для relevant concurrent paths отдельно и не является доказательством отсутствия всех races. Старые toolchain обновляются по политике поддержки/исправлений, а не закрепляются навсегда.

## Как проверить

1. Чистая среда с выбранной toolchain → build/test → версии и module graph совпадают с объявленными, go.mod не меняется → вывод версии и diff.

2. Toolchain старше minimum при запрещенном switch → команда → явный отказ, а не незаметная подмена → stderr.

3. Локальный replace/workspace либо измененный cache → release check → неучтенный путь или integrity failure обнаружен → module graph/verify.

## Человек

Задает поддерживаемые версии/платформы и политику обновления toolchain/modules.

## Агент

Фиксирует фактическую версию и graph, проверяет tidy diff и не объявляет go.sum доказательством безопасной сборки.

## Источники

- [Go Toolchains: go/toolchain/GOTOOLCHAIN и minimum version](https://go.dev/doc/toolchain)
- [Go Modules Reference: MVS, go.mod/go.sum, tidy и verify](https://go.dev/ref/mod)
