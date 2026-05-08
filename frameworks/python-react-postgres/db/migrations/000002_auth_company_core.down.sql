-- Python React Postgres Framework 2026: rollback auth + company context core schema

DROP TABLE IF EXISTS auth_events;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS company_memberships;

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_current_company_id_fkey;

DROP TRIGGER IF EXISTS trg_companies_set_updated_at ON companies;
DROP TABLE IF EXISTS companies;

DROP TRIGGER IF EXISTS trg_users_set_updated_at ON users;
DROP TABLE IF EXISTS users;

DROP FUNCTION IF EXISTS set_updated_at_now();
