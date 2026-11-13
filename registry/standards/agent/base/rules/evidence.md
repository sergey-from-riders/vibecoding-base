---
id: "ai-agents.evidence"
title: "Доказательства выполнения"
section: "ai-agents"
level: "required"
tags: ["evidence"]
technologies: []
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 11
related: ["ai-agents.context", "ai-agents.untrusted-input"]
sources: ["https://www.anthropic.com/research/demystifying-evals-for-ai-agents", "https://sre.google/workbook/canarying-releases/"]
schema_version: 1
---

# Доказательства выполнения

## Коротко

Заявление о выполнении должно указывать проверяемый результат, версию/объект, среду, операцию или команду и наблюдаемое свидетельство.

## Плохо

```text
Ответ API: 202 Accepted.
Отчет: «Выпуск завершен, пользователи уже видят новую версию».
```

## Хорошо

```text
Объект: staging, artifact D, operation 42.
Наблюдение: API принял задачу, status=queued.
После завершения: operation 42 succeeded; readiness и smoke test passed.
Вывод: развертывание в staging подтверждено; production не проверялся.
```

## Почему

Принятие задания, завершение процесса и соответствие пользовательскому сценарию — разные наблюдения. Их смешение делает отчет непроверяемым.

## Когда применять

Для файловых изменений, проверок, публикаций и внешних операций. Храни безопасную ссылку или краткий вывод, достаточный для проверки; не копируй секреты и весь журнал без необходимости.

### Подробные условия

Различай planned, queued, running, succeeded, failed, partially-succeeded, unknown и not-run; используй только состояния, нужные задаче.

Код возврата и вывод команды подтверждают именно ее область. Успешный ответ синхронного API с документированным конечным результатом обычно достаточен. Для асинхронного принятия, тайм-аута, частичной записи или возможного внешнего изменения нужна дополнительная проверка конечного состояния. Отсутствие доступа к ней обозначается как unknown/blocked, а не как успех.

## Как проверить

- Синхронный API подтвердил конечную запись → сопоставить ID и параметры → succeeded без бессмысленного дублирующего чтения.
- Команда только поставила задачу в очередь → сформировать отчет → queued; заявления о конечном эффекте нет.
- Из трех объектов изменены два → перечислить исходы → partially-succeeded с ID, ошибкой и следующим безопасным действием.

## Человек

Оценивает, достаточно ли свидетельства для заявленного результата и среды.

## Агент

Сохраняет проверяемую ссылку/вывод и границы проверки; новый diff или новый артефакт не покрывает старым успешным прогоном.

## Источники

- [Anthropic: Demystifying evals for AI agents](https://www.anthropic.com/research/demystifying-evals-for-ai-agents) — Tasks, trials, graders, outcomes and evaluation harness.
- [Google SRE Workbook: Canarying Releases](https://sre.google/workbook/canarying-releases/) — Release process, evaluation, rollback and reproducibility.
