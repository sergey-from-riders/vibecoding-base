# db/seeds

Deterministic fixtures for local and integration environments.

## Mandatory fixture: universal regression account

For test/stage environments, seed must include a universal account used by CI/e2e regression:
- activated user;
- memberships in at least two companies;
- linked auth identities (`password` and connected social providers where enabled);
- multiple sessions to validate revoke-one/revoke-others behavior.

Rules:
- only non-production;
- credentials are provided via CI/test secrets (`APP_E2E_*`);
- no plaintext production credentials in repository.
