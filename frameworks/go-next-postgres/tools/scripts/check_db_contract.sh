#!/usr/bin/env bash
set -euo pipefail

MIGRATIONS_DIR="${1:-db/migrations}"

if [ ! -d "$MIGRATIONS_DIR" ]; then
  echo "Directory not found: $MIGRATIONS_DIR" >&2
  exit 2
fi

if ! command -v rg >/dev/null 2>&1; then
  echo "rg is required" >&2
  exit 2
fi

violations=0

require_file() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "VIOLATION missing_migration_pair file=$file"
    violations=$((violations + 1))
  fi
}

require_pattern() {
  local name="$1"
  local pattern="$2"
  if ! rg -n "$pattern" "$MIGRATIONS_DIR"/*.up.sql >/dev/null; then
    echo "VIOLATION missing_db_contract pattern=$name"
    violations=$((violations + 1))
  fi
}

while IFS= read -r up_file; do
  require_file "${up_file%.up.sql}.down.sql"
done < <(find "$MIGRATIONS_DIR" -maxdepth 1 -type f -name '*.up.sql' | sort)

require_pattern "users table" "CREATE TABLE users"
require_pattern "companies table" "CREATE TABLE companies"
require_pattern "company_memberships table" "CREATE TABLE company_memberships"
require_pattern "auth_identities table" "CREATE TABLE auth_identities"
require_pattern "sessions table" "CREATE TABLE sessions"
require_pattern "device_credentials table" "CREATE TABLE device_credentials"
require_pattern "auth_events table" "CREATE TABLE auth_events"

require_pattern "session_token_hash" "session_token_hash text .*UNIQUE|RENAME COLUMN token_hash TO session_token_hash"
require_pattern "refresh_token_hash" "refresh_token_hash text"
require_pattern "session client_type" "client_type text"
require_pattern "device credential hash" "credential_hash text .*UNIQUE"

require_pattern "user_versions table" "CREATE TABLE user_versions"
require_pattern "company_versions table" "CREATE TABLE company_versions"
require_pattern "company_membership_versions table" "CREATE TABLE company_membership_versions"
require_pattern "auth_identity_versions table" "CREATE TABLE auth_identity_versions"
require_pattern "device_credential_versions table" "CREATE TABLE device_credential_versions"

if rg -n "^[[:space:]]*id[[:space:]]+(uuid|serial|bigserial|integer|int)" "$MIGRATIONS_DIR"/*.up.sql >/dev/null; then
  echo "VIOLATION generic_id_column_found"
  rg -n "^[[:space:]]*id[[:space:]]+(uuid|serial|bigserial|integer|int)" "$MIGRATIONS_DIR"/*.up.sql
  violations=$((violations + 1))
fi

if rg -n "\\b(bigserial|serial)\\b" "$MIGRATIONS_DIR"/*.up.sql >/dev/null; then
  echo "VIOLATION serial_domain_id_found"
  rg -n "\\b(bigserial|serial)\\b" "$MIGRATIONS_DIR"/*.up.sql
  violations=$((violations + 1))
fi

if [ "$violations" -gt 0 ]; then
  echo "DB contract check failed: violations=$violations"
  exit 1
fi

echo "DB contract check passed"
