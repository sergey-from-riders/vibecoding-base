# Security Policy

`vibecoding-base` is intended for public starter generation. Security issues usually mean a template, standard or generated project could leak secrets, weaken auth/session handling, misconfigure CI/deploy, or give agents unsafe write access.

## Reporting

Use private security advisories when available. If private advisories are unavailable, contact the maintainers through the repository profile and avoid publishing exploit details in public issues.

## Public Template Rules

1. Real secrets are never committed.
2. Only `*.env.example` files may be committed.
3. Tokens must be referenced through environment variables or repository secrets.
4. Generated examples must not contain private hostnames, server paths or credentials.
5. CI/deploy examples must use placeholder values.
6. Agent/MCP write access must require human checkpoints.

Run before publishing:

```bash
node tools/vibe.mjs verify
```
