# Worker Backend Standard

This experimental optional standard applies when a project enables a background worker component.

## Rules

1. Workers must be idempotent.
2. Queue messages must have explicit schemas.
3. Retries must be bounded and observable.
4. Business logic shared with API code must live in a service layer, not inside queue handlers.
5. Dead-letter handling must be documented before production use.

## Enforcement Reality

This standard is documented only until a concrete queue runtime and checks are selected.
