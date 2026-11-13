---
schema_version: 1
id: "mobile.react-native-conventions"
title: "React Native: компоненты, типы и платформенный профиль"
section: "mobile"
level: "recommended"
tags: ["mobile", "conventions"]
technologies: ["React Native", "TypeScript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1214
related: ["mobile.deep-links", "mobile.native-release", "mobile.secure-storage"]
sources: ["https://reactnative.dev/docs/typescript", "https://reactnative.dev/docs/platform-specific-code", "https://reactnative.dev/docs/intro-react-native-components"]
---

# React Native: компоненты, типы и платформенный профиль

## Коротко

Опишите платформенный профиль приложения до добавления экранов: версии React Native/Expo, навигацию, JS/TS-проверку и границу native-кода. Компонент использует native primitives и явные props, а платформенные различия локализованы.

## Плохо

```tsx
export function OrderScreen(props: any) {
  return <div onClick={() => window.location.href = '/pay'}>
    {props.title}
  </div>; // DOM API ошибочно считается частью iOS/Android runtime.
}
```

## Хорошо

```tsx
import { Pressable, Text } from 'react-native';

type OrderCardProps = {
  title: string;
  onSelect: () => void;
};

export function OrderCard({ title, onSelect }: OrderCardProps) {
  return (
    <Pressable accessibilityRole="button" onPress={onSelect}>
      <Text>{title}</Text>
    </Pressable>
  );
}
```

## Почему

React Native рендерит платформенные компоненты, а не DOM браузера. Сборщик может преобразовать TypeScript без проверки типов; успешный JS bundle не подтверждает корректность native-интеграции.

## Когда применять

iOS/Android React Native; пример предполагает TypeScript-профиль. Зафиксируйте точные React/React Native, поддерживаемые OS, native build tools и, при использовании, Expo SDK/Router. Expo и собственные native-проекты допустимы; способ обновления native-файлов и конфигурации должен быть один и понятный.

Новые компоненты/экраны называются PascalCase, hooks — useCamelCase, обычные функции — camelCase по принятому JS/TS-профилю. JSX хранится в .tsx, не-JSX типизированный код — в .ts; JS допустим в существующем согласованном профиле. Не добавляйте any для скрытия несовместимого native API.

Небольшое различие оформляйте через Platform, значительное — файлами .ios/.android с одинаковым публичным интерфейсом. Сборка должна выбирать реализацию на каждой целевой платформе. Навигационные params описываются в выбранном роутере, а внешняя deep link проходит отдельную проверку.

Общий код не предполагает наличие window/document/localStorage. Обработчик Pressable не хранит секрет, а текст расположен в Text. Типы проверяются отдельным инструментом профиля, кроме преобразования Metro/Babel; реальный release build проверяет зависимости и permissions. UI-тест в JS не подтверждает обе native-платформы.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Card получает title и onSelect на iOS/Android | Отображается Text, нажатие вызывает callback один раз | Component/device checks |
| Неверный prop или неподдерживаемый DOM API | Ошибка найдена типовой проверкой/сборкой | Typecheck и bundle |
| Разные .ios/.android реализации | Обе выбраны корректно и имеют один контракт | Сборка/тест двух платформ |
| Новый native-модуль или permission | Изменен и проверен native build, не только JS bundle | Release build и device smoke |

Baseline проекта включает выбранные версии; этот документ не обещает совместимость произвольного SDK с последним React Native.

## Человек

Выбирает поддерживаемые платформы, навигацию и Expo/native workflow.

## Агент

Проверяет props и обе реализации, отделяет typecheck от транспиляции и native build.

## Источники

- [React Native: TypeScript](https://reactnative.dev/docs/typescript)
- [React Native: platform-specific code](https://reactnative.dev/docs/platform-specific-code)
- [React Native: core components](https://reactnative.dev/docs/intro-react-native-components)
