---
id: "languages.module-boundaries"
title: "Модули и разрешение импортов"
section: "languages"
level: "recommended"
tags: ["modules", "imports"]
technologies: ["javascript", "typescript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1106
related: ["languages.javascript-naming", "frontend.server-client"]
sources: ["https://www.typescriptlang.org/docs/handbook/modules/reference.html", "https://nextjs.org/docs/app/getting-started/server-and-client-components"]
schema_version: 1
---

# Модули и разрешение импортов

## Коротко

Определи публичные экспорты модуля и разрешенное направление зависимостей; внутренние файлы не становятся стабильным API по факту доступности пути.

## Плохо

```text
TypeScript принимает alias @internal/db.
Его runtime-поддержка не настроена; браузер импортирует Node-only пакет.
Импорт типа считается гарантией выполнения регистрации модуля.
```

## Хорошо

```text
Контракт: публичный export модели; внутренний путь не обещан потребителю.
Node ESM со сборкой: выбран совместимый moduleResolution и runtime specifier.
Type-only зависимость: import type; side effect, если нужен, импортирован явно.
Проверка: чистая сборка и запуск разрешенного entrypoint в целевой среде.
Browser entrypoint не включает server-only зависимость.
```

## Почему

Компилятор, bundler и runtime решают разные задачи. Несогласованное разрешение импортов может пройти проверку типов и отказать только после выпуска.

## Когда применять

Для JS/TS модулей и пакетов. Расширения и правила ESM/CommonJS зависят от runtime и сборки; не навязывай один режим браузеру, Node и тестовому runner. Пример описывает контракт проверки, а не готовую конфигурацию.

### Подробные условия

Не создавай слой или barrel-файл без задачи: сокрытие реализации, совместимость либо повторное использование.

Согласуй module/moduleResolution, package type, расширения импортов и bundler с фактическим runtime. Успешный typecheck не гарантирует, что модуль найдется при исполнении. paths в tsconfig сам по себе не переписывает emitted imports. Для импорта только типов используй import type, если это соответствует toolchain; он не должен неявно обеспечивать нужный side effect. Серверные зависимости не импортируются в браузерный модуль.

## Как проверить

- Публичный entrypoint → собрать и запустить в целевой среде → зависимости разрешены без скрытого local alias.
- Alias известен только tsconfig → выполнить runtime-проверку → проблема выявлена до выпуска.
- Type-only import удален при сборке, а регистрация нужна → проверить → side effect импортирован отдельно либо архитектура исправлена.

## Человек

Определяет публичную границу и поддерживаемые runtime/toolchain.

## Агент

Проверяет реальный запуск entrypoint и граф зависимостей, не маскирует runtime-ошибку дополнительным assertion.

## Источники

- [TypeScript: Modules Reference](https://www.typescriptlang.org/docs/handbook/modules/reference.html) — Type-only imports, module resolution, paths and emitted specifiers.
- [Next.js App Router: Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components) — Client module graph, serializable props and server-only modules.
