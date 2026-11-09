---
id: "collaboration.ownership"
title: "Распределение изменений"
section: "collaboration"
level: "recommended"
tags: ["ownership"]
technologies: []
reviewed_at: "2026-11-09"
order: 14
related: ["collaboration.small-pr", "collaboration.preserve-changes"]
sources: ["https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners", "https://git-scm.com/docs/git-worktree"]
schema_version: 1
---

# Распределение изменений

## Коротко

Договоритесь, кто меняет общий контракт и какие файлы затрагивает каждый участник.

## Плохо

```text
Два агента одновременно переписывают один модуль.
```

## Хорошо

```text
Один меняет контракт.
Другой работает в согласованном компоненте.
Совместная проверка после объединения.
```

## Почему

Отдельные рабочие каталоги не устраняют смысловые конфликты.

## Когда применять

Это инженерное правило справочника, а не требование протокола. Первоисточник описывает подход или механизм; конкретный процесс выбирается проектом.

Для людей и агентов. Небольшую последовательную задачу не нужно искусственно распараллеливать.

## Как проверить

- У общих файлов есть ответственный?

## Человек

Назначает владельцев компонентов и порядок объединения параллельных изменений.

## Агент

Проверяет рабочее дерево, сохраняет чужие изменения и передаёт diff, команды проверки и ограничения.

Контроль результата:

- У общих файлов есть ответственный?

## Источники

- [About code owners - GitHub Docs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Git - git-worktree Documentation](https://git-scm.com/docs/git-worktree)
