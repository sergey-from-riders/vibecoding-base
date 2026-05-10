# vibecoding-base 🧱✨

Composable stack profiles and a versioned standards registry for AI-native development.

Short version: this repo is no longer a pile of copyable stack folders. The registry is the source of truth. A generated project contains only the active stack you chose, plus the exact standards and checks that apply to that stack.

## Languages

- 🇬🇧 [English documentation](README.en.md)
- 🇷🇺 [Русская документация](README.ru.md)

## The Model

```text
registry
  -> stack profile
  -> selected templates
  -> active standards
  -> generated clean project
```

Generated projects should stay small:

```text
apps/api
apps/web
contracts/openapi
standards/active
scripts/check.sh
README.md
AGENTS.md
.vibe/profile.yaml
.vibe/enabled.yaml
.vibe/registry.lock
```

Disabled features stay in `registry`, not in the generated project.

## Duplication Policy

There is one source of truth for standards: `registry/standards`.

`examples/*/standards/active` contains generated copies so users can inspect a real project shape. Do not edit those files by hand. Update the registry standard and regenerate examples instead.

`node tools/vibe.mjs verify` checks that generated active standards have not drifted from the registry.

## Quick Start

Generate a project:

```bash
node tools/vibe.mjs use go-next-postgres --project ../my-app
```

Or try the examples already generated in this repo:

```bash
node tools/vibe.mjs verify
examples/generated-go-next-postgres/scripts/check.sh
examples/generated-python-react-postgres/scripts/check.sh
```

Enable optional parts later:

```bash
node tools/vibe.mjs enable worker --project ../my-app
node tools/vibe.mjs enable mobile react-native --project ../my-app
node tools/vibe.mjs enable payments stripe --project ../my-app
```

Disable them again:

```bash
node tools/vibe.mjs disable mobile --project ../my-app
```

## Available Stack Profiles

| Stack | Backend | Frontend | Database | Status |
| --- | --- | --- | --- | --- |
| `go-next-postgres` | Go | Next.js | PostgreSQL | stable profile, partial runtime |
| `python-react-postgres` | Python/FastAPI | React | PostgreSQL | stable profile, partial runtime |

See [`registry/stacks`](registry/stacks).

## Standards Registry

Each standard is its own versioned unit:

```text
registry/standards/backend/go/
  standard.yaml
  standard.md
  checks.yaml
  CHANGELOG.md
  README.md
```

See [`docs/contributing-standards.md`](docs/contributing-standards.md) before changing standards.

## Commands

```bash
node tools/vibe.mjs standards list
node tools/vibe.mjs standards explain backend/go
node tools/vibe.mjs verify
node tools/vibe.mjs doctor
```

## More Docs

- [`docs/architecture.md`](docs/architecture.md)
- [`docs/stack-profiles.md`](docs/stack-profiles.md)
- [`docs/standards-versioning.md`](docs/standards-versioning.md)
- [`docs/contributing-standards.md`](docs/contributing-standards.md)
