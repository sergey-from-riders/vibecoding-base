# db/migrations

Migration policy:
- paired files: `NNNNNN_name.up.sql` + `NNNNNN_name.down.sql`
- append-only
- no manual schema drift
- ID naming contract is mandatory:
  - entity PK: `<entity>_id uuid`
  - FK: `<target_entity>_id uuid`
  - no generic `id` columns for domain keys
- business versioning contract is mandatory:
  - each business table must have `*_versions`
  - full snapshot written on each insert/update/delete
  - log tables are excluded

Starter verification:
- base generated projects check that migration files exist through `scripts/check.sh`
- add a real DB contract checker before marking database checks as runtime-enforced

Current foundation migrations:
1. `000001` — PostgreSQL extensions.
2. `000002` — base users/companies/memberships/sessions/auth events.
3. `000003` — business versioning for users/companies/memberships.
4. `000004` — auth identities, device credentials, session hash alignment, and remaining version tables.
