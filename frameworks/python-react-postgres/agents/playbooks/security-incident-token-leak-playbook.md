# Playbook: Security Incident (Token Leak)

Use when there is suspected/confirmed session token compromise.

## 1) Immediate actions

1. Создать incident note: `agents/tasks/<date>-security-incident-<id>.md`
2. Остановить risky deploys
3. Назначить incident commander

## 2) Containment

1. Определить blast radius (users/sessions/time window)
2. Выполнить targeted revoke или mass revoke
3. Подтвердить revoke SQL-проверкой

## 3) Secret rotation (if needed)

1. Ротировать скомпрометированный secret
2. Обновить server env/secrets
3. Перезапустить runtime

## 4) Verification

1. Проверить auth/session smoke flow
2. Проверить отсутствие активных скомпрометированных сессий
3. Проверить лог/trace аномалии

## 5) Communication and closure

1. Выпускать регулярные updates до стабилизации
2. Подготовить postmortem и corrective actions
3. Обновить runbook/docs/tests

## Companion doc

- `docs/26-SECURITY-INCIDENT-RUNBOOK.md`
