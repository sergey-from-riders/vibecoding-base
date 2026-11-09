---
schema_version: 1
id: "frameworks.bitrix-local"
title: "1С-Битрикс: /local и расширения"
section: "frameworks"
level: "recommended"
tags: ["bitrix-local", "1С-Битрикс", "PHP"]
technologies: ["1С-Битрикс", "PHP"]
reviewed_at: "2026-11-09"
order: 105
related: ["collaboration.preserve-changes", "operations.immutable-release"]
sources: ["https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33874&LESSON_PATH=33872.33874"]
---

# 1С-Битрикс: /local и расширения

## Коротко

Собственный код размещайте в /local, используя расширения и шаблоны компонентов.

## Плохо

```text
/bitrix/components/bitrix/news.list/templates/.default/template.php
/bitrix/modules/main/lib/application.php
```

## Хорошо

```text
/local/components/project/events.list/
/local/templates/site/components/bitrix/news.list/events/
```

## Почему

Обновление продукта перезаписывает ядро. Собственный компонент или переопределённый шаблон имеет ясную границу изменений.

## Когда применять

Bitrix Framework с поддержкой /local (D7). Не копируйте ядро целиком. На унаследованном проекте сначала найдите существующие изменения и спланируйте их перенос.

## Человек

Определяет нужное поведение и согласует перенос старых доработок.

## Агент

Находит точку расширения, переносит только необходимое и проверяет компонент на стенде.

## Пример применения

Нужно изменить карточку мероприятия в news.list. Агент создаёт шаблон events в /local/templates/site/components/bitrix/news.list/ и выбирает его в вызове компонента.

## Как проверить

- Diff не меняет системное ядро.
- После обновления тестового стенда компонент работает.

## Источники

- [Урок 1. Разворачиваем стенд и знакомимся с проектом](https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=33874&LESSON_PATH=33872.33874)
