# Security Policy

## Supported Scope

This repository is a starter template, not a hosted service. Security reports should focus on committed template content, scripts, CI examples, dependency metadata, API contracts, migrations, and documentation that could cause unsafe downstream use.

## Reporting

Please open a private security advisory if the repository host supports it. If private advisories are unavailable, contact the maintainers through the public repository profile and avoid posting exploit details in an issue.

## Secrets Policy

Real secrets must never be committed. The repository contains only `*.env.example` files and safe placeholders. Run this before publishing changes:

```bash
pnpm run template:check
pnpm run verify:offline
```

## Baseline Expectations

- Keep auth/session examples hash-only and placeholder-only.
- Keep deployment credentials in CI/repository secrets, never in files.
- Review generated OpenAPI artifacts after contract changes.
- Treat MCP/agent integrations as privileged automation and document allowed tools, scopes, and human checkpoints.
