# Contributing

`vibecoding-base` is a standards registry plus composable stack profiles.

Do not add a copied stack folder. Add reusable standards, templates and stack profiles instead.

## Contribution Types

1. Standard changes: edit `registry/standards/<id>/`.
2. Stack profile changes: edit `registry/stacks/<stack>.yaml`.
3. Template changes: edit `registry/templates/<template>/`.
4. Check changes: edit `registry/checks/`.
5. Docs changes: edit `docs/`.

## Standard Change Checklist

1. Update `standard.md`.
2. Update `standard.yaml`.
3. Update `CHANGELOG.md`.
4. Mark breaking/non-breaking impact.
5. Update `checks.yaml` if automated enforcement changed.
6. Add migration notes for breaking profile changes.
7. Regenerate examples if active output changes.
8. Run `node tools/vibe.mjs verify`.

## Review Model

Every standard has `owners`.

1. Stable standard changes need review from an owner.
2. Breaking changes need a major version bump.
3. CI-blocking enforcement must point to a real check.
4. Stack profiles should pin compatible ranges.
5. Generated projects pin exact versions through `.vibe/registry.lock`.

## Local Validation

```bash
node tools/vibe.mjs verify
```

The verify command checks registry references, schemas, enforcement claims, generated examples and no-clutter project structure.

Do not add fake lockfiles or fake enforcement. If a template is a placeholder, keep its readiness and README honest.
