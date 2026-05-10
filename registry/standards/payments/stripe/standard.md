# Stripe Payments Standard

This experimental optional standard applies when a project enables Stripe payments.

## Rules

1. Payment state changes must be driven by verified webhooks.
2. Raw card data must never touch the application server.
3. Webhook idempotency is mandatory.
4. Payment events must be auditable.
5. Test mode and live mode secrets must stay separate.

## Enforcement Reality

This standard is documented only until a concrete payments module and webhook test gate are selected.
