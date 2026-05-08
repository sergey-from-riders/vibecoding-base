#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

COMMON_GLOBS=(
  --glob '!node_modules/**'
  --glob '!tools/scripts/check_template_clean.sh'
  --glob '!packages/contracts/openapi/redocly.yaml'
)

project_residue_pattern='Riders|riders|Pulse|riderspulse|185\.225|46\.254|sergey/event|hellor8g|bitrix@|root@|giglan|X-RP|--rp|(^|[^A-Z])RP_|APP_APP|NEXT_PUBLIC_APP_APP|change_me|S3curePassword|AdminPassword|N3wPassword|example\.com'
secret_shape_pattern='BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|xox[baprs]-|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{80,}|sk-[A-Za-z0-9]{20,}|client_secret[[:space:]]*[:=][[:space:]]*["'\''][^"'\''[:space:]]+|api[_-]?key[[:space:]]*[:=][[:space:]]*["'\''][^"'\''[:space:]]+'

violations=0

if rg -n "${COMMON_GLOBS[@]}" "$project_residue_pattern" .; then
  echo "VIOLATION template_project_residue"
  violations=$((violations + 1))
fi

if rg -n "${COMMON_GLOBS[@]}" "$secret_shape_pattern" .; then
  echo "VIOLATION template_secret_shape"
  violations=$((violations + 1))
fi

if [ "$violations" -gt 0 ]; then
  echo "Template clean check failed: violations=$violations"
  exit 1
fi

echo "Template clean check passed"
