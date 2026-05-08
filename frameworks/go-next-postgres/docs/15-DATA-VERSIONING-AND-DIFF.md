# 15. Data Versioning and Diff Policy (Mandatory)

This policy is mandatory for Go Next Postgres Framework database design.

## 1) Core rule
All business (production) entities must have historical versioning.

Versioning does **not** apply to logs/telemetry tables.

Examples:
- versioned: users, companies, tasks, memberships, orders (future)
- not versioned: auth_events, access logs, metrics tables

## 2) Storage model
For each business table `<entity_plural>`, create version table `<entity_singular>_versions`.

Each change (insert/update/delete) writes a **full snapshot** of the record to version table,
including cases where only one field changed.

## 3) Minimum version table contract
- version PK: `<entity_singular>_version_id uuid`
- entity reference: `<entity_singular>_id uuid`
- `version_no integer` (monotonic per entity)
- `operation_type text` in (`insert`, `update`, `delete`)
- `snapshot jsonb` full row state
- `changed_at timestamptz`
- `changed_by_user_id uuid null`
- `request_id text null`

## 4) Write path
Version rows are written by DB triggers:
- AFTER INSERT / AFTER UPDATE
- BEFORE DELETE

Application code must not bypass this mechanism for business entities.

## 5) Diff capability
Diff is computed between two snapshots:
- `snapshot(version N)` vs `snapshot(version M)`
- UI/API can present field-level changes.

We store full snapshots; diff is a read-time operation.

## 6) Compliance scope
This rule applies to all current and future business entities.
If a new business table is created without `*_versions`, migration is non-compliant.

## 7) Exclusions
Operational log tables are excluded by design:
- `auth_events`
- request/access logs
- telemetry/metrics traces
