# 14. Commit Standards (2026)

This document defines how we write commits in Python React Postgres Framework.

## 1) Baseline standards

We use the following public standards together:
- Conventional Commits 1.0.0
- Semantic Versioning 2.0.0
- Keep a Changelog 1.1.0
- Git trailers for structured metadata

## 2) Commit format

Header:
`<type>(<scope>): <subject>`

Examples of `type`:
- `feat` — new functionality
- `fix` — bug fix
- `docs` — documentation changes
- `refactor` — code restructuring without behavior change
- `test` — tests only
- `build` — build system/dependencies
- `ci` — CI/CD pipeline changes
- `chore` — maintenance tasks
- `perf` — performance improvements
- `revert` — explicit rollback commit

Rules:
- Subject in English.
- Imperative mood.
- Subject should be concise and specific.
- Use scope whenever possible (e.g. `auth`, `deploy`, `db`, `ui`, `android-webview`).

## 3) Detailed commit body (required for non-trivial changes)

Body sections (recommended):
- `Why:` problem or motivation
- `What:` concrete changes
- `Impact:` runtime/deploy/migration impact
- `Validation:` tests/checks performed

Example:

```text
feat(deploy): switch runtime to image-based server rollout

Why:
Current rollout path was ambiguous about whether code is built on server.

What:
- Added explicit image-based deployment model docs
- Updated remote deploy script to sync manifests only
- Added CI template for build/push/deploy workflow

Impact:
- Server now expects prebuilt images in registry
- Rollback is performed by pinning previous image tags

Validation:
- Verified compose and nginx templates are consistent
- Reviewed env templates for required image variables
```

## 4) Breaking changes

Use either:
- `!` in header: `feat(api)!: ...`
- or footer: `BREAKING CHANGE: ...`

When breaking change is present, migration notes are mandatory.

## 5) Footers and metadata

Use Git trailers in footer when relevant:
- `Refs: #123`
- `Closes: #456`
- `BREAKING CHANGE: ...`
- `Co-authored-by: Name <email>`
- `Signed-off-by: Name <email>`

## 6) Granularity and sequencing

One logical unit per commit.
Do not mix unrelated concerns.

Recommended progressive sequence for a feature branch:
1. `chore(scope): scaffold / prerequisites`
2. `feat(scope): implement behavior`
3. `fix(scope): edge-case corrections`
4. `test(scope): add/adjust tests`
5. `docs(scope): update docs/runbook`

This sequence keeps history clear and supports clean cherry-pick/revert workflows.

## 7) Language policy

Commit messages are written in English.
Project docs may be Russian or bilingual.

## 8) Minimum quality gate before commit

Before each commit:
1. No unrelated file changes staged.
2. Changes fit one intent.
3. Commit message follows format.
4. Required tests for changed scope are green (see `docs/17-TESTING-TDD-QUALITY-GATES.md`).
5. Impact/validation are documented in body for non-trivial changes.
