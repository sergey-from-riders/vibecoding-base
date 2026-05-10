# Worker Backend Standard

This experimental optional standard applies when a project enables a background worker component.

Workers are optional. A generated project must not contain worker folders, worker standards or queue-specific assumptions until `vibe enable worker` is used.

## May 2026 Baseline

1. Workers are at-least-once by default unless a specific queue proves otherwise.
2. Exactly-once delivery is not assumed.
3. Idempotency is mandatory for side effects.
4. Retry, timeout and dead-letter behavior is part of the contract.
5. Worker telemetry is required before production use.

## Core Rules

1. Workers must be idempotent.
2. Queue messages must have explicit schemas.
3. Retries must be bounded and observable.
4. Business logic shared with API code must live in a service layer, not inside queue handlers.
5. Dead-letter handling must be documented before production use.
6. Poison messages must not block the queue forever.
7. Message handlers must be safe to replay.

## Message Contract

Each message type defines:

1. schema version;
2. message ID;
3. idempotency key;
4. correlation/request ID;
5. created timestamp;
6. tenant/user context when needed;
7. maximum retry count;
8. timeout or lease duration.

## Retry And Failure

1. Retries use exponential backoff with jitter.
2. Permanent failures are distinguishable from transient failures.
3. Dead-letter entries include reason, attempts and safe context.
4. Operators need a replay path before production.
5. Replay must not duplicate side effects.

## Data Consistency

Use one of these patterns for cross-boundary side effects:

1. transactional outbox;
2. inbox/deduplication table;
3. provider idempotency key;
4. explicit reconciliation job.

Do not publish a queue message from a database transaction unless the consistency model is documented.

## Observability

Worker logs/spans/metrics include:

1. queue name;
2. message type;
3. message ID;
4. attempt number;
5. duration;
6. result;
7. dead-letter reason when applicable.

## Tests

Worker features need:

1. idempotency test;
2. retry test;
3. poison message test;
4. schema compatibility test;
5. replay test for side effects.

## Enforcement Reality

This standard is documented only until a concrete queue runtime and checks are selected.
