-- Go Next Postgres Framework 2026: auth + company context core schema

CREATE OR REPLACE FUNCTION set_updated_at_now()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE users (
  user_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  email citext,
  password_hash text,
  first_name text,

  is_activated boolean NOT NULL DEFAULT false,
  activation_token_hash text,
  activation_token_expires_at timestamptz,

  password_reset_token_hash text,
  password_reset_token_expires_at timestamptz,

  email_change_token_hash text,
  email_change_token_expires_at timestamptz,
  pending_email citext,

  current_company_id uuid,

  created_at timestamptz NOT NULL DEFAULT NOW(),
  updated_at timestamptz NOT NULL DEFAULT NOW(),
  deleted_at timestamptz,

  CONSTRAINT users_email_or_password_material_check
    CHECK (email IS NULL OR password_hash IS NOT NULL OR activation_token_hash IS NOT NULL)
);

CREATE UNIQUE INDEX idx_users_email_unique_active
  ON users (email)
  WHERE deleted_at IS NULL AND email IS NOT NULL;

CREATE INDEX idx_users_current_company_id ON users (current_company_id);
CREATE INDEX idx_users_deleted_at ON users (deleted_at);

CREATE TRIGGER trg_users_set_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_now();

CREATE TABLE companies (
  company_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,

  slug text,
  name text NOT NULL,
  status text NOT NULL DEFAULT 'active',

  created_at timestamptz NOT NULL DEFAULT NOW(),
  updated_at timestamptz NOT NULL DEFAULT NOW(),

  CONSTRAINT companies_owner_user_id_fkey
    FOREIGN KEY (owner_user_id)
    REFERENCES users(user_id)
    ON DELETE RESTRICT,

  CONSTRAINT companies_status_check
    CHECK (status IN ('active', 'suspended', 'archived'))
);

CREATE UNIQUE INDEX idx_companies_slug_unique
  ON companies (slug)
  WHERE slug IS NOT NULL;

CREATE INDEX idx_companies_owner_user_id ON companies (owner_user_id);

CREATE TRIGGER trg_companies_set_updated_at
BEFORE UPDATE ON companies
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_now();

ALTER TABLE users
  ADD CONSTRAINT users_current_company_id_fkey
  FOREIGN KEY (current_company_id)
  REFERENCES companies(company_id)
  ON DELETE SET NULL;

CREATE TABLE company_memberships (
  company_id uuid NOT NULL,
  user_id uuid NOT NULL,

  role text NOT NULL DEFAULT 'member',
  permissions jsonb NOT NULL DEFAULT '{}'::jsonb,

  invited_by uuid,
  invited_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT NOW(),

  PRIMARY KEY (company_id, user_id),

  CONSTRAINT company_memberships_role_check
    CHECK (role IN ('owner', 'admin', 'member')),

  CONSTRAINT company_memberships_company_id_fkey
    FOREIGN KEY (company_id)
    REFERENCES companies(company_id)
    ON DELETE CASCADE,

  CONSTRAINT company_memberships_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,

  CONSTRAINT company_memberships_invited_by_fkey
    FOREIGN KEY (invited_by)
    REFERENCES users(user_id)
    ON DELETE SET NULL
);

CREATE INDEX idx_company_memberships_user_id ON company_memberships (user_id);
CREATE INDEX idx_company_memberships_company_id ON company_memberships (company_id);

CREATE TABLE sessions (
  session_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,

  token_hash text NOT NULL UNIQUE,
  device_label text,

  user_agent text,
  ip_address inet,

  created_at timestamptz NOT NULL DEFAULT NOW(),
  last_seen_at timestamptz,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,

  CONSTRAINT sessions_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,

  CONSTRAINT sessions_expires_after_created_check
    CHECK (expires_at > created_at)
);

CREATE INDEX idx_sessions_user_active
  ON sessions (user_id, expires_at)
  WHERE revoked_at IS NULL;

CREATE INDEX idx_sessions_expires_at ON sessions (expires_at);

CREATE TABLE auth_events (
  auth_event_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid,
  event_type text NOT NULL,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT NOW(),

  CONSTRAINT auth_events_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE SET NULL
);

CREATE INDEX idx_auth_events_user_created_at
  ON auth_events (user_id, created_at DESC);
