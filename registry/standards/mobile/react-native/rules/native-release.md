---
id: "mobile.native-release"
title: "Мобильный релиз"
section: "mobile"
level: "recommended"
tags: ["native-release", "React Native"]
technologies: ["React Native"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 95
related: ["api.compatibility", "operations.rollback"]
sources: ["https://docs.expo.dev/eas-update/runtime-versions/", "https://docs.expo.dev/eas-update/rollbacks/", "https://docs.expo.dev/eas-update/error-recovery/"]
schema_version: 1
---

# Мобильный релиз

## Коротко

JS/asset update публикуйте только для совместимого native runtime. Изменение нативной зависимости требует новой сборки и обновления выбранного признака совместимости; перед rollout проверьте откат состояния.

## Плохо

```text
В JS добавлен вызов нового native camera-модуля.
Bundle отправлен всем старым установкам с прежним runtimeVersion.
После роста crash rate откатили JS, считая локальные миграции тоже отмененными.
```

## Хорошо

```json
{
  "expo": {
    "runtimeVersion": {
      "policy": "fingerprint"
    }
  }
}
```

## Почему

Native-код зафиксирован в установленном бинарном приложении. Одинаковый runtimeVersion служит селектором совместимости, но ошибочно оставленное одинаковое значение не добавляет отсутствующий модуль. Откат bundle не отменяет изменения локальной БД или server API.

## Когда применять

React Native; JSON-пример — политика Expo EAS Update, не требование для всех OTA-систем. Для иного механизма опишите эквивалентную матрицу platform/build/native modules/update. Зафиксируйте версии Expo SDK, expo-updates и способ вычисления runtimeVersion.

`fingerprint` уменьшает вероятность забыть изменение runtime, но не заменяет пробу на нужных build. Допустимы другие документированные политики, если процесс гарантирует новый runtime при несовместимой native-правке. Добавление permissions, config plugin или обновление native-библиотеки проверяется как изменение сборки.

Протестируйте обновление на preview build с тем же runtime; channel определяет доставку, а не совместимость. Для rollout назначьте ответственному наблюдение за crash-free sessions, запуском и входом, с критериями остановки и периодом наблюдения по данным проекта. Универсального процента раскатки или порога ошибок здесь нет.

Откат проверяйте с уже измененными локальными данными и текущим API. Миграции должны сохранять возможность запуска предыдущего разрешенного bundle либо требовать осознанного forward fix. Устройство без сети может продолжать старый/кешированный update; одновременный перевод всех установок не гарантирован. Соблюдение правил магазинов проверяется отдельно для характера обновления.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| JS-правка без изменения native runtime | Работает на preview build целевого runtime обеих платформ | Матрица build/update и device-результаты |
| Добавлена native-библиотека | Создан новый совместимый build; старый runtime не получает несовместимый bundle | Значения runtime и проверка доставки |
| Рост ошибок на ограниченной группе | Rollout остановлен по заданному критерию, выбран rollback/forward fix | Метрики, решение и журнал выпуска |
| После update изменена локальная БД; выполнен rollback | Предыдущий bundle читает состояние либо откат явно запрещен | Проверка миграции и API |
| Устройство офлайн и возвращается позже | Работает допустимая версия; восстановление не требует мгновенной общей раскатки | Device-тест без сети |

Проверка JSON-конфигурации не подтверждает native-совместимость или успешный rollout.

## Человек

Утверждает матрицу поддерживаемых сборок, критерии остановки и допустимость отката данных.

## Агент

Сверяет fingerprint/ручную политику с native diff и проверяет существующие установки. Не считает channel заменой runtimeVersion.

## Источники

- [Expo: runtime versions and updates](https://docs.expo.dev/eas-update/runtime-versions/)
- [Expo: rollbacks](https://docs.expo.dev/eas-update/rollbacks/)
- [Expo: error recovery](https://docs.expo.dev/eas-update/error-recovery/)
