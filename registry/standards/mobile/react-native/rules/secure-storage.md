---
id: "mobile.secure-storage"
title: "Keychain и Keystore"
section: "mobile"
level: "required"
tags: ["secure-storage", "React Native"]
technologies: ["React Native"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 92
related: ["mobile.deep-links", "mobile.offline"]
sources: ["https://reactnative.dev/docs/security", "https://developer.android.com/privacy-and-security/keystore", "https://docs.expo.dev/versions/latest/sdk/securestore/"]
schema_version: 1
---

# Keychain и Keystore

## Коротко

Храните долговременные учетные секреты через проверенную платформенную защиту, обрабатывайте ее недоступность и удаляйте локальную сессию при выходе. Не используйте AsyncStorage или лог как резервное хранилище токена.

## Плохо

```typescript
await AsyncStorage.setItem('refreshToken', token);
console.log('Stored token:', token);
// При ошибке Keychain сохраняем token в обычный файл.
```

## Хорошо

```typescript
import * as SecureStore from 'expo-secure-store';

const key = 'session.refreshToken';
const options = {
  keychainAccessible: SecureStore.WHEN_UNLOCKED_THIS_DEVICE_ONLY,
};

// Вызывающий код считает отказ записи ошибкой создания локальной сессии.
export async function storeRefreshToken(token: string): Promise<void> {
  await SecureStore.setItemAsync(key, token, options);
}
export async function clearRefreshToken(): Promise<void> {
  await SecureStore.deleteItemAsync(key, options);
}
```

## Почему

iOS Keychain хранит защищенные значения; Android Keystore управляет ключами, которыми библиотека шифрует значение. Такая защита уменьшает риск извлечения данных, но не отменяет срок действия, серверный отзыв и риск скомпрометированного устройства.

## Когда применять

React Native на iOS/Android; пример использует expo-secure-store с версией, совместимой с Expo SDK приложения. Это выбор библиотеки для иллюстрации, не требование перейти на Expo. iOS accessibility ограничена разблокированным устройством и текущим устройством; background-сценарий может требовать другой осознанный выбор.

Задайте правила backup/restore и переустановки для каждой платформы. Для SecureStore Android резервное копирование зашифрованных значений исключается, поскольку ключ после удаления приложения не восстанавливается. При собственной backup-конфигурации проверьте это отдельно. На iOS данные могут пережить переустановку с тем же bundle ID; не считайте ни сохранение, ни удаление гарантией бизнес-сессии.

Если включено requireAuthentication, изменение биометрии может сделать секрет недоступным. Блокировка устройства, отказ пользователя и потеря ключа обрабатываются как отдельные результаты; ни один не разрешает fallback в открытый текст. Биометрия разблокирует локальный доступ, а право на API подтверждает сервер.

При logout сразу остановите запросы и синхронизацию старой сессии, очистите память, локальный секрет и приватный кеш; подтвердите ошибки удаления. Серверный отзыв выполняйте, пока доступна необходимая для него учетная информация, с ограниченным ожиданием. При отсутствии сети локальный выход завершается, но серверный отзыв не объявляется успешным: применяются заранее выбранные TTL/повторный отзыв или иной протокол. Не сохраняйте удаленный токен в обычной очереди ради отзыва.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Запись, завершение процесса и повторный запуск | Секрет читается только при разрешенных условиях | Device-тест обеих платформ |
| Хранилище/ключ недоступен, биометрия изменена | Ошибка/повторный вход; открытого fallback нет | Управляемый отказ и осмотр данных |
| Backup/restore или переустановка | Нет ложного предположения о восстановленной сессии; Android backup не содержит бессмысленный ciphertext | Backup-правила и device-сценарий |
| Logout online/offline во время фонового запроса | Старый аккаунт больше не используется локально; статус серверного отзыва правдив | Состояние клиента и серверная сессия |
| Диагностика ошибки и crash report | Токен отсутствует в AsyncStorage, логах, отчетах и bundle | Поиск секретного тестового маркера |

JS mock SecureStore не подтверждает Keychain/Keystore, accessibility или поведение переустановки.

## Человек

Выбирает срок сессии, доступность на заблокированном устройстве и офлайн-политику выхода.

## Агент

Проверяет нативные параметры библиотеки, backup и ошибочные пути. Отдельно фиксирует неподтвержденный серверный отзыв.

## Источники

- [React Native: security](https://reactnative.dev/docs/security)
- [Android: Keystore](https://developer.android.com/privacy-and-security/keystore)
- [Expo SecureStore](https://docs.expo.dev/versions/latest/sdk/securestore/)
