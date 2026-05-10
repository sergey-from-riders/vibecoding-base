-- Generated stack 2026: rollback unified identity and device restore schema alignment

DROP TRIGGER IF EXISTS trg_device_credential_versions_delete ON device_credentials;
DROP TRIGGER IF EXISTS trg_device_credential_versions_write ON device_credentials;
DROP TRIGGER IF EXISTS trg_auth_identity_versions_delete ON auth_identities;
DROP TRIGGER IF EXISTS trg_auth_identity_versions_write ON auth_identities;

DROP FUNCTION IF EXISTS device_credential_versions_on_delete();
DROP FUNCTION IF EXISTS device_credential_versions_on_write();
DROP FUNCTION IF EXISTS auth_identity_versions_on_delete();
DROP FUNCTION IF EXISTS auth_identity_versions_on_write();

DROP TABLE IF EXISTS device_credential_versions;
DROP TABLE IF EXISTS auth_identity_versions;

DROP TRIGGER IF EXISTS trg_device_credentials_set_updated_at ON device_credentials;
DROP TRIGGER IF EXISTS trg_auth_identities_set_updated_at ON auth_identities;

DROP TABLE IF EXISTS device_credentials;
DROP TABLE IF EXISTS auth_identities;

DROP TRIGGER IF EXISTS trg_sessions_set_updated_at ON sessions;

ALTER TABLE sessions
  DROP CONSTRAINT IF EXISTS sessions_client_type_check,
  DROP CONSTRAINT IF EXISTS sessions_refresh_token_hash_key,
  DROP COLUMN IF EXISTS revoked_reason,
  DROP COLUMN IF EXISTS updated_at,
  DROP COLUMN IF EXISTS client_type,
  DROP COLUMN IF EXISTS refresh_token_hash;

ALTER TABLE sessions
  RENAME COLUMN session_token_hash TO token_hash;
