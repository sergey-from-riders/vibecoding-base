# 26. Security Incident Runbook (Auth/Session)

Этот runbook описывает действия при security-инцидентах в домене Auth/Session.

## 1) Incident classes

1. `SEV-1`: массовая компрометация токенов/секретов, высокий риск takeover
2. `SEV-2`: компрометация отдельных аккаунтов/сессий
3. `SEV-3`: подозрительная активность без подтвержденной компрометации

## 2) First 15 minutes (mandatory)

1. Назначить incident commander.
2. Зафиксировать `incident_id` и временную шкалу.
3. Заморозить risky deploys до стабилизации.
4. Включить усиленное логирование security событий.
5. Определить blast radius:
- какие пользователи;
- какие секреты;
- какие endpoint-ы.

## 3) Scenario A: token leak (single or multiple users)

## 3.1 Containment

1. Немедленно отозвать сессии затронутых пользователей.
2. Для массового случая выполнить global revoke.
3. Принудить повторную авторизацию.

## 3.2 SQL emergency actions (PostgreSQL)

Точечный revoke по `user_id`:

```sql
UPDATE sessions
SET revoked_at = NOW()
WHERE user_id = '<user_uuid>'::uuid
  AND revoked_at IS NULL;
```

Массовый revoke всех активных сессий:

```sql
UPDATE sessions
SET revoked_at = NOW()
WHERE revoked_at IS NULL;
```

Проверка остатка активных:

```sql
SELECT count(*) AS active_sessions
FROM sessions
WHERE revoked_at IS NULL
  AND expires_at > NOW();
```

## 4) Scenario B: secret leak (bot token / env secret)

1. Ротация секрета в source provider.
2. Обновление значения в server secrets/env.
3. Перезапуск сервисов (`api`, при необходимости `web`).
4. Проверка новых подписей/валидаций.
5. Обязательный post-rotation smoke.

## 5) Mandatory communication

1. Внутренний update каждые `30` минут для `SEV-1`.
2. Техническое summary:
- что скомпрометировано;
- что отозвано;
- что уже восстановлено.
3. При user-facing impact — готовится customer notice.

## 6) Recovery checklist

1. Подтвердить revoke/rotation фактом из логов и БД.
2. Проверить auth/session endpoint-ы smoke-набором.
3. Проверить отсутствие новых аномалий `>= 60` минут.
4. Разморозить deploy только после explicit go/no-go.

## 7) Post-incident actions (mandatory)

1. Postmortem в течение `48` часов.
2. Root-cause + corrective actions.
3. Добавить regression tests/security checks.
4. Обновить документацию и playbook при необходимости.

## 8) Evidence to collect

1. `request_id` и `trace_id` затронутых запросов
2. временной интервал компрометации
3. список revoke/rotation действий
4. проверка, что новые сессии создаются штатно

## 9) Companion docs

1. `docs/05-AUTH-COMPANY-SWITCH.md`
2. `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`
3. `docs/22-OBSERVABILITY-STANDARD.md`
4. `docs/12-ENV-REPO-DEPLOY.md`
