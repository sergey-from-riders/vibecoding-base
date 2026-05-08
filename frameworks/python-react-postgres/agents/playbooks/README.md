# agents/playbooks

Пошаговые playbook'и для типовых задач.

## Available playbooks

1. `auth-feature-playbook.md`
- feature в домене Auth/Switch Company

2. `openapi-feature-sync-playbook.md`
- команда "актуализируй фичу" и синхронизация endpoint контрактов

3. `security-incident-token-leak-playbook.md`
- incident response при компрометации токенов/сессий

## Usage rule

Перед крупной задачей агент обязан выбрать playbook и следовать ему.
Если playbook не подходит, агент фиксирует custom-plan в `agents/tasks/<task-id>.md`.
