# Skill: commit-craft

## When to use
- any task that produces more than one logical change;
- any task that modifies runtime, deployment, database, or contracts;
- any task where commit history must be release-grade.

## Required pre-read
- `docs/14-COMMIT-STANDARDS-2026.md`

## Procedure
1. Split changes by intent:
- scaffold/prerequisites
- feature behavior
- fixes
- tests
- docs

2. Stage selectively per commit.

3. Write English commit messages in Conventional Commits format.

4. For non-trivial commits, include body sections:
- `Why:`
- `What:`
- `Impact:`
- `Validation:`

5. If breaking, add `!` and `BREAKING CHANGE:` footer.

## Definition of done
- commits are atomic and readable;
- commit types (`feat/fix/chore/docs/...`) are correct;
- history supports easy review and rollback.
