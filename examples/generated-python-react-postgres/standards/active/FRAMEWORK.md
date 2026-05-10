<!-- Generated from registry/standards/framework/lifecycle@1.0.0. Update the registry standard, then regenerate. -->

# Kalka Framework

Kalka is the operating model behind this repository: a lightweight framework for building software with humans and coding agents in the same repo.

The core idea is simple: agents are fast, but they need rails. Kalka gives them rails through contracts, playbooks, docs, checks, and human checkpoints.

## Principles

### 1. Context Before Code

Every non-trivial change starts by reading the repository rules:

- `AGENTS.md`
- relevant docs in `docs/`
- relevant playbook in `agents/playbooks/`
- existing contracts and migrations

If the agent does not know the local rules, it should not write code.

### 2. Scope Before Speed

Fast implementation is useful only inside a clear boundary. New product domains, architecture changes, data model changes, and deployment changes need an ADR or an explicit update to an existing decision.

Default scope for this starter:

- Auth
- session lifecycle
- company context
- API docs/testing assets

Everything else is opt-in.

### 3. Contract Before Runtime

The contract is the source of truth:

- API behavior starts in OpenAPI.
- Data behavior starts in migrations.
- UI behavior follows API and design tokens.
- SDKs follow generated or maintained contracts.

Runtime code should not invent hidden APIs.

### 4. Red Before Green

A task is not implementation-ready until the expected failure is clear:

- failing unit test;
- failing integration test;
- failing e2e scenario;
- failing contract coverage;
- failing static gate;
- or a documented reason why a different gate is used.

### 5. Vertical Slice Over Horizontal Piles

Prefer one thin complete path over many unfinished layers.

Good:

```text
OpenAPI -> migration -> service -> handler -> test -> docs
```

Risky:

```text
many schemas -> many empty handlers -> no tests -> no behavior
```

### 6. Observable By Default

Every real feature should carry:

- request ID propagation;
- structured logs;
- traces for request flow;
- metrics for latency/errors/security-sensitive flows;
- redaction for secrets and tokens.

### 7. Human Checkpoints For Dangerous Work

Humans must review before:

- deployment;
- schema/data migration with real data impact;
- auth/session/security changes;
- enabling MCP or other integrations with write access;
- destructive git operations;
- secret rotation.

### 8. Public Template Hygiene

The repository must stay reusable:

- no real secrets;
- no private hostnames or server paths;
- no product-specific leftovers;
- no committed `.env`;
- no dependency vendor folders;
- safe placeholder domains only.

## Lifecycle

Every meaningful task moves through this lifecycle:

```text
Idea
  -> Scope
  -> ADR or task log
  -> Contract
  -> Test plan
  -> Red
  -> Implementation
  -> Green
  -> Observability
  -> Docs
  -> Review
  -> Merge
```

## Task Anatomy

A good task has:

- title;
- scope;
- non-goals;
- files/modules likely to change;
- contract impact;
- data impact;
- tests/gates;
- security impact;
- docs impact;
- acceptance criteria.

Example:

```md
# Task: Auth login vertical slice

Scope:
- apps/api
- packages/contracts/openapi
- db/migrations
- docs

Non-goals:
- OAuth providers
- UI polish
- Android/Qt

Acceptance:
- login endpoint follows OpenAPI contract
- token stored only as hash
- request_id is returned and logged
- integration test covers success and invalid password
- verify:offline and verify:contracts pass
```

## Agent Roles

You can use one agent or multiple agents, but keep ownership explicit.

### Planner

Reads docs, scopes work, identifies risks, and proposes file ownership.

### Contract Agent

Updates OpenAPI, endpoint inventory, examples, schemas, and generated artifacts.

### Backend Agent

Implements service, handler, repository, middleware, integration tests, and observability.

### Frontend Agent

Implements UI against existing contracts, using shared API clients and design tokens.

### QA Agent

Runs checks, reviews edge cases, and verifies regression coverage.

### Security Agent

Reviews auth/session/storage/logging/secret handling and incident runbook impact.

For small tasks, one agent can cover multiple roles. For larger tasks, split by file ownership to avoid conflicts.

## Definition Of Ready

A task is ready when:

- the scope is narrow;
- the owner understands the relevant docs;
- API/data impact is known;
- security impact is known;
- expected validation is listed;
- non-goals are explicit.

## Definition Of Done

A task is done when:

- implementation matches the contract;
- tests or gates prove behavior;
- docs are updated;
- generated artifacts are refreshed;
- template clean check still passes;
- unresolved risks are documented;
- human checkpoints were completed where required.

## Standard Workflow For A New Endpoint

1. Add endpoint to `packages/contracts/openapi/modules/<module>.yaml`.
2. Add or update schemas in `components/schemas`.
3. Add row to `endpoints.inventory.tsv`.
4. Add examples and `x-codeSamples`.
5. Run `pnpm run verify:contracts`.
6. Add backend handler/service tests.
7. Implement backend service and handler.
8. Add observability.
9. Update docs/playbooks if the pattern is new.

## Standard Workflow For A New Table

1. Read `docs/07-DB-NAMING-CONVENTIONS.md`.
2. Read `docs/15-DATA-VERSIONING-AND-DIFF.md`.
3. Add append-only up/down migrations.
4. Use UUID entity IDs and canonical FK names.
5. Add versioning tables/triggers for business entities.
6. Run `pnpm run db:check`.
7. Update schema docs.

## Standard Workflow For UI

1. Read `docs/08-UI-CROSS-PLATFORM-RULES.md`.
2. Read `docs/19-NEXT-NODE-FRONTEND-STANDARD.md`.
3. Reuse shared components and API clients.
4. Do not duplicate backend validation.
5. Use design tokens.
6. Add component/integration/e2e coverage for changed flows.
7. Run `pnpm run limits:web`.

## Prompt Pattern

Use prompts with this shape:

```text
Read AGENTS.md and FRAMEWORK.md first.

Task:
<one clear outcome>

Scope:
<allowed folders/files>

Non-goals:
<what not to touch>

Required docs:
<docs/playbooks to read>

Validation:
<commands/tests that must pass>

Output:
- changed files
- validation results
- unresolved risks
```

## Review Pattern

Review agent work in this order:

1. Scope: did it touch only intended files?
2. Contract: did API/data behavior drift?
3. Security: did secrets, tokens, auth, logging, or MCP access get weaker?
4. Tests: are failures meaningful and are green checks real?
5. Docs: can the next agent understand the new state?
6. Maintainability: did it add duplication or hidden coupling?

## Anti-Patterns

Avoid:

- "implement everything" prompts;
- UI before backend contract;
- schema edits without migrations;
- generated code without source changes;
- passing tests by weakening gates;
- adding MCP write access without a human checkpoint;
- keeping outdated docs because "the code works";
- treating agent output as reviewed code.

## Framework Files

The framework is spread across:

- `FRAMEWORK.md` - operating model;
- `AGENTS.md` - agent rules;
- `docs/06-VIBECODING-WORKFLOW.md` - task workflow;
- `docs/17-TESTING-TDD-QUALITY-GATES.md` - quality gates;
- `docs/25-MCP-AGENTS-OPERATIONS-STANDARD.md` - MCP and agent safety;
- `agents/playbooks/` - task-specific playbooks;
- `tools/scripts/` - executable gates.

Keep these files synchronized. If one changes the workflow, update the others.
