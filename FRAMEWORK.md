# vibecoding-base Framework Model

`vibecoding-base` is a framework catalog. A framework is a copyable repository shape with executable rules.

Each framework should answer five questions before the first feature is written:

1. What can agents change?
2. Where is the API contract?
3. How does data evolve?
4. Which checks prove the work?
5. When must a human review the change?

## Framework Contract

A framework in this catalog must include:

- agent instructions;
- human delivery workflow;
- contract-first API baseline;
- migration-first database baseline;
- quality gates;
- security policy;
- env/deploy conventions;
- public-template hygiene checks.

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

## Catalog Rules

1. A framework must be useful when copied alone.
2. A framework must not depend on private infrastructure.
3. A framework must not contain real secrets.
4. A framework must have a clear stack identity.
5. A framework must pass its own local checks.
6. A framework should be strict enough for agents and readable enough for humans.

## Framework Status

Use these statuses in `catalog.json`:

- `ready`: safe to copy and use as a template.
- `draft`: structure exists but docs/checks are incomplete.
- `experimental`: useful but not yet recommended as a default.
- `deprecated`: kept for reference only.

## Review Checklist For New Frameworks

- Is the stack name clear?
- Are commands documented?
- Does `template:check` block obvious public-release mistakes?
- Are contracts generated and checked?
- Are env examples safe?
- Does CI run the same gates as local commands?
- Is there a clear first vertical slice path?
- Does the framework avoid promising runtime code it does not contain?
