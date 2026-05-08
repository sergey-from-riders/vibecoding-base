# Security Policy

`vibecoding-base` is a catalog of copyable repository frameworks. Security reports should focus on template content that could lead downstream users to leak secrets, weaken auth/session handling, misconfigure CI/deploy, or grant unsafe agent/MCP access.

## Reporting

Use private security advisories when available. If private advisories are unavailable, contact the maintainers through the repository profile and avoid publishing exploit details in public issues.

## Rules For Frameworks

- Real secrets are never committed.
- Only `*.env.example` files are allowed.
- Example domains should use `example.test` or clear placeholders.
- CI/deploy credentials must be referenced through repository secrets.
- Generated contract artifacts must be reviewed after contract changes.
- Agent/MCP write access must require human checkpoints.

Run before publishing:

```bash
tools/scripts/check_frameworks.sh
```
