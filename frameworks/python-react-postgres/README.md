# Python React Postgres Framework

AI-native monorepo starter for teams that want to build with coding agents without starting from an empty folder.

This repository is a public blueprint, not a finished application. It gives you the boring but important foundation first: architecture decisions, agent rules, OpenAPI contracts, database migrations, environment/deploy rules, quality gates, security policy, and feature playbooks.

Use it as a "kalka": fork it, rename it, replace placeholders, and then build your product through small vertical slices.

## What This Is

This starter is a framework for agentic/vibe coding in 2026:

- agents get clear repository rules in `AGENTS.md`;
- humans get a repeatable delivery model in `FRAMEWORK.md`;
- API work starts from contracts in `packages/contracts`;
- database changes start from append-only migrations in `db/migrations`;
- feature work follows playbooks in `agents/playbooks`;
- quality gates live in `tools/scripts`;
- secrets are kept out of the repository by design.

The template baseline includes only foundation domains:

- Auth
- session lifecycle
- active company context
- API docs/testing endpoints

Everything product-specific should be added later as its own vertical slice.

## What This Is Not

This is not:

- a production-ready app;
- a generated SaaS boilerplate with complete UI;
- a framework package you install from npm;
- a replacement for review, tests, and security thinking.

The goal is to make AI-assisted work less chaotic by giving agents and humans the same map.

## Why This Exists

Vibe coding works best when the repository is already opinionated about boundaries. Without that, agents tend to create contract drift, duplicate logic, skip tests, leak env assumptions, and spread business rules across UI and backend code.

This starter fixes the order of work:

1. Decide the architecture.
2. Write the contract.
3. Add failing tests.
4. Implement the smallest vertical slice.
5. Prove it with checks.
6. Update docs and playbooks.

## Current 2026 Baseline

The template is aligned with the April-May 2026 ecosystem direction:

- Node.js `24` LTS in CI; engines allow Node `24` through `26`.
- pnpm `11`.
- React `16.2`.
- React `19.2`.
- TypeScript `6`.
- Python `3.14+`.
- PostgreSQL `18+`.
- OpenAPI `3.2.0`.
- MCP-first agent integration model.
- Contract-first API and generated SDK path.
- Human checkpoints for deploy, security, schema, and write-enabled MCP actions.

## Repository Map

```text
.
├─ AGENTS.md                         # rules for coding agents
├─ FRAMEWORK.md                      # human/agent delivery framework
├─ docs/                             # architecture, standards, ADRs, operations
├─ agents/
│  ├─ playbooks/                     # task playbooks
│  ├─ profiles/                      # agent profile notes
│  └─ tasks/                         # task logs for larger work
├─ apps/
│  ├─ api/                           # future Python backend
│  ├─ web/                           # future React app
│  ├─ mobile/android/                # future Android WebView shell
│  └─ desktop/qt/                    # future Qt desktop client
├─ packages/
│  ├─ contracts/                     # OpenAPI source of truth
│  ├─ tokens/                        # design tokens
│  ├─ sdk-py/                        # future generated/maintained SDK
│  └─ sdk-ts/                        # future generated/maintained SDK
├─ db/migrations/                    # append-only PostgreSQL schema
├─ infra/                            # docker, nginx, CI examples
├─ mcp/                              # MCP server integration notes/configs
└─ tools/scripts/                    # local quality gates
```

## Quick Start

Prerequisites:

- `git`
- `bash`
- Node.js `24+`
- pnpm `11+`
- `jq`
- `rg`
- Docker and PostgreSQL client if you want to apply migrations locally

Clone your copy:

```bash
git clone <your-repo-url> ai-app
cd ai-app
```

Install dependencies:

```bash
pnpm install
```

Run the template checks:

```bash
pnpm run verify:offline
pnpm run verify:contracts
pnpm run template:check
```

Expected result:

- starter integrity passes;
- DB contract check passes;
- Python/Web/C++ static limits pass;
- OpenAPI bundle and coverage checks pass;
- template clean check finds no old branding, private host paths, old env prefixes, or common secret shapes.

## Use As A Public Template

After creating a new repository from this starter:

1. Rename the repository and package metadata in `package.json`.
2. Replace `Python React Postgres Framework` with your product name where appropriate.
3. Keep `APP_*` and `NEXT_PUBLIC_APP_*` unless you have a strong reason to change the env convention.
4. Replace `example.test` URLs with your own examples or keep them as safe placeholders.
5. Keep `LICENSE`, `SECURITY.md`, and `CONTRIBUTING.md`.
6. Run:

```bash
pnpm run template:check
pnpm run verify:offline
pnpm run verify:contracts
```

Do not publish with real `.env` files. The `.gitignore` only allows `*.env.example`.

## The Framework

The delivery framework is documented in [FRAMEWORK.md](FRAMEWORK.md).

Short version:

1. **Context**: read `AGENTS.md`, relevant docs, and the feature playbook.
2. **Scope**: create or update an ADR for new domains or architectural changes.
3. **Contract**: update OpenAPI and DB migrations before implementation.
4. **Tests**: write failing tests or define the exact gate that will fail.
5. **Slice**: implement the smallest backend/frontend path that proves the behavior.
6. **Observe**: add request IDs, logs, traces, metrics, and redaction rules.
7. **Docs**: update README/docs/playbooks in the same change.
8. **Gate**: run checks locally and in CI.
9. **Review**: humans review security, schema, deploy, and external write access.

## How To Give Work To An Agent

Use small, scoped prompts. Example:

```text
Read AGENTS.md and FRAMEWORK.md first.
Task: implement the register/login/me backend vertical slice.
Scope: apps/api, packages/contracts, db/migrations, docs only.
Follow agents/playbooks/auth-feature-playbook.md.
Do not add unrelated product modules.
Before finishing, run verify:offline and verify:contracts.
Return changed files, validation output, and unresolved risks.
```

For frontend:

```text
Read docs/19-REACT-NODE-FRONTEND-STANDARD.md and docs/08-UI-CROSS-PLATFORM-RULES.md.
Task: add the auth login UI against the existing contract.
Use shared API client boundaries. Do not duplicate business validation.
Add tests and update docs in the same change.
```

For schema work:

```text
Read docs/07-DB-NAMING-CONVENTIONS.md and docs/15-DATA-VERSIONING-AND-DIFF.md.
Task: add a new business entity with versioning.
Use append-only up/down migrations.
Run tools/scripts/check_db_contract.sh and verify:offline.
```

## Adding A Feature

A new feature should land as a vertical slice, not as a pile of disconnected files.

Minimum flow:

1. Create a task log in `agents/tasks/<task-id>.md` for large work.
2. Pick a playbook from `agents/playbooks/`.
3. Update or create an ADR if the feature changes architecture or product scope.
4. Update OpenAPI in `packages/contracts/openapi`.
5. Update DB migrations if data changes.
6. Add tests or define the failing checks first.
7. Implement the smallest API path.
8. Add web UI only after the backend contract is stable.
9. Update SDK/docs/testing artifacts.
10. Run the gates.

Recommended order for the first real product implementation:

1. Bootstrap API runtime: Python package, router, request ID middleware, Problem payloads, docs endpoints.
2. Add DB runner and integration-test setup.
3. Implement auth: register, login, me, refresh, logout.
4. Implement session management: list, revoke one, revoke others.
5. Implement company context: list, create, switch active company.
6. Implement web auth UI.
7. Add Android and Qt shells only after web+api auth is stable.

## Commands

```bash
pnpm run verify:offline
```

Runs the offline starter gate:

- required file check;
- DB contract check;
- Python limits check;
- Web limits check;
- C++ limits check;
- template clean check.

```bash
pnpm run verify:contracts
```

Bundles and validates OpenAPI:

- Redocly lint;
- YAML/JSON bundle;
- endpoint catalog;
- Postman collection best effort;
- inventory/examples/header coverage.

```bash
pnpm run template:check
```

Blocks public-template mistakes:

- old project branding;
- old env prefixes;
- private host/path fragments;
- common key/token shapes;
- unsafe example leftovers.

```bash
pnpm run db:check
pnpm run limits:python
pnpm run limits:web
pnpm run limits:cpp
```

Run individual gates while working on one area.

## Contracts

OpenAPI source files live in:

```text
packages/contracts/openapi/
```

Important files:

- `openapi.root.yaml` is the root contract.
- `modules/*.yaml` contains endpoint modules.
- `components/schemas/*.yaml` contains shared schemas.
- `endpoints.inventory.tsv` is the endpoint inventory gate.
- `dist/` contains generated artifacts.

Every endpoint must have:

- OpenAPI operation;
- inventory row;
- examples for request/response bodies where applicable;
- `x-codeSamples`;
- mandatory response headers.

## Database

Migrations live in:

```text
db/migrations/
```

Rules:

- append-only migrations;
- paired up/down files;
- UUID domain identifiers;
- no generic `id` primary keys for domain entities;
- UTC timestamps;
- full snapshot versioning for business entities;
- auth/session tokens stored only as hashes.

Read before DB work:

- `docs/07-DB-NAMING-CONVENTIONS.md`
- `docs/15-DATA-VERSIONING-AND-DIFF.md`
- `docs/04-DATABASE-SCHEMA.md`

## Environment

Only example env files are committed:

```text
.env.example
apps/api/.env.example
apps/web/.env.example
apps/mobile/android/.env.example
apps/desktop/qt/.env.example
infra/docker/.env.example
env/examples/testing.env.example
```

Convention:

- server-side variables: `APP_*`;
- browser-exposed variables: `NEXT_PUBLIC_APP_*`;
- real values: local `.env`, CI secrets, or secrets manager;
- no real secrets in Git.

## CI

The active GitHub Actions workflow is:

```text
.github/workflows/verify.yml
```

It runs:

- `pnpm install --frozen-lockfile`;
- `pnpm run verify:offline`;
- `pnpm run verify:contracts`.

Deployment examples are intentionally separate in:

```text
infra/ci/github-actions.deploy.example.yml
```

Keep deploy workflows disabled until the runtime app and environment are real.

## Security Model

Security defaults:

- no real secrets;
- no committed `.env`;
- token/password examples are placeholders;
- sessions use hash-only token storage in schema/docs;
- MCP and agent write access require human checkpoints;
- template clean check runs as part of offline verification.

Read:

- `SECURITY.md`
- `docs/26-SECURITY-INCIDENT-RUNBOOK.md`
- `docs/25-MCP-AGENTS-OPERATIONS-STANDARD.md`

## Agent Rules

Before code changes, agents should read:

- `AGENTS.md`
- `FRAMEWORK.md`
- relevant `docs/*STANDARD.md`;
- relevant playbook in `agents/playbooks/`.

Agents should not:

- expand scope without ADR;
- bypass quality gates;
- commit secrets;
- rewrite migration history;
- duplicate business logic in UI/mobile/desktop;
- mark work complete without validation evidence.

## Public Release Checklist

Before publishing your fork:

```bash
pnpm install --frozen-lockfile
pnpm run verify:offline
pnpm run verify:contracts
pnpm run template:check
```

Then check:

- `LICENSE` is correct for your project.
- `SECURITY.md` has the right reporting path.
- `CONTRIBUTING.md` reflects your process.
- README product name and links are correct.
- `package.json` name is correct.
- OpenAPI title/license are correct.
- No `node_modules` directory is present.
- No real `.env` files are present.
- GitHub repository is marked as a template if you want others to clone it as a starter.

## FAQ

### Why is `package.json` private?

This repository is a template, not an npm package. `"private": true` prevents accidental publishing.

### Why keep generated OpenAPI artifacts?

They make the contract inspectable without running tooling and provide a stable baseline for SDK/docs consumers. Regenerate them after contract changes with `pnpm run verify:contracts`.

### Why use `example.test`?

It is a safe placeholder domain for documentation and examples. Replace it only with non-secret public examples or your real public domain when appropriate.

### Can I remove Qt or Android?

Yes. Remove the corresponding docs, app folders, scripts, and references together. Do not leave dead standards that agents will try to follow.

### Can I use another backend language?

Yes, but update the architecture docs, playbooks, CI, scripts, and standards in the same change. The framework matters more than Python specifically.

## License

MIT. See [LICENSE](LICENSE).
