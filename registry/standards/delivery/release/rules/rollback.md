---
id: "operations.rollback"
title: "Rollback"
section: "operations"
level: "required"
tags: ["rollback"]
technologies: []
reviewed_at: "2026-11-09"
order: 88
related: ["operations.immutable-release", "database.migrations"]
sources: ["https://sre.google/workbook/canarying-releases/"]
schema_version: 1
---

# Rollback

## Коротко

До переключения определите, как вернуть сервис и что произойдёт с данными.

## Плохо

```text
Ошибка после выпуска → ищем старую сборку.
```

## Хорошо

```text
Старый релиз сохранён.
Новая схема совместима.
Возврат проверен заранее.
```

## Почему

Быстрый откат кода бесполезен, если старая версия не понимает новую схему.

## Когда применять

Не откатывайте миграцию с потерей данных автоматически. Иногда нужен исправляющий релиз.

## Как проверить

- Старый код запускается на новой схеме?

## Человек

Определяет признаки неудачного выпуска и допустимый способ возврата.

## Агент

Готовит воспроизводимые команды, проверяет состояние сервисов и прикладывает фактический результат.

Контроль результата:

- Старый код запускается на новой схеме?

## Источники

- [Google SRE - Canary Release: Deployment Safety and Efficiency](https://sre.google/workbook/canarying-releases/)
