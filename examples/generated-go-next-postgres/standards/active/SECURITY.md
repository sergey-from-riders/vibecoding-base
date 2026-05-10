<!-- Generated from registry/standards/security/no-secrets@1.0.0. Update the registry standard, then regenerate. -->

# No Secrets Security Standard

This standard keeps generated projects safe for public repositories.

## Rules

1. Real secrets are never committed.
2. `.env` files are ignored.
3. Only `.env.example` files may be committed.
4. Tokens, private keys, passwords and production hostnames must not appear in templates.
5. Generated projects must include a hygiene check before publish.
6. Incident notes must explain how to rotate leaked credentials.

## Secret Shapes

The hygiene check must scan for common secret shapes:

1. private key headers;
2. GitHub PATs;
3. OpenAI/API-style `sk-` keys;
4. AWS access keys;
5. Google API keys;
6. Slack tokens;
7. obvious `client_secret` or `api_key` assignments.

## Template Hygiene

Templates must not include:

1. private company names;
2. private hostnames;
3. personal server paths;
4. production URLs;
5. real account IDs;
6. dependency vendor folders.

## Incident Response

If a real credential is found:

1. stop publishing;
2. revoke or rotate the credential;
3. remove it from the working tree;
4. rewrite public history only with explicit owner approval;
5. document the incident and prevention check.
