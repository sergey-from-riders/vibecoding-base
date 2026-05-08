# ADR-0003: Mandatory business data versioning with full snapshots

- Status: accepted
- Date: 2026-03-02

## Context
For operational safety and auditability, business records must support historical review and field-level diffs.
Partial history is not sufficient for reliable incident analysis and rollback decisions.

## Decision
All business (production) entities must have version history tables and DB triggers.

Rules:
- each change writes a full row snapshot (`jsonb`);
- operations covered: `insert`, `update`, `delete`;
- versioning applies to business entities (users, tasks, companies, etc.);
- log/telemetry tables are excluded.

## Consequences
- storage usage increases by design;
- read-time diff is always possible between any two versions;
- migration complexity increases, but data auditability is guaranteed.
