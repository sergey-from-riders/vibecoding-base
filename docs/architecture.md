# Architecture

`vibecoding-base` is registry-first.

The registry is the source of truth. Generated projects are consumers of one selected stack profile.

## Registry vs Generated Project

The registry contains everything that can be composed:

```text
registry/standards
registry/stacks
registry/templates
registry/checks
registry/schemas
```

A generated project contains only active context:

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

The generated project must not contain all stacks, all standards or all templates.

## Duplication Policy

Forbidden duplication:

1. copying the same standard into multiple stack folders;
2. maintaining standards inside generated examples;
3. adding a second source of truth under `docs/` for rules already owned by `registry/standards`;
4. copying inactive feature templates into a generated project.

Allowed generated copies:

1. `standards/active/*` inside generated projects;
2. generated example projects under `examples/`;
3. lockfile snapshots in `.vibe/registry.lock`.

Allowed copies are derived artifacts. They must be regenerated from the registry and verified for drift.

## Stack Profile

A stack profile is YAML composition:

```yaml
id: go-next-postgres
components:
  backend: go
  frontend: next
  database: postgres
standards:
  - backend/go@^1.0.0
templates:
  - backend/go
checks:
  - check_structure
```

Profiles select standards and templates. They do not duplicate the standards.

## Active Standards

The generator copies only selected standards into:

```text
standards/active/
```

This gives agents short local context without copying the entire registry.

## Optional Features

Optional features exist in stack profiles:

```yaml
optional_features:
  mobile:
    variants:
      react-native:
        templates:
          - mobile/react-native
        standards:
          - mobile/react-native@^1.0.0
```

Disabled features must not create project folders. `vibe enable` adds only the selected feature. `vibe disable` removes the feature paths and regenerates active standards/lockfile.

## Lockfile

`.vibe/registry.lock` pins exact standard and template versions:

```yaml
standards:
  backend/go: 1.0.0
templates:
  backend/go: 1.0.0
```

The profile can say `backend/go@^1.0.0`; the lockfile records the resolved version.

## Generated AGENTS.md

`AGENTS.md` is generated from the active profile. It must list only the chosen stack and active read order.

It must not mention inactive future stacks as if they exist in the project.

## Verify

`vibe verify` checks:

1. registry standard metadata;
2. stack profile references;
3. template references;
4. check references;
5. required changelog/owners/version fields;
6. enforcement claims versus actual checks;
7. generated project no-clutter rules;
8. active standards and lockfile consistency.
9. active standard file content against the registry source.
10. exact duplicate standard bodies inside `registry/standards`.
