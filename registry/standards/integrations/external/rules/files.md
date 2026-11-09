---
id: "integrations.files"
title: "Проверяйте загруженный файл на сервере"
section: "integrations"
level: "required"
tags: ["files"]
technologies: []
reviewed_at: "2026-11-09"
order: 63
related: ["integrations.timeouts", "integrations.retries"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html"]
schema_version: 1
---

# Проверяйте загруженный файл на сервере

## Коротко

Имя и Content-Type от клиента не доказывают безопасность содержимого.

## Плохо

```text
Разрешён .png → сохраняем как исполняемый файл по имени клиента.
```

## Хорошо

```text
Ограничиваем размер и тип.
Генерируем имя. Храним вне исполняемого каталога.
```

## Почему

Загрузка может принести исполняемый код, переполнение хранилища или опасный документ.

## Когда применять

Нужные сканеры и преобразования зависят от типа файла. Проверяйте права на скачивание отдельно.

## Как проверить

- Проверьте неверный тип, большой файл, путь ../ и чужой доступ.

## Источники

- [Первоисточник](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
