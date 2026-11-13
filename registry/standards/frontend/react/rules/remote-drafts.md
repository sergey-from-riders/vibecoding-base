---
id: "frontend.remote-drafts"
title: "Черновики и серверное состояние"
section: "frontend"
level: "recommended"
tags: ["remote-drafts", "React"]
technologies: ["React"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 48
related: ["frontend.server-client", "frontend.data-boundary"]
sources: ["https://react.dev/learn/choosing-the-state-structure", "https://react.dev/reference/react/useEffect", "https://www.rfc-editor.org/rfc/rfc9110.html#section-13.1.1"]
schema_version: 1
---

# Черновики и серверное состояние

## Коротко

Отделяй серверный снимок с revision от локального черновика.

## Плохо

```text
Каждый refetch: setDraft(serverValue).
Сохранение: UPDATE без revision.
Любой успешный ответ: dirty=false, даже если пользователь уже продолжил ввод.
```

## Хорошо

```text
clean(r5) → ввод → dirty(r5) → отправка draft-v2 → saving.
Пока идет запрос: появился draft-v3.
Сервер: compare r5, сохранить v2, вернуть r6.
Клиент: base=r6, draft-v3 остается dirty.
При несовпадении revision: conflict; оба значения доступны, ввода не теряем.
```

## Почему

Фоновое чтение и параллельное сохранение не должны незаметно уничтожать ввод или изменения другого участника.

## Когда применять

Для редактирования удаленных данных, которые могут обновляться параллельно. Revision может быть версией записи или ETag с If-Match; конкретный протокол выбирается контрактом. Предупреждение при уходе — дополнение: браузер не гарантирует событие при закрытии процесса.

### Подробные условия

Минимальные состояния: clean, dirty, saving и conflict. Refetch обновляет clean-снимок, но не перезаписывает dirty-ввод; он сообщает о новой серверной версии. Сохранение передает ожидаемую revision, а сервер атомарно сравнивает ее перед записью, например через compare-and-swap.

При успехе обнови revision и исходный снимок. Сбрасывай dirty только для той версии ввода, которая отправлялась: правки, сделанные во время saving, остаются dirty. Конфликт сохраняет оба варианта и предлагает перечитать, сравнить/объединить либо явно повторить по новому контракту; безусловный overwrite не является обработкой конфликта. При смене записи, аккаунта и уходе задается явная политика сохранения/сброса. Секретные черновики не сохраняются в общий storage автоматически.

## Как проверить

- Clean-форма → refetch → обновлена; dirty-форма → refetch → ввод сохранен и показана новая версия.
- Два клиента сохраняют одну revision → сервер применяет CAS → один успех, другой конфликт без потери данных.
- Пользователь дописал во время saving, затем сменил запись/аккаунт → обработать → новый ввод не помечен сохраненным и не показан другому аккаунту.

## Человек

Выбирает политику конфликта и допустимое хранение несохраненного ввода.

## Агент

Проверяет серверный CAS и гонку подтверждения; не полагается только на кнопку disabled или beforeunload.

## Источники

- [React: Choosing the State Structure](https://react.dev/learn/choosing-the-state-structure) — Contradictions, redundancy and duplicated state.
- [React: useEffect](https://react.dev/reference/react/useEffect) — Dependencies, cleanup and race conditions in data fetching.
- [RFC 9110, section 13.1.1: If-Match](https://www.rfc-editor.org/rfc/rfc9110.html#section-13.1.1) — Предусловие изменения и защита от lost update; не требует конкретного UI.
