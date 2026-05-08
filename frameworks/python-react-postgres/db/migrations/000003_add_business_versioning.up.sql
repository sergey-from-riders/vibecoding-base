-- Python React Postgres Framework 2026: mandatory business-entity versioning
-- Applies to business data tables only; logs (e.g., auth_events) are excluded.

CREATE OR REPLACE FUNCTION rp_current_actor()
RETURNS uuid
LANGUAGE plpgsql
AS $$
DECLARE
  v text;
BEGIN
  v := current_setting('app.current_user_id', true);
  IF v IS NULL OR v = '' THEN
    RETURN NULL;
  END IF;
  RETURN v::uuid;
EXCEPTION
  WHEN others THEN
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION rp_current_request_id()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  v text;
BEGIN
  v := current_setting('app.current_request_id', true);
  IF v IS NULL OR v = '' THEN
    RETURN NULL;
  END IF;
  RETURN v;
EXCEPTION
  WHEN others THEN
    RETURN NULL;
END;
$$;

CREATE TABLE user_versions (
  user_version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  version_no integer NOT NULL,
  operation_type text NOT NULL,
  snapshot jsonb NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT NOW(),
  changed_by_user_id uuid,
  request_id text,

  CONSTRAINT user_versions_operation_type_check
    CHECK (operation_type IN ('insert', 'update', 'delete')),

  CONSTRAINT user_versions_changed_by_user_id_fkey
    FOREIGN KEY (changed_by_user_id)
    REFERENCES users(user_id)
    ON DELETE SET NULL,

  CONSTRAINT user_versions_user_version_unique
    UNIQUE (user_id, version_no)
);

CREATE INDEX idx_user_versions_user_id ON user_versions (user_id);
CREATE INDEX idx_user_versions_changed_at ON user_versions (changed_at DESC);

CREATE TABLE company_versions (
  company_version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL,
  version_no integer NOT NULL,
  operation_type text NOT NULL,
  snapshot jsonb NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT NOW(),
  changed_by_user_id uuid,
  request_id text,

  CONSTRAINT company_versions_operation_type_check
    CHECK (operation_type IN ('insert', 'update', 'delete')),

  CONSTRAINT company_versions_changed_by_user_id_fkey
    FOREIGN KEY (changed_by_user_id)
    REFERENCES users(user_id)
    ON DELETE SET NULL,

  CONSTRAINT company_versions_company_version_unique
    UNIQUE (company_id, version_no)
);

CREATE INDEX idx_company_versions_company_id ON company_versions (company_id);
CREATE INDEX idx_company_versions_changed_at ON company_versions (changed_at DESC);

CREATE TABLE company_membership_versions (
  company_membership_version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL,
  user_id uuid NOT NULL,
  version_no integer NOT NULL,
  operation_type text NOT NULL,
  snapshot jsonb NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT NOW(),
  changed_by_user_id uuid,
  request_id text,

  CONSTRAINT company_membership_versions_operation_type_check
    CHECK (operation_type IN ('insert', 'update', 'delete')),

  CONSTRAINT company_membership_versions_changed_by_user_id_fkey
    FOREIGN KEY (changed_by_user_id)
    REFERENCES users(user_id)
    ON DELETE SET NULL,

  CONSTRAINT company_membership_versions_entity_version_unique
    UNIQUE (company_id, user_id, version_no)
);

CREATE INDEX idx_company_membership_versions_entity
  ON company_membership_versions (company_id, user_id);
CREATE INDEX idx_company_membership_versions_changed_at
  ON company_membership_versions (changed_at DESC);

CREATE OR REPLACE FUNCTION user_versions_on_write()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM user_versions
   WHERE user_id = NEW.user_id;

  INSERT INTO user_versions (
    user_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    NEW.user_id,
    v_version_no,
    lower(TG_OP),
    to_jsonb(NEW),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION user_versions_on_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM user_versions
   WHERE user_id = OLD.user_id;

  INSERT INTO user_versions (
    user_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    OLD.user_id,
    v_version_no,
    'delete',
    to_jsonb(OLD),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION company_versions_on_write()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM company_versions
   WHERE company_id = NEW.company_id;

  INSERT INTO company_versions (
    company_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    NEW.company_id,
    v_version_no,
    lower(TG_OP),
    to_jsonb(NEW),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION company_versions_on_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM company_versions
   WHERE company_id = OLD.company_id;

  INSERT INTO company_versions (
    company_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    OLD.company_id,
    v_version_no,
    'delete',
    to_jsonb(OLD),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION company_membership_versions_on_write()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM company_membership_versions
   WHERE company_id = NEW.company_id
     AND user_id = NEW.user_id;

  INSERT INTO company_membership_versions (
    company_id,
    user_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    NEW.company_id,
    NEW.user_id,
    v_version_no,
    lower(TG_OP),
    to_jsonb(NEW),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION company_membership_versions_on_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_version_no integer;
BEGIN
  SELECT COALESCE(MAX(version_no), 0) + 1
    INTO v_version_no
    FROM company_membership_versions
   WHERE company_id = OLD.company_id
     AND user_id = OLD.user_id;

  INSERT INTO company_membership_versions (
    company_id,
    user_id,
    version_no,
    operation_type,
    snapshot,
    changed_by_user_id,
    request_id
  ) VALUES (
    OLD.company_id,
    OLD.user_id,
    v_version_no,
    'delete',
    to_jsonb(OLD),
    rp_current_actor(),
    rp_current_request_id()
  );

  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_user_versions_write ON users;
CREATE TRIGGER trg_user_versions_write
AFTER INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION user_versions_on_write();

DROP TRIGGER IF EXISTS trg_user_versions_delete ON users;
CREATE TRIGGER trg_user_versions_delete
BEFORE DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION user_versions_on_delete();

DROP TRIGGER IF EXISTS trg_company_versions_write ON companies;
CREATE TRIGGER trg_company_versions_write
AFTER INSERT OR UPDATE ON companies
FOR EACH ROW
EXECUTE FUNCTION company_versions_on_write();

DROP TRIGGER IF EXISTS trg_company_versions_delete ON companies;
CREATE TRIGGER trg_company_versions_delete
BEFORE DELETE ON companies
FOR EACH ROW
EXECUTE FUNCTION company_versions_on_delete();

DROP TRIGGER IF EXISTS trg_company_membership_versions_write ON company_memberships;
CREATE TRIGGER trg_company_membership_versions_write
AFTER INSERT OR UPDATE ON company_memberships
FOR EACH ROW
EXECUTE FUNCTION company_membership_versions_on_write();

DROP TRIGGER IF EXISTS trg_company_membership_versions_delete ON company_memberships;
CREATE TRIGGER trg_company_membership_versions_delete
BEFORE DELETE ON company_memberships
FOR EACH ROW
EXECUTE FUNCTION company_membership_versions_on_delete();
