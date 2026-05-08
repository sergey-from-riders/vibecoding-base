# Contributing

Contributions should keep `vibecoding-base` as a catalog of reusable frameworks, not a single product repository.

## Adding A Framework

1. Create `frameworks/<stack-name>`.
2. Include `README.md`, `FRAMEWORK.md`, `AGENTS.md`, `LICENSE`, `SECURITY.md`, and `CONTRIBUTING.md`.
3. Include local checks under `tools/scripts`.
4. Keep all env files as examples only.
5. Add the framework to `catalog.json`.
6. Run `tools/scripts/check_frameworks.sh`.

## Review Standard

Frameworks should be:

- copyable without private infrastructure;
- explicit about what is implemented and what is pending;
- strict enough for coding agents;
- documented enough for humans;
- safe for public GitHub publishing.
