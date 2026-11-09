---
id: "collaboration.preserve-changes"
title: "Рабочее дерево Git"
section: "collaboration"
level: "required"
tags: ["preserve-changes"]
technologies: []
reviewed_at: "2026-11-09"
order: 15
related: ["collaboration.small-pr", "collaboration.ownership"]
sources: ["https://git-scm.com/docs/git-status", "https://git-scm.com/docs/git-reset"]
schema_version: 1
---

# Рабочее дерево Git

## Коротко

Перед началом проверьте рабочее дерево и отделите собственные изменения.

## Плохо

```text
Неизвестный файл мешает → git reset --hard.
```

## Хорошо

```text
Проверка diff.
Свои изменения в отдельной ветке.
Чужая работа сохранена.
```

## Почему

Массовый сброс может уничтожить результат другого участника.

## Когда применять

Особенно важно в общей папке; удаление требует понимания происхождения изменений.

## Как проверить

- Сравните состояние до и после задачи.

## Человек

Уточняет принадлежность незавершённых изменений, если это нельзя установить по истории.

## Агент

Проверяет рабочее дерево, сохраняет чужие изменения и передаёт diff, команды проверки и ограничения.

Контроль результата:

- Сравните состояние до и после задачи.

## Источники

- [Git - git-status Documentation](https://git-scm.com/docs/git-status)
- [Git - git-reset Documentation](https://git-scm.com/docs/git-reset)
