# vibecoding-base 🧱✨

`vibecoding-base` is a composable registry for AI-native project foundations.

It helps you generate a clean project for one active stack, instead of copying a huge folder that already contains every possible future technology. The registry keeps standards, stack profiles, templates and checks in one place. Your project gets only what it actually uses.

## Why This Exists

Coding agents are fast. Without repo rules, they also improvise fast:

- random folders;
- duplicated architecture docs;
- different rules for nearly identical stacks;
- hidden framework drift;
- stale standards nobody wants to update;
- "ready" claims that only mean "docs exist".

This repo fixes that with one simple idea:

> Registry contains everything. A generated project contains only active context.

## What You Generate

When you run:

```bash
node tools/vibe.mjs use go-next-postgres --project ../my-app
```

the target project gets:

```text
apps/api
apps/web
contracts/openapi
db/migrations
standards/active
scripts/check.sh
README.md
AGENTS.md
.vibe/profile.yaml
.vibe/enabled.yaml
.vibe/registry.lock
```

It does not get inactive folders such as:

```text
mobile
desktop
worker
admin
payments
queue
ai
```

Those parts stay in the registry until you explicitly enable them.

## Daily Commands

```bash
# Generate a stack
node tools/vibe.mjs use go-next-postgres --project ../my-app

# Verify registry and examples
node tools/vibe.mjs verify

# List standards
node tools/vibe.mjs standards list

# Explain one standard
node tools/vibe.mjs standards explain backend/go

# Enable optional parts
node tools/vibe.mjs enable worker --project ../my-app
node tools/vibe.mjs enable mobile react-native --project ../my-app
node tools/vibe.mjs enable payments stripe --project ../my-app

# Disable an optional part
node tools/vibe.mjs disable mobile --project ../my-app
```

## Repository Layout

```text
registry/
  standards/      versioned standards
  stacks/         YAML stack profiles
  templates/      composable generated project parts
  checks/         registry and generated-project checks
  schemas/        schemas for standards, stacks and profiles
tools/
  vibe.mjs        minimal CLI
examples/
  generated-go-next-postgres
  generated-python-react-postgres
docs/
  architecture.md
  contributing-standards.md
  stack-profiles.md
  standards-versioning.md
```

## Stack Profiles

Current stacks:

- `go-next-postgres`: Go API, Next.js web, PostgreSQL, OpenAPI.
- `python-react-postgres`: Python/FastAPI API, React web, PostgreSQL, OpenAPI.

Each stack profile is YAML composition:

```yaml
components:
  backend: go
  frontend: next
  database: postgres
  contracts: openapi
standards:
  - backend/go@^1.0.0
templates:
  - backend/go
checks:
  - check_structure
```

## Standards

Each standard is independently versioned:

```text
registry/standards/backend/go/
  standard.yaml
  standard.md
  checks.yaml
  CHANGELOG.md
  README.md
```

`standard.yaml` declares owners, SemVer version, dependencies, enforcement reality and compatible stacks.

Enforcement is explicit:

```yaml
enforcement:
  documented: true
  linted: false
  tested: false
  ci_blocking: false
```

If a rule is only written down, we say so. No fake "enforced" claims.

## Status Matrix

Stacks use separate readiness fields:

- `template`: files can be generated.
- `runtime`: runnable app/runtime completeness.
- `checks`: automated checks completeness.
- `docs`: documentation completeness.

This avoids calling a stack "ready" when only the docs are ready.

## Contributing

Read:

- [`docs/contributing-standards.md`](docs/contributing-standards.md)
- [`docs/standards-versioning.md`](docs/standards-versioning.md)
- [`docs/stack-profiles.md`](docs/stack-profiles.md)
