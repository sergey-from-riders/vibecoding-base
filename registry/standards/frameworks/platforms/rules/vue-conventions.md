---
schema_version: 1
id: "frameworks.vue-conventions"
title: "Vue: SFC, props, события и имена компонентов"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["Vue 3.3+", "TypeScript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1210
related: ["frameworks.vue-computed", "frontend.derived-state"]
sources: ["https://vuejs.org/api/sfc-script-setup.html", "https://vuejs.org/guide/components/props.html", "https://vuejs.org/guide/reusability/composables.html"]
---

# Vue: SFC, props, события и имена компонентов

## Коротко

Для нового Vue-компонента объявляйте входные props и исходящие события. Компонент не меняет состояние владельца скрытно; формат SFC, имена и стиль API выбираются последовательно в пределах проекта.

## Плохо

```vue
<script setup>
const props = defineProps(['order']);
function select() {
  props.order.selected = true; // Скрытая запись в объект родителя.
}
</script>
```

## Хорошо

```vue
<script setup lang="ts">
const props = defineProps<{ id: number; title: string }>();
const emit = defineEmits<{ select: [id: number] }>();
</script>

<template>
  <button type="button" @click="emit('select', props.id)">
    {{ props.title }}
  </button>
</template>
```

## Почему

Явный интерфейс компонента показывает, кто владеет данными и какое действие ожидается снаружи. Изменение вложенного prop может технически работать, но делает связь с родителем скрытой.

## Когда применять

Пример: Vue 3.3+ SFC и TypeScript, tuple-синтаксис defineEmits. Для существующего Options API сохраните его согласованный стиль; переход на script setup не является обязательным условием качества.

В новом профиле выбираются `OrderCard.vue`, PascalCase компонентов в SFC, `useOrders` для composable и camelCase локальных переменных. Другой принятый вариант имени файла допустим при последовательном применении; это не ограничение Vue. В DOM templates действуют ограничения HTML на регистр, поэтому не переносите туда SFC-соглашение без проверки.

defineProps/defineEmits — compiler macros внутри script setup, они не требуют runtime-import. TypeScript описывает интерфейс разработки, но не валидирует произвольный сетевой JSON: он проверяется на границе данных. Не дублируйте один prop одновременно runtime- и type-declaration.

Props доступны для чтения; изменение состояния родителя выполняется через событие/явный контракт v-model. Для производных значений используйте computed, для эффектов — lifecycle/watch с cleanup. Destructuring props реактивен по умолчанию только в соответствующих версиях compiler, в частности Vue 3.5+; пример обращается через props и не зависит от этого различия.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Родитель передал id/title; пользователь нажал кнопку | Один select с исходным id, входные данные не мутированы | Component test |
| Родитель изменил title без remount | Отображение обновилось | Проверка реактивности |
| Передано неверное имя события или тип prop | Проверка SFC/types обнаруживает контрактную ошибку | vue-tsc/сборка проекта |
| Компонент снят после подписки/таймера | Ресурс освобожден, поздний эффект не пишет в старый экземпляр | Lifecycle-тест |

Сам TypeScript не доказывает корректность JSON от сервера или отсутствие эффекта в runtime.

## Человек

Определяет владельца состояния и публичный интерфейс компонента.

## Агент

Соблюдает выбранный API-стиль, версии compiler macros и cleanup. Не переименовывает весь legacy UI ради единого примера.

## Источники

- [Vue: script setup](https://vuejs.org/api/sfc-script-setup.html)
- [Vue: props](https://vuejs.org/guide/components/props.html)
- [Vue: composables](https://vuejs.org/guide/reusability/composables.html)
