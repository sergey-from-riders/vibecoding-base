<!-- Generated from registry/standards/agent/base@1.0.0. Update the registry standard, then regenerate. -->

# Agent Base Standard

This standard defines the minimum working contract for humans and coding agents in a generated project.

## Purpose

Agents are allowed to move fast only when the active project context is explicit. A generated project must expose:

1. the active stack;
2. the standards that apply to the active stack;
3. the folders that are intentionally enabled;
4. the folders that are intentionally disabled;
5. the quality gates that block acceptance.

## Required Generated Files

Every generated project must contain:

1. `AGENTS.md`
2. `standards/active/AGENTS.md`
3. `.vibe/profile.yaml`
4. `.vibe/enabled.yaml`
5. `.vibe/registry.lock`
6. `scripts/check.sh`

`AGENTS.md` is generated from the active stack profile. It must not list inactive stacks or future optional features.

## Agent Read Order

For a normal task, read:

1. `AGENTS.md`
2. the relevant files in `standards/active/`
3. `.vibe/profile.yaml`
4. `.vibe/registry.lock` when changing standards or stack composition

## Forbidden

1. Do not add unused folders.
2. Do not add disabled technologies without updating `.vibe/profile.yaml`.
3. Do not bypass quality gates.
4. Do not commit real secrets.
5. Do not duplicate business logic across API/web/mobile.
6. Do not change standard versions without updating `.vibe/registry.lock`.

## Task Flow

Every non-trivial change follows:

```text
spec -> contract -> failing check/test -> implementation -> green checks -> docs
```

If a project cannot run a check yet, the limitation must be visible in the status matrix and in the task notes.
