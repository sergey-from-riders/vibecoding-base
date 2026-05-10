# Stack Profiles

Stack profiles are YAML compositions. They choose standards, templates and checks without copying their content.

## Required Fields

```yaml
id: go-next-postgres
name: Go + Next.js + PostgreSQL
status: stable
description: Full-stack web app profile.
components:
  backend: go
standards:
  - backend/go@^1.0.0
templates:
  - backend/go
checks:
  - check_structure
readiness:
  template: ready
  runtime: partial
  checks: partial
  docs: ready
```

## Status Matrix

Use separate readiness fields:

| Field | Meaning |
| --- | --- |
| `template` | Files can be generated. |
| `runtime` | Runtime code is runnable and complete enough for the stated use. |
| `checks` | Automated checks cover the stated rules. |
| `docs` | Human/agent docs are usable. |

Allowed values:

- `ready`
- `partial`
- `missing`

## Adding A Stack

1. Create `registry/stacks/<stack-id>.yaml`.
2. Reuse existing standards where possible.
3. Add new standards only when rules genuinely differ.
4. Add templates under `registry/templates`.
5. Add checks under `registry/checks` only when real automation exists.
6. Generate an example project.
7. Run `node tools/vibe.mjs verify`.

## Optional Features

Optional features live under `optional_features`.

Simple feature:

```yaml
optional_features:
  worker:
    templates:
      - worker/base
    standards:
      - backend/worker@^1.0.0
```

Feature with variants:

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

Generated projects must not receive optional feature folders until `vibe enable` is run.

## Reusing Standards

Do not copy a common rule into each stack. Put it in `registry/standards` and reference it:

```yaml
standards:
  - security/no-secrets@^1.0.0
  - testing/tdd-strict@^1.0.0
```

If two stacks differ only by backend/runtime, share the common standards and swap only the specific ones.
