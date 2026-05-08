# vibecoding-base 🧱✨

Copyable AI-native repository frameworks for people building software with coding agents.

In plain English: `vibecoding-base` is a library of ready-to-copy project foundations. You pick a stack, copy the folder, rename it, and start building your product with an AI agent that already has rules, contracts, checks, and guardrails.

It is not magic. It is not a full app. It is the base layer that stops your agent from turning a fresh repo into a messy pile of random files.

## The Big Idea 🧠

Coding agents are fast. Very fast. But if the repository has no structure, the agent has to guess:

- where backend code should go;
- how API contracts are written;
- how database changes happen;
- what tests are required;
- what secrets must never be committed;
- what "done" means;
- when a human must review something.

Guessing is where chaos starts.

`vibecoding-base` gives the agent a map before it writes code.

The map looks like this:

```text
rules -> contracts -> tests -> implementation -> docs -> checks -> review
```

That is the whole vibe.

## What Is Inside? 📦

This repo is a catalog. Each item in the catalog is a full repository framework.

Every framework tries to include:

- `AGENTS.md` — rules for AI coding agents;
- `FRAMEWORK.md` — how humans and agents should work in this repo;
- `README.md` — framework-specific instructions;
- OpenAPI contracts;
- endpoint inventory;
- database migrations;
- env examples;
- security policy;
- contribution policy;
- CI workflow;
- local quality gates;
- template-clean checks;
- agent playbooks;
- docs and ADRs.

So instead of giving an agent an empty folder and saying "make an app", you give it a repo that already says:

> "Here is how this project works. Follow the rules."

## Available Frameworks 🚀

| Framework | Stack | Best For |
| --- | --- | --- |
| [`go-next-postgres`](frameworks/go-next-postgres) | Go + Next.js + PostgreSQL | Strict backend service layer, contract-first full-stack apps, teams that like Go runtime discipline. |
| [`python-react-postgres`](frameworks/python-react-postgres) | Python/FastAPI + React + PostgreSQL | Python backend teams, React-first apps, FastAPI contract-driven delivery. |

More frameworks can be added later:

```text
node-react-postgres
rust-react-postgres
php-laravel-inertia
python-next-postgres
go-react-postgres
```

## What This Is Not 🚫

This is not a finished product.

It does not give you:

- a complete SaaS app;
- a full auth UI;
- production-ready runtime code;
- real deployment credentials;
- real environment values;
- a database already running in the cloud.

It gives you the project foundation. You still build the product.

The difference is that you build it on rails instead of improvising everything.

## Who Is This For? 👥

Use `vibecoding-base` if:

- you build with ChatGPT, Codex, Claude Code, Copilot, Cursor, or other coding agents;
- you want agents to follow repo rules instead of inventing architecture;
- you want contract-first API work;
- you want database migrations from day one;
- you care about secrets hygiene;
- you want repeatable checks;
- you want a starter that is more serious than "hello world";
- you want to create multiple projects with the same delivery model.

Do not use it if:

- you want a visual app immediately after clone;
- you do not want docs or process;
- you prefer quick prototypes with no contracts;
- you want the AI to make all architecture decisions on the fly.

## Quick Start 🏁

Clone the catalog:

```bash
git clone <repo-url> vibecoding-base
cd vibecoding-base
```

Check the whole catalog:

```bash
tools/scripts/check_frameworks.sh
```

Pick a framework:

```bash
cp -a frameworks/go-next-postgres ../my-product
cd ../my-product
```

Or pick the Python/React one:

```bash
cp -a frameworks/python-react-postgres ../my-product
cd ../my-product
```

Install dependencies:

```bash
pnpm install
```

Run checks:

```bash
pnpm run verify:offline
pnpm run verify:contracts
pnpm run template:check
```

If all of that passes, the copied framework is clean and ready to become your product repo.

## What To Rename After Copying ✍️

After copying a framework into your own repo, rename the obvious things:

1. `package.json`
   - change `name`;
   - change `description`;
   - keep `"private": true` unless you really publish a package.

2. `README.md`
   - replace framework name with your product name;
   - keep the command sections;
   - keep the safety notes.

3. `packages/contracts/openapi/openapi.root.yaml`
   - change API title;
   - change summary;
   - keep `example.test` until you have real public docs.

4. Env examples
   - keep `APP_*`;
   - keep `NEXT_PUBLIC_APP_*`;
   - do not commit real `.env` files.

5. GitHub repository settings
   - mark it as a template if you want others to copy it;
   - enable security advisories if the host supports them;
   - keep CI enabled.

## How The Agent Should Work 🤖

The agent should not just jump into files.

For serious tasks, tell it to read:

- `AGENTS.md`;
- `FRAMEWORK.md`;
- relevant docs in `docs/`;
- relevant playbook in `agents/playbooks/`.

Good prompt:

```text
Read AGENTS.md and FRAMEWORK.md first.

Task:
Implement the login backend vertical slice.

Scope:
apps/api, packages/contracts, db/migrations, docs.

Non-goals:
No UI, no OAuth providers, no Android/Qt changes.

Required docs:
docs/17-TESTING-TDD-QUALITY-GATES.md
docs/21-OPENAPI-MODULAR-CONTRACT-STANDARD.md
docs/22-OBSERVABILITY-STANDARD.md

Validation:
pnpm run verify:offline
pnpm run verify:contracts

Output:
- changed files
- validation results
- unresolved risks
```

Bad prompt:

```text
build the whole app
```

That prompt gives the agent too much freedom. Too much freedom usually creates random architecture.

## The Main Workflow 🔁

Every real feature should move like this:

```text
Scope
  -> Contract
  -> Tests
  -> Implementation
  -> Observability
  -> Docs
  -> Checks
  -> Review
```

Simple explanation:

1. **Scope**
   Decide what is included and what is not included.

2. **Contract**
   Update OpenAPI and database migrations before runtime code.

3. **Tests**
   Add failing tests or define which gate must fail before the fix.

4. **Implementation**
   Build the smallest useful vertical slice.

5. **Observability**
   Add request IDs, logs, traces, metrics, and redaction rules.

6. **Docs**
   Update docs in the same change.

7. **Checks**
   Run local and CI checks.

8. **Review**
   Human reviews the result, especially for auth, data, deploy, and security.

## What Is A Vertical Slice? 🍰

A vertical slice is one complete path through the system.

Example:

```text
OpenAPI login endpoint
  -> database fields
  -> backend service
  -> HTTP handler
  -> tests
  -> logs/traces
  -> docs
```

This is better than making 50 empty files for future features.

A vertical slice proves that the system actually works.

## Why OpenAPI? 📜

OpenAPI is the API contract. It tells humans, agents, tests, and future SDKs what the API is supposed to do.

In each framework:

```text
packages/contracts/openapi/
```

Important files:

- `openapi.root.yaml` — main contract;
- `modules/*.yaml` — endpoint groups;
- `components/schemas/*.yaml` — shared schemas;
- `endpoints.inventory.tsv` — endpoint list used by checks;
- `dist/` — generated artifacts.

When you change an endpoint, update the contract first.

## Why Database Migrations? 🗄️

Database structure is not a side effect. It is part of the product contract.

Migrations live here:

```text
db/migrations/
```

Rules:

- use append-only migrations;
- keep up/down pairs;
- use UUIDs for domain entities;
- avoid generic `id` columns;
- store tokens/password material only as hashes;
- version business entities when required.

## Why So Many Checks? ✅

Because agents are fast enough to make mistakes at scale.

Checks are cheap brakes.

Common commands inside a framework:

```bash
pnpm run verify:offline
pnpm run verify:contracts
pnpm run template:check
```

What they catch:

- missing required files;
- broken DB contracts;
- oversized files/functions;
- missing OpenAPI examples;
- missing endpoint inventory rows;
- old project leftovers;
- common secret shapes;
- unsafe template residue.

## Folder Tour 🧭

Catalog root:

```text
vibecoding-base/
├─ README.md              # language selector
├─ README.en.md           # English docs
├─ README.ru.md           # Russian docs
├─ FRAMEWORK.md           # catalog-level model
├─ catalog.json           # machine-readable framework catalog
├─ frameworks/            # copyable repo frameworks
└─ tools/scripts/         # catalog-level checks
```

Inside a framework:

```text
framework/
├─ AGENTS.md              # rules for coding agents
├─ FRAMEWORK.md           # framework-specific delivery model
├─ README.md              # framework-specific docs
├─ docs/                  # standards, architecture, ADRs
├─ agents/playbooks/      # step-by-step agent workflows
├─ apps/                  # future runtime apps
├─ packages/contracts/    # OpenAPI contracts
├─ db/migrations/         # SQL migrations
├─ infra/                 # Docker, Nginx, CI examples
└─ tools/scripts/         # checks and helper scripts
```

## Framework Catalog 🗂️

The catalog is stored in:

```text
catalog.json
```

It lists:

- framework id;
- display name;
- path;
- status;
- backend;
- frontend;
- database;
- best use cases.

If you add a new framework, add it to `catalog.json`.

## Adding A New Framework 🧩

Create a new folder:

```text
frameworks/<language>-<frontend>-<database>/
```

Examples:

```text
frameworks/node-react-postgres/
frameworks/rust-react-postgres/
frameworks/php-laravel-inertia/
```

Minimum required files:

- `README.md`;
- `FRAMEWORK.md`;
- `AGENTS.md`;
- `LICENSE`;
- `SECURITY.md`;
- `CONTRIBUTING.md`;
- `package.json` or another clear command manifest;
- `tools/scripts/check_starter_integrity.sh`;
- `tools/scripts/check_template_clean.sh`;
- OpenAPI baseline;
- env examples;
- CI workflow or CI example.

Then run:

```bash
tools/scripts/check_frameworks.sh
```

If it fails, the framework is not ready.

## Public Release Checklist 🚢

Before publishing the catalog:

```bash
tools/scripts/check_frameworks.sh
```

Then check manually:

- no `node_modules`;
- no `.venv`;
- no real `.env`;
- no private IPs;
- no server paths from real projects;
- no real tokens or API keys;
- `catalog.json` matches folders;
- every framework has docs;
- every framework can pass local checks.

## FAQ 🙋

### Is this a boilerplate?

Not exactly. A boilerplate usually gives you app code. This gives you a repo operating model.

### Can I build a real app from it?

Yes. Copy a framework and start implementing vertical slices.

### Why not just ask AI to create everything?

You can. But without repo rules, the output is less predictable. This project gives the AI a stable shape to follow.

### Why are some apps folders empty?

Because this is a foundation. Runtime code should be added through scoped vertical slices, not dumped in all at once.

### Why keep `private: true` in `package.json`?

To prevent accidental npm publishing. The repository can still be public on GitHub.

### Can I remove Android or Qt?

Yes. If your product does not need them, remove the folders and docs together. Do not leave dead rules that agents will follow by mistake.

### Can I use another stack?

Yes. Add a new framework under `frameworks/`.

## License 📄

MIT. See [LICENSE](LICENSE).
