# 25. MCP and Agent Operations Standard

Этот документ обязателен для всех задач, где агенты подключают MCP или вносят изменения в код.

## 1) Scope

1. `mcp/servers/*` конфигурации
2. agent workflows (планирование, изменение кода, коммиты)
3. ограничения безопасности для автоматизированных действий

## 2) MCP connection model

Базовый порядок:
1. Определить нужный MCP server для задачи.
2. Подключить server config в `mcp/servers/`.
3. Проверить доступы (read/write/network) до запуска задач.
4. Зафиксировать в task log, какой MCP был использован и зачем.

## 3) MCP configuration conventions

1. Один конфиг = один server integration.
2. Имя файла: `<domain>-<purpose>.md` или `<domain>-<purpose>.json`.
3. Для каждого server должны быть описаны:
- цель;
- разрешенные операции;
- запрещенные операции;
- источник секретов.

## 4) Agent safety guardrails

Агенту запрещено:
1. менять продуктовый scope без отдельного решения/ADR;
2. обходить обязательные тестовые гейты;
3. коммитить секреты/ключи/токены;
4. делать destructive git-команды без явного запроса;
5. менять migration history retroactively.

## 5) Agent code-change contract

Перед изменениями агент обязан:
1. прочитать `AGENTS.md`;
2. прочитать профильный `READ FIRST` стандарт;
3. открыть/создать task log в `agents/tasks/<task-id>.md` для крупной задачи;
4. выбрать playbook из `agents/playbooks/`.

После изменений агент обязан:
1. обновить docs/contracts/tests;
2. зафиксировать validation evidence;
3. сделать атомарные коммиты по `docs/14-COMMIT-STANDARDS-2026.md`.

## 6) MCP data handling policy

1. Любые секреты хранятся только в env/secrets manager.
2. MCP output не должен содержать plaintext credentials.
3. Логи агентов не должны включать токены/cookies/session secrets.
4. При обработке production-like данных применяем masking.

## 7) Human-in-the-loop checkpoints

Обязательная ручная проверка перед:
1. deploy actions;
2. security-sensitive changes (auth/session/secret rotation);
3. массовыми изменениями схемы/данных;
4. включением нового MCP с write-доступом.

## 8) Observability for agent runs

Каждый крупный запуск агента должен оставлять:
1. task log с шагами и результатом;
2. список измененных файлов;
3. список пройденных проверок;
4. список unresolved risks (если есть).

## 9) Non-compliance outcomes

Если нарушен любой пункт стандарта:
1. задача возвращается в `incomplete`;
2. merge блокируется;
3. выполняется corrective task с root-cause note.

## 10) Required companion docs

1. `AGENTS.md`
2. `docs/06-VIBECODING-WORKFLOW.md`
3. `docs/14-COMMIT-STANDARDS-2026.md`
4. `docs/17-TESTING-TDD-QUALITY-GATES.md`
5. `agents/playbooks/README.md`
