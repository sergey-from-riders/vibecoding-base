# React Native Mobile Standard

This experimental optional standard applies when a project enables a React Native mobile client.

Mobile is optional. A generated project must not contain mobile folders, mobile standards or mobile runtime assumptions until `vibe enable mobile react-native` is used.

## May 2026 Baseline

1. React Native baseline: `0.85.x`.
2. React baseline: `19.2.x` where supported by the chosen RN release.
3. Node.js baseline: supported LTS only, with Node 24 preferred for new projects.
4. Hermes is the default JavaScript engine unless a project documents why not.
5. New Architecture compatibility is expected for new native modules.

## Architecture Rules

1. Mobile must not duplicate backend business rules.
2. API access must use the shared generated or maintained client.
3. Secure storage must be used for sensitive local state.
4. Deep links and auth handoff must be tested.
5. Offline behavior must be explicitly scoped before implementation.
6. Native modules require an owner and upgrade note.
7. Shared UI/business packages must not depend on platform-only APIs.

## Security Rules

1. Tokens use platform secure storage, not AsyncStorage.
2. Biometric auth is a local unlock convenience, not the primary server auth proof.
3. Deep links validate scheme, host, path and state.
4. Push notifications must not contain secrets or sensitive payloads.
5. Certificate pinning is optional and must include an operational rotation plan.

## Offline And Sync

1. Offline writes require idempotency keys.
2. Sync queues require retry limits and conflict handling.
3. Local caches must define what can be stored and for how long.
4. Destructive actions require clear confirmation and replay-safe behavior.

## Release And OTA Policy

1. OTA updates may change JS/UI only within the app-store-approved native capability set.
2. Native dependency changes require normal binary release.
3. Runtime config and feature flags must fail closed.
4. Crash-free and startup metrics are required before production rollout.

## Accessibility

1. WCAG 2.2 concepts apply where relevant.
2. Platform screen readers must work for core flows.
3. Touch targets must be usable on small devices.
4. Critical flows must not require drag-only gestures.

## Enforcement Reality

This standard is documented only until a concrete mobile runtime and checks are selected.
