# Stripe Payments Standard

This experimental optional standard applies when a project enables Stripe payments.

Payments are optional. A generated project must not contain payment code, payment standards or Stripe-specific folders until `vibe enable payments stripe` is used.

## May 2026 Baseline

1. Pin the Stripe API version explicitly.
2. Current Clover GA baseline is `2026-02-25.clover` unless the project chooses a different pinned version.
3. Payment state changes are driven by verified webhooks.
4. Application servers never handle raw card data.
5. Every payment mutation is idempotent.

## Core Rules

1. Payment state changes must be driven by verified webhooks.
2. Raw card data must never touch the application server.
3. Webhook idempotency is mandatory.
4. Payment events must be auditable.
5. Test mode and live mode secrets must stay separate.
6. API version changes require a migration note.
7. Test clocks or equivalent deterministic tests are required for subscription flows.

## Payment Flow Rules

1. Prefer Checkout or PaymentIntents over custom card collection.
2. Store provider IDs, not card details.
3. Persist a local payment/order state machine.
4. Treat redirect return URLs as hints; final truth comes from webhooks.
5. Do not mark paid on the client callback alone.

## Webhook Rules

1. Verify webhook signatures.
2. Persist event IDs before processing side effects.
3. Duplicate events are safe no-ops.
4. Out-of-order events are handled through state transitions.
5. Failed processing is retryable.
6. Poison events move to a review queue with redacted payload context.

## Reconciliation

Production payments need:

1. provider event ledger;
2. local state ledger;
3. daily reconciliation job or manual runbook;
4. refund and dispute handling;
5. dashboard showing mismatches;
6. audit trail for operator actions.

## Security And Compliance

1. Keep PCI scope low by avoiding raw card data.
2. Keep publishable and secret keys separate.
3. Rotate webhook secrets deliberately.
4. Do not log full provider payloads when they contain personal or payment data.
5. Use least-privilege restricted keys when possible.
6. Store idempotency keys or hashes according to data retention policy.

## Test Requirements

1. Webhook signature validation test.
2. Duplicate webhook test.
3. Out-of-order webhook test.
4. Payment success/failure tests.
5. Refund/dispute tests when those flows are enabled.
6. Live-mode guard test to prevent accidental live charges in CI.

## Enforcement Reality

This standard is documented only until a concrete payments module and webhook test gate are selected.
