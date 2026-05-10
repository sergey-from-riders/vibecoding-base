#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"

secret_shape_pattern='BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|xox[baprs]-|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{80,}|sk-[A-Za-z0-9]{20,}|client_secret[[:space:]]*[:=][[:space:]]*["'\''][^"'\''[:space:]]+|api[_-]?key[[:space:]]*[:=][[:space:]]*["'\''][^"'\''[:space:]]+'
project_residue_pattern='185\.225|46\.254|hellor8g|bitrix@|root@|S3curePassword|AdminPassword|N3wPassword'

violations=0

if command -v rg >/dev/null 2>&1; then
  if rg -n --glob '!node_modules/**' --glob '!.git/**' --glob '!dist/**' --glob '!**/check_template_hygiene.sh' --glob '!**/scripts/check.sh' --glob '!tools/vibe.mjs' "$secret_shape_pattern" "$TARGET_DIR"; then
    echo "VIOLATION template_secret_shape"
    violations=$((violations + 1))
  fi
  if rg -n --glob '!node_modules/**' --glob '!.git/**' --glob '!dist/**' --glob '!**/check_template_hygiene.sh' --glob '!**/scripts/check.sh' --glob '!tools/vibe.mjs' "$project_residue_pattern" "$TARGET_DIR"; then
    echo "VIOLATION template_project_residue"
    violations=$((violations + 1))
  fi
else
  echo "rg not found; skipped template hygiene scan"
fi

if [ "$violations" -gt 0 ]; then
  echo "Template hygiene check failed: violations=$violations"
  exit 1
fi

echo "Template hygiene check passed"
