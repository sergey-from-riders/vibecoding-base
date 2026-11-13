# vibecoding-base

An open collection of engineering requirements for AI-assisted development. The collection helps people choose relevant rules, clarify a task, verify its outcome, and record the reasons behind engineering decisions.

**142 individual rules, 16 navigation sections, and 20 modules.** Russian is the canonical language of the rules. Read the [main README](README.md), the [complete catalog](docs/catalog.md), or the published handbook at [eval.su/standards](https://eval.su/standards/).

## Use the documentation

1. Select rules for your project, technologies, data, and failure consequences.
2. Start with the [Go + Next.js + PostgreSQL profile](registry/stacks/go-next-postgres.md) or the [Python/FastAPI + React + PostgreSQL profile](registry/stacks/python-react-postgres.md) when relevant.
3. Read the scope, examples, and verification method of each selected rule. A required rule applies within its stated scope.
4. Record the exact source commit, selected rule IDs, acceptance evidence, and justified exceptions in your own project documentation.
5. Give your coding agent the relevant subset and verify the resulting work. Reading a rule does not prove compliance.

## Documentation model

The November 13, 2026 structural revision preserves all 142 rules, 16 section descriptions, six WebP illustrations, IDs, paths, dates, and schema version 1 byte-for-byte against accepted commit `809078d13b3c5c67d75cc51cf82c6ba1ea5b4e8f`. This includes the previously reviewed HTTP and MCP corrections. Module `standard.md` files provide links instead of duplicated text, and stack profiles are Markdown documents. Executable tooling, application templates, generated projects, package manifests, and YAML manifests are removed.

The rule texts have not all been substantively rewritten in this revision. The [audit](docs/audit-2026-11-13.md), [per-rule review](docs/audit-2026-11-13/index.md), [improvement backlog](docs/standards-backlog.md), [refinement prompt](prompts/refine-standard.md) describe the next editorial work.

## Structure

| Path | Purpose |
| --- | --- |
| `registry/standards/*/*/rules/*.md` | Canonical rule text and metadata |
| `registry/standards/*/*/standard.md` | Module scope, dependencies, and links |
| `registry/standards/*/*/CHANGELOG.md` | Module history |
| `registry/handbook/*.md` | Section descriptions and order |
| `registry/stacks/*.md` | Human-readable selection profiles |
| `docs/` | Publishing contract, maintenance, audits, and migration |

## Publishing and compatibility

Import, validation, rendering, search, and export code belongs in eval.su or a separate tooling repository. This repository defines the [content contract](docs/content-contract.md).

The eval.su importer reads only rule files, section files, and referenced illustrations from one Git commit. It does not use the removed generators or manifests. Integration results are recorded separately in the [migration validation](docs/validation-documentation-only-2026-11-13.md); see the [migration guide](docs/migration-to-docs-only.md) for consumer compatibility and rollback.

See [contributing](CONTRIBUTING.md), [versioning](docs/standards-versioning.md), [security](SECURITY.md), and the [MIT license](LICENSE).
