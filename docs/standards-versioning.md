# Standards Versioning

Standards use SemVer.

```text
MAJOR.MINOR.PATCH
```

Stack profiles may use compatible ranges such as:

```yaml
standards:
  - backend/go@^1.0.0
```

Generated projects pin exact versions in `.vibe/registry.lock`.

## PATCH

Use PATCH for non-breaking changes:

1. typos;
2. clearer wording;
3. examples that do not change behavior;
4. non-breaking check fixes;
5. metadata corrections that do not change active behavior.

Example:

```text
1.0.0 -> 1.0.1
```

## MINOR

Use MINOR for compatible additions:

1. new recommendations;
2. optional checks;
3. additional examples;
4. new non-required metadata;
5. new optional templates.

Example:

```text
1.0.0 -> 1.1.0
```

## MAJOR

Use MAJOR for breaking changes:

1. stricter required checks;
2. incompatible folder structure;
3. changed required runtime baseline;
4. removed rules;
5. changed generated file names;
6. new CI-blocking enforcement.

Example:

```text
1.0.0 -> 2.0.0
```

## Changelog Requirements

Each `CHANGELOG.md` entry must say:

1. what changed;
2. whether it is breaking;
3. migration steps if needed;
4. affected stack profiles;
5. affected checks.

## Owner Review

Stable standards require owner review. Breaking stable changes require:

1. owner approval;
2. major version bump;
3. migration note;
4. stack profile update;
5. regenerated examples;
6. `node tools/vibe.mjs verify`.
