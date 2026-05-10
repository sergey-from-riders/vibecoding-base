#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

violations=0

required=(
  "AGENTS.md"
  ".vibe/profile.yaml"
  ".vibe/enabled.yaml"
  ".vibe/registry.lock"
  "standards/active/AGENTS.md"
)

for item in "${required[@]}"; do
  if [ ! -e "$item" ]; then
    echo "VIOLATION missing_required_path path=$item"
    violations=$((violations + 1))
  fi
done

check_disabled_path() {
  local feature="$1"
  shift
  if awk -v feature="$feature" '
    $0 == "disabled:" { in_disabled = 1; next }
    in_disabled && $0 !~ /^ / { in_disabled = 0 }
    in_disabled && $0 == "  " feature ": true" { found = 1 }
    END { exit(found ? 0 : 1) }
  ' .vibe/profile.yaml 2>/dev/null; then
    for item in "$@"; do
      if [ -e "$item" ]; then
        echo "VIOLATION disabled_feature_path_exists feature=$feature path=$item"
        violations=$((violations + 1))
      fi
    done
  fi
}

check_disabled_path mobile apps/mobile mobile
check_disabled_path desktop apps/desktop desktop
check_disabled_path worker apps/worker worker
check_disabled_path admin apps/admin admin
check_disabled_path payments apps/payments packages/payments payments
check_disabled_path queue apps/queue queue
check_disabled_path ai apps/ai ai

if [ -d registry ] || [ -d frameworks ]; then
  echo "VIOLATION generated_project_contains_registry_or_legacy_frameworks"
  violations=$((violations + 1))
fi

if [ -d contracts/openapi ]; then
  for item in contracts/openapi/openapi.root.yaml contracts/openapi/endpoints.inventory.tsv contracts/openapi/modules contracts/openapi/components; do
    if [ ! -e "$item" ]; then
      echo "VIOLATION missing_openapi_path path=$item"
      violations=$((violations + 1))
    fi
  done
fi

if command -v rg >/dev/null 2>&1; then
  secret_shape_pattern='BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|xox[baprs]-|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{80,}|sk-[A-Za-z0-9]{20,}'
  if rg -n --glob '!node_modules/**' --glob '!.git/**' --glob '!dist/**' --glob '!scripts/check.sh' "$secret_shape_pattern" .; then
    echo "VIOLATION generated_project_secret_shape"
    violations=$((violations + 1))
  fi
fi

if [ "$violations" -gt 0 ]; then
  echo "Generated project check failed: violations=$violations"
  exit 1
fi

echo "Generated project check passed"
