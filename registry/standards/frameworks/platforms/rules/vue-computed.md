---
schema_version: 1
id: "frameworks.vue-computed"
title: "Vue: computed и производное состояние"
section: "frameworks"
level: "recommended"
tags: ["vue-computed", "Vue", "TypeScript"]
technologies: ["Vue", "TypeScript"]
reviewed_at: "2026-11-09"
order: 113
related: ["frontend.derived-state", "database.money"]
sources: ["https://vuejs.org/guide/essentials/computed.html"]
---

# Vue: computed и производное состояние

## Коротко

Значение, выводимое из реактивных данных, вычисляйте через computed без побочных эффектов.

## Плохо

```typescript
const total = ref(0);
watch(items, () => { total.value = sum(items.value); });
```

## Хорошо

```typescript
import { computed } from 'vue';
const total = computed(() => sum(items.value));
```

## Почему

Отдельное изменяемое total может отстать от исходных данных. computed описывает зависимость напрямую.

## Когда применять

Vue 3 Composition API. items — ref, sum — чистая функция. Watch остаётся подходящим инструментом для побочных действий; денежная арифметика требует точного представления.

## Человек

Определяет формулу итоговой суммы и округление.

## Агент

Выносит чистое вычисление в computed и проверяет изменение элементов.

## Пример применения

Корзина хранит позиции и количество. Итог вычисляется из них; сервер повторно рассчитывает стоимость перед оплатой.

## Как проверить

- Изменение количества обновляет итог.
- Вычисление не изменяет исходные данные.

## Источники

- [Computed Properties](https://vuejs.org/guide/essentials/computed.html)
