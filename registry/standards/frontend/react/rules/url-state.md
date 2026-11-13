---
id: "frontend.url-state"
title: "Состояние в URL"
section: "frontend"
level: "recommended"
tags: ["url-state", "React"]
technologies: ["React"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 49
related: ["frontend.server-client", "frontend.data-boundary"]
sources: ["https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams", "https://developer.mozilla.org/en-US/docs/Web/API/History_API/Working_with_the_History_API", "https://react.dev/reference/react/useEffect"]
schema_version: 1
---

# Состояние в URL

## Коротко

Состояние, которое должно восстанавливаться по ссылке и истории, кодируй в URL с явной схемой.

## Плохо

```javascript
const page = Number(new URLSearchParams(location.search).get('page'));
// 0, NaN, дроби и повторяющиеся параметры не разобраны.
// Каждый символ поиска создает history entry; старый ответ всегда применяется.
```

## Хорошо

```javascript
export function parseListState(search) {
  const params = new URLSearchParams(search);
  const raw = params.get('page') ?? '1'; // пример политики: первый параметр
  const page = /^[1-9][0-9]*$/.test(raw) ? Number(raw) : 1;
  return { page: Number.isSafeInteger(page) && page <= 1000 ? page : 1 };
}
export function serializeListState(state) {
  const checked = parseListState(`page=${encodeURIComponent(state.page)}`);
  return checked.page === 1 ? '' : `page=${checked.page}`;
}
```

## Почему

Явное кодирование делает закладку воспроизводимой и не позволяет некорректному параметру создать неоднозначный экран.

## Когда применять

Для пагинации, фильтров и выбранных вкладок, которые должны быть ссылочными. Локальное transient-состояние не обязано попадать в URL. В примере диапазон 1–1000, первое повторение и игнорирование неизвестных ключей — выбранный контракт этого списка, не универсальная норма.

### Подробные условия

Определи тип, default, диапазон, повторяющиеся и неизвестные параметры. URL остается недоверенным вводом; parse/serialize должны давать устойчивое каноническое представление. Секреты, токены и чувствительные черновики туда не помещаются.

Навигационный выбор обычно добавляет запись history через push; частое промежуточное редактирование/канонизация может использовать replace по выбранному UX. Back/Forward восстанавливают данные из актуального URL. При смене фильтра сбрось page, если старая страница больше не имеет смысла. Ответ старого запроса не должен заменить результат нового URL.

## Как проверить

- page=3 → parse и serialize, затем reload → та же страница; page=1 канонизируется без параметра.
- page=-1, 1.5, очень большое число или отсутствие → parse → безопасный default 1; повторения обрабатываются по описанной политике.
- Изменение фильтра, затем Back и ответы в обратном порядке → восстановить → page сброшен по контракту, UI соответствует текущему URL.

## Человек

Выбирает ссылочные параметры и ожидаемое поведение history.

## Агент

Проверяет round-trip, канонизацию и актуальность ответа, не добавляет приватные значения в URL.

## Источники

- [MDN: URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams) — Parsing, encoding, repeated keys and serialization.
- [MDN: Working with the History API](https://developer.mozilla.org/en-US/docs/Web/API/History_API/Working_with_the_History_API) — pushState, replaceState and popstate.
- [React: useEffect](https://react.dev/reference/react/useEffect) — Dependencies, cleanup and race conditions in data fetching.
