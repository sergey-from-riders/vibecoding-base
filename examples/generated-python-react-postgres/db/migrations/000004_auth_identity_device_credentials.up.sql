-- Generated stack 2026: align auth/session schema with unified identity and device restore contract

ALTER TABLE sessions
  RENAME COLUMN token_hash TO session_token_hash;

ALTER TABLE sessions
  ADD COLUMN refresh_token_hash text,
  ADD COLUMN client_type text NOT NULL DEFAULT 'web',
  ADD COLUMN updated_at timestamptz NOT NULL DEFAULT NOW(),
  ADD COLUMN revoked_reason text;

UPDATE sessions
   SET refresh_token_hash = session_token_hash
 WHERE refresh_token_hash IS NULL;

ALTER TABLE sessions
  ALTER COLUMN refresh_token_hash SET NOT NULL,
  ADD CONSTRAINT sessions_refresh_token_hash_key UNIQUE (refresh_token_hash),
  ADD CONSTRAINT sessions_client_type_check
    CHECK (client_type IN (
      'web',
      'telegram-web',
      'qt-windows',
      'qt-macos',
      'qt-linux',
      'android-webview'
    ));

CREATE TRIGGER trg_sessions_set_updated_at
BEFORE UPDATE ON sessions
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_now();

CREATE TABLE auth_identities (
  auth_identity_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,

  provider text NOT NULL,
  provider_subject text NOT NULL,
  provider_email citext,
  provider_login text,
  is_primary boolean NOT NULL DEFAULT false,

  created_at timestamptz NOT NULL DEFAULT NOW(),
  updated_at timestamptz NOT NULL DEFAULT NOW(),
  deleted_at timestamptz,

  CONSTRAINT auth_identities_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,

  CONSTRAINT auth_identities_provider_check
    CHECK (provider IN ('password', 'telegram', 'google', 'yandex', 'vk'))
);

CREATE UNIQUE INDEX idx_auth_identities_provider_subject_unique_active
  ON auth_identities (provider, provider_subject)
  WHERE deleted_at IS NULL;

CREATE UNIQUE INDEX idx_auth_identities_primary_user_unique_active
  ON auth_identities (user_id)
  WHERE is_primary IS TRUE AND deleted_at IS NULL;

CREATE INDEX idx_auth_identities_user_id ON auth_identities (user_id);

CREATE TRIGGER trg_auth_identities_set_updated_at
BEFORE UPDATE ON auth_identities
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_now();

CREATE TABLE device_credentials (
  device_credential_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  session_id uuid,

  device_platform text NOT NULL,
  device_fingerprint_hash text NOT NULL,
  credential_hash text NOT NULL UNIQUE,

  issued_at timestamptz NOT NULL DEFAULT NOW(),
  last_used_at timestamptz,
  rotate_after timestamptz NOT NULL,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,

  created_at timestamptz NOT NULL DEFAULT NOW(),
  updated_at timestamptz NOT NULL DEFAULT NOW(),

  CONSTRAINT device_credentials_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,

  CONSTRAINT device_credentials_session_id_fkey
    FOREIGN KEY (session_id)
    REFERENCES sessions(session_id)
    ON DELETE SET NULL,

  CONSTRAINT device_credentials_platform_check
    CHECK (device_platform IN ('qt-windows', 'qt-macos', 'qt-linux', 'android-webview')),

  CONSTRAINT device_credentials_expires_after_issued_check
    CHECK (expires_at > issued_at),

  CONSTRAINT device_credentials_rotate_before_expires_check
    CHECK (rotate_after < expires_at)
);

CREATE INDEX idx_device_credentials_user_active
  ON device_credentials (user_id, expires_at)
  WHERE revoked_at IS NULL;

CREATE INDEX idx_device_credentials_fingerprint_hash
  ON device_credentials (device_fingerprint_hash);

CREATE TRIGGER trg_device_credentials_set_updated_at
BEFORE UPDATE ON device_credentials
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_now();

CREATE TABLE auth_identity_versions (
  auth_identity_version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_identity_id uuid NOT NULL,
  version_no integer NOT NULL,
  operation_type text NOT NULL,
  snapshot jsonb NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT NOW(),
  changed_by_user_id uuid,
  request_id text,

  CONSTRAINT auth_identity_versions_operation_type_check
    CHECK (operation_type IN ('insert', 'update', 'delete')),

  CONSTRAINT auth_identity_versions_changed_by_user_id_fkey
    FOREIGN KEY (changed_by_user_id)
    REFERENCES users(user_id)
    ON DELETE SET NULL,

  CONSTRAINT auth_identity_versions_entity_version_unique
    UNIQUE (auth_identity_id, version_no)
);

CREATE INDEX idx_auth_identity_versions_auth_identity_id
  ON auth_identity_versions (auth_identity_id);
CREATE INDEX idx_auth_identity_versions_changed_at
  ON auth_identity_versions (changed_at DESC);

CREATE TABLE device_credential_versions (
  device_credential_version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_credential_id uuid NOT NULL,
  version_no integer NOT NULL,
  operation_type text NOT NULL,
  snapshot jsonb NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT NOW(),
  changed_by_user_id uuid,
  request_id text,

  CONSTRAINT device_credential_versions_operation_type_check
    CHECK (operation_type IN ('insert', 'update', 'delete')),

  CONSTRAINT device_credential_versions_changed_by_user_id_fkey
    FOREIGN KEY (changed_by_user_id)
    REFERENCES users(user_id)
    ON DELETE SET NULL,

  CONSTRAINT device_credential_versions_entity_version_unique
    UNIQUE (device_credential_id, version_no)
);

CREATE INDEX idx_device_credential_versions_device_credential_id
  ON device_credential_versions (device_credential_id);
CREATE INDEX idx_device_credential_versions_changed_at
  ON device_credential_versions (changed_at DESC);

CREATE OR REPLACE FUNCTION auth_identity_versions_on_write()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM auth_identity_versions
   WHERE auth_identity_id = NEW.auth_identity_id;

  INSERT INTO auth_identity_versions (
    auth_identity_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    NEW.auth_identity_id,
    v_version_no,
    lower(TG_OP),
    to_jsonb(NEW),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION auth_identity_versions_on_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM auth_identity_versions
   WHERE auth_identity_id = OLD.auth_identity_id;

  INSERT INTO auth_identity_versions (
    auth_identity_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    OLD.auth_identity_id,
    v_version_no,
    'delete',
    to_jsonb(OLD),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION device_credential_versions_on_write()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM device_credential_versions
   WHERE device_credential_id = NEW.device_credential_id;

  INSERT INTO device_credential_versions (
    device_credential_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    NEW.device_credential_id,
    v_version_no,
    lower(TG_OP),
    to_jsonb(NEW),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION device_credential_versions_on_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM device_credential_versions
   WHERE device_credential_id = OLD.device_credential_id;

  INSERT INTO device_credential_versions (
    device_credential_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    OLD.device_credential_id,
    v_version_no,
    'delete',
    to_jsonb(OLD),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN OLD;
END;
$$;

CREATE TRIGGER trg_auth_identity_versions_write
AFTER INSERT OR UPDATE ON auth_identities
FOR EACH ROW
EXECUTE FUNCTION auth_identity_versions_on_write();

CREATE TRIGGER trg_auth_identity_versions_delete
BEFORE DELETE ON auth_identities
FOR EACH ROW
EXECUTE FUNCTION auth_identity_versions_on_delete();

CREATE TRIGGER trg_device_credential_versions_write
AFTER INSERT OR UPDATE ON device_credentials
FOR EACH ROW
EXECUTE FUNCTION device_credential_versions_on_write();

CREATE TRIGGER trg_device_credential_versions_delete
BEFORE DELETE ON device_credentials
FOR EACH ROW
EXECUTE FUNCTION device_credential_versions_on_delete();
