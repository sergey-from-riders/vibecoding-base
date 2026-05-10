# Contributing Standards

Standards are first-class versioned units. Do not hide a rule inside a stack folder.

## Create A New Standard

Create:

```text
registry/standards/<domain>/<name>/
  standard.yaml
  standard.md
  CHANGELOG.md
  README.md
```

Add `checks.yaml` only if there is a real automated check.

`standard.yaml` must include:

1. `id`
2. `name`
3. `version`
4. `status`
5. `domain`
6. `owners`
7. `applies_to`
8. `dependencies`
9. `enforcement`
10. `files`
11. `compatibility`
12. `changelog`

Run:

```bash
node tools/vibe.mjs verify
```

## Change An Existing Standard

When changing a standard:

1. Update `standard.md`.
2. Update `standard.yaml`.
3. Update `CHANGELOG.md`.
4. Mark whether the change is breaking or non-breaking.
5. Update `checks.yaml` if the rule is automatically checked.
6. Run `node tools/vibe.mjs verify`.
7. Add a migration note if the change breaks existing stack profiles or generated projects.

## Enforcement Rules

Do not claim enforcement that does not exist.

Use:

```yaml
enforcement:
  documented: true
  linted: false
  tested: false
  ci_blocking: false
```

Set `linted`, `tested` or `ci_blocking` to `true` only when `checks.yaml` references a real check file.

## Review Model

Each standard has owners:

```yaml
owners:
  - backend
```

Rules:

1. Stable standard changes require review from an owner.
2. Breaking changes require a major version bump.
3. Stack profiles must keep compatible version ranges.
4. Generated project lockfiles must pin exact versions.
5. Deprecated standards must include migration guidance.

## Updating A Stack Profile

When adding a standard to a stack:

1. Add the standard reference to `registry/stacks/<stack>.yaml`.
2. Add any required templates.
3. Add checks only if they exist in `registry/checks`.
4. Regenerate examples.
5. Run `node tools/vibe.mjs verify`.

## Adding Checks

Add a check under:

```text
registry/checks/<check_id>.sh
```

Then reference it from:

1. the relevant `checks.yaml`;
2. stack profile `checks`;
3. generated `scripts/check.sh` logic if it must run inside copied projects.

## Deprecating A Standard

Set:

```yaml
status: deprecated
```

Then update `CHANGELOG.md` with:

1. reason;
2. replacement standard;
3. migration steps;
4. last compatible stack profiles.
