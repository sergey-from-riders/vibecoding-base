---
schema_version: 1
id: "languages.go-imports"
title: "Go: явные imports и границы пакета"
section: "languages"
level: "recommended"
tags: ["go", "imports", "basics"]
technologies: ["Go"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1002
related: ["languages.go-naming", "backend.boundaries"]
sources: ["https://go.dev/wiki/CodeReviewComments", "https://go.dev/ref/spec"]
---

# Go: явные imports и границы пакета

## Коротко

Импортируйте пакет под его обычным именем и обращайтесь через qualifier. Стандартная библиотека идет первой группой; исключения для alias, dot и side-effect imports должны иметь причину.

## Плохо

```go
package greeting

import . "fmt"
import s "strings"

func Greeting(name string) string {
    return Sprintf("Hello, %s", s.TrimSpace(name))
}
```

## Хорошо

```go
package greeting

import (
	"fmt"
	"strings"
)

// Greeting возвращает приветствие без пробелов по краям имени.
func Greeting(name string) string {
	return fmt.Sprintf("Hello, %s", strings.TrimSpace(name))
}
```

## Почему

Qualifier показывает происхождение вызова. Import cycle запрещен самим Go; неиспользуемый обычный import тоже ошибка компиляции. Автоматическое добавление import не подтверждает, что выбран правильный модуль или что его init не имеет нежелательных эффектов.

## Когда применять

Для Go packages. Сначала stdlib, затем внешние/проектные группы с пустой строкой по принятому профилю. Alias используйте при конфликте имен или устойчивом обоснованном API-контексте, а не для сокращения каждого имени. Dot-import не используйте в обычном коде; узкое исключение возможно в внешнем test package, когда оно обосновано, но явный qualifier предпочтителен.

Blank import означает выполнение init/registration; используйте его в точке сборки приложения или нужном тесте с пояснением, например для регистрации driver. Он не должен быть способом скрыть unused import. Не запускайте неуправляемые сетевые операции/долгие фоновые процессы в init. При цикле зависимостей пересмотрите расположение общего контракта; не обходите проблему ручным копированием пакета.

gofmt форматирует исходник. goimports может добавлять/удалять imports и группировать их, если проект выбрал закрепленную версию инструмента; результат и изменение go.mod проверяются человеком. Сборка выполняется для поддерживаемых tags/platforms, поскольку разные файлы могут иметь разные imports.

## Как проверить

1. Обычный импорт fmt/strings → сборка → вызовы явно принадлежат пакетам, unused imports нет → go test/go vet.

2. Добавлен цикл A→B→A либо лишний import → сборка → ошибка обнаружена → compiler output.

3. Нужен side-effect driver либо alias-конфликт → review → назначение и точка регистрации понятны, startup остается управляемым → import/init review.

## Человек

Выбирает профиль группировки и допустимые side-effect imports.

## Агент

Проверяет происхождение пакета, цикл и init; использует formatter без слепого принятия нового модуля.

## Источники

- [Go Code Review Comments: Imports, Import Blank, Import Dot, Gofmt](https://go.dev/wiki/CodeReviewComments)
- [Go Specification: Import declarations и initialization](https://go.dev/ref/spec)
