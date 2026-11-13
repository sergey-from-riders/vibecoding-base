#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"
if ! command -v rg >/dev/null 2>&1; then
  echo "NOT_RUN template_hygiene reason=missing_ripgrep" >&2
  exit 2
fi

secret_shape_pattern='BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|xox[baprs]-|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{80,}|sk-[A-Za-z0-9]{20,}|client_secret[[:space:]]*[:=][[:space:]]*["'\''][^"'\''[:space:]]+|api[_-]?key[[:space:]]*[:=][[:space:]]*["'\''][^"'\''[:space:]]+'
project_residue_pattern='185\.225|46\.254|hellor8g|bitrix@|root@|S3curePassword|AdminPassword|N3wPassword'

violations=0

scan() {
  local pattern="$1" label="$2" status
  # Print filenames only; CI output must not reproduce a detected secret.
  if rg -l --glob '!node_modules/**' --glob '!.git/**' --glob '!dist/**' --glob '!**/check_template_hygiene.sh' --glob '!**/scripts/check.sh' --glob '!tools/vibe.mjs' "$pattern" "$TARGET_DIR"; then
    echo "VIOLATION $label"
    violations=$((violations + 1))
  else
    status=$?
    if [ "$status" -ne 1 ]; then
      echo "ERROR template_hygiene reason=scan_failed" >&2
      exit 2
    fi
  fi
}
scan "$secret_shape_pattern" template_secret_shape
scan "$project_residue_pattern" template_project_residue

if [ "$violations" -gt 0 ]; then
  echo "Template hygiene check failed: violations=$violations"
  exit 1
fi

echo "Template hygiene check passed"
