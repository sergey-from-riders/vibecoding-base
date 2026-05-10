# vibecoding-base Framework Model

`vibecoding-base` is a registry-first framework library.

The framework is not a copied folder. The framework is the composition system:

```text
standards + templates + stack profile + lockfile + generated active context
```

## Principles

1. Registry contains all reusable knowledge.
2. Generated projects contain only active stack context.
3. Standards are independently versioned.
4. Stack profiles compose standards and templates.
5. Lockfiles pin exact generated versions.
6. Enforcement must be honest.
7. Disabled features must not create folders.

## Delivery Loop

```text
Scope
  -> Contract
  -> Test
  -> Slice
  -> Observe
  -> Document
  -> Gate
  -> Review
```

## No-Clutter Rule

Generated projects must not contain unused technology folders. Add optional parts only through:

```bash
node tools/vibe.mjs enable <feature> [variant] --project <dir>
```

## Review Checklist

1. Does the change update the registry source of truth?
2. Does it avoid duplicated standards?
3. Does `standard.yaml` match the standard content?
4. Does enforcement point to real checks?
5. Does the stack status matrix avoid overclaiming readiness?
6. Do generated examples still pass `node tools/vibe.mjs verify`?
