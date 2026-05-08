# Contributing

This repository is an AI-native starter template. Contributions should preserve the template nature of the project: no real product secrets, no private infrastructure metadata, and no domain-specific business modules unless they are clearly framed as examples.

## Change Rules

1. Keep changes contract-first: update OpenAPI, DB migrations, tests/checks, and docs together.
2. Keep the starter clean: use `APP_*`, `NEXT_PUBLIC_APP_*`, `example.test`, and placeholder credentials only.
3. Do not add runtime application code without updating the relevant engineering standard in `docs/`.
4. Do not weaken quality gates to make a change pass.

## Local Validation

```bash
pnpm install
pnpm run verify:offline
pnpm run verify:contracts
```

For changes that do not need dependencies:

```bash
pnpm run template:check
tools/scripts/check_starter_integrity.sh
```

## Agent Workflow

Before agent-heavy changes, read:

- `AGENTS.md`
- `docs/25-MCP-AGENTS-OPERATIONS-STANDARD.md`
- the relevant feature playbook in `agents/playbooks/`

Large changes should include an ADR or update an existing ADR when they alter architecture, toolchain, security posture, deployment model, or public contracts.
