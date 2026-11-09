## 2.1.1 — 2026-11-09

Повторная проверка всех правил и первоисточников: уточнены ссылки, область требований и примеры. Подробности по каждому ID — [журнал проверки](../../../../docs/review-2026-11-09-references.md).

# 2.0.0 — 2026-11-09

## 2.1.0 — 2026-11-09

Технические заголовки, обязанности человека и агента. денежные типы выделены в отдельное правило; добавлены платформы и Redis.

- Русские атомарные правила с примерами, датой проверки, источниками и условиями применения.
- Источник перенесён в rules/*.md; standard.md теперь генерируется.
- Обязательность пересмотрена: соглашения проекта отделены от требований протоколов.
- Полный построчный журнал решений: docs/audit-2026-11-09.md.
- Несовместимое изменение источника и языка: обновите профили до ^2.0.0 и пересоберите примеры.

# Changelog

## 1.1.0

- Added May 2026 registry-first lifecycle expectations, readiness matrix discipline and public release gate.
- Added a registry change checklist for standard, stack, lockfile and generated-example updates.

## 1.0.1

- Clarified lifecycle language for registry-generated projects.
- Removed previous lifecycle naming that belonged to the pre-registry structure.
- Added explicit rule that `standards/active/*` is generated output, not the source of truth.

## 1.0.0

- Initial stable standard extracted from the previous lifecycle documentation.
