# vibecoding-base

A documentation repository of engineering requirements for AI-assisted development: scope, normative statements, examples, primary sources, and acceptance criteria. Russian is the canonical language.

**212 rules, 19 navigation sections, and 26 modules.** Read the [main README](README.md), [catalog](docs/catalog.md), [language baselines](docs/language-baselines.md), and [revision report](docs/revision-2026-11-13.md).

## November 13, 2026 revision

The remaining **139 audited rules have been substantively revised**. The three previously accepted HTTP/MCP corrections are preserved from upstream commit `012f33f02faeb12fcae92634bd15bc2cc2d23854`. Another **70 rules** cover language conventions, framework baselines, security, navigation and search, SEO, and Russian personal data processing requirements.

The repository contains Markdown documentation, six original WebP illustrations, the license, and Git ignore configuration. It has no executable toolchain, package dependencies, application scaffolds, or JS/TS files. Code fences are examples. Application checks belong to the consuming project.

## Apply the requirements

1. Select relevant rule IDs and record an exact source commit.
2. Start from the [Go/Next/PostgreSQL](registry/stacks/go-next-postgres.md), [Python/React/PostgreSQL](registry/stacks/python-react-postgres.md), [Russian public website](registry/stacks/public-site-ru.md), or [Bitrix website](registry/stacks/bitrix-site-ru.md) profile.
3. Read each rule's scope, exceptions, examples, and expected evidence. A required rule applies within its stated scope.
4. Record justified exceptions and run the actual project acceptance scenarios.

The [site acceptance matrix](templates/site-acceptance.md) and [personal data processing matrix](templates/ru-data-processing-matrix.md) provide editable documentation templates.

## Sources, validation, and publication

The [source mapping](docs/revision-2026-11-13/source-mapping.md) covers Agent OS, agents-md, AGENTS.md, Spec Kit, OpenSpec, BMad, ASVS 5.0.0, SSDF 1.1, and OSPS v2026.08.28. Selected provisions do not establish full compliance.

The [integration review](docs/integration-review-2026-11-13.md) separates documentary review, syntax checks, isolated runtime checks, and unexecuted application scenarios. The [archive preparation record](docs/validation-standards-revision-2026-11-13.md) is retained as historical evidence. Existing rule identity and first-publication dates are retained; the 70 new rules were first published on November 13, 2026.

[eval.su/standards](https://eval.su/standards/) publishes the accepted 212-rule edition. GitHub merge, synchronization, public pages and Markdown downloads have been verified. See the exact [publication status](docs/publication-status.md).

Import, rendering, search, and export code belongs to the consumer. This repository defines the [content contract](docs/content-contract.md). The earlier [documentation migration validation](docs/validation-documentation-only-2026-11-13.md) remains a historical record and does not certify the new candidate.

See [contributing](CONTRIBUTING.md), [versioning](docs/standards-versioning.md), [security](SECURITY.md), and the [MIT license](LICENSE).
