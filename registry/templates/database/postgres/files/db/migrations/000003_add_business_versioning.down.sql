-- Generated stack 2026: rollback mandatory business-entity versioning

DROP TRIGGER IF EXISTS trg_company_membership_versions_delete ON company_memberships;
DROP TRIGGER IF EXISTS trg_company_membership_versions_write ON company_memberships;
DROP TRIGGER IF EXISTS trg_company_versions_delete ON companies;
DROP TRIGGER IF EXISTS trg_company_versions_write ON companies;
DROP TRIGGER IF EXISTS trg_user_versions_delete ON users;
DROP TRIGGER IF EXISTS trg_user_versions_write ON users;

DROP FUNCTION IF EXISTS company_membership_versions_on_delete();
DROP FUNCTION IF EXISTS company_membership_versions_on_write();
DROP FUNCTION IF EXISTS company_versions_on_delete();
DROP FUNCTION IF EXISTS company_versions_on_write();
DROP FUNCTION IF EXISTS user_versions_on_delete();
DROP FUNCTION IF EXISTS user_versions_on_write();

DROP TABLE IF EXISTS company_membership_versions;
DROP TABLE IF EXISTS company_versions;
DROP TABLE IF EXISTS user_versions;

DROP FUNCTION IF EXISTS rp_current_request_id();
DROP FUNCTION IF EXISTS rp_current_actor();
