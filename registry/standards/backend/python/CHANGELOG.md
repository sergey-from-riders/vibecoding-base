# 2.0.0 — 2026-11-09

- Русские атомарные правила с примерами, датой проверки, источниками и условиями применения.
- Источник перенесён в rules/*.md; standard.md теперь генерируется.
- Обязательность пересмотрена: соглашения проекта отделены от требований протоколов.
- Полный построчный журнал решений: docs/audit-2026-11-09.md.
- Несовместимое изменение источника и языка: обновите профили до ^2.0.0 и пересоберите примеры.

# Changelog

## 1.1.0

- Updated the backend baseline to Python 3.14 with FastAPI/Pydantic v2, reproducible installs, typing and async-runtime guidance.
- Removed claims that absent Python limit scripts are already enforced by the starter.

## 1.0.1

- Replaced legacy `docs/*` references with generated `standards/active/*` references.

## 1.0.0

- Initial stable standard extracted from the old Python framework docs.
