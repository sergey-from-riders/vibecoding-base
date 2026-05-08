#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

required_files=(
  "README.md"
  "FRAMEWORK.md"
  "AGENTS.md"
  "package.json"
  "pnpm-workspace.yaml"
  "biome.jsonc"
  "nx.json"
  "docs/README.md"
  "docs/27-STARTER-READINESS.md"
  "packages/contracts/openapi/openapi.root.yaml"
  "packages/contracts/openapi/endpoints.inventory.tsv"
  "packages/tokens/tokens.json"
)

violations=0

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "VIOLATION missing_starter_file file=$file"
    violations=$((violations + 1))
  fi
done

if [ "$violations" -gt 0 ]; then
  echo "Starter file check failed: violations=$violations"
  exit 1
fi

tools/scripts/check_db_contract.sh db/migrations
tools/scripts/check_go_limits.sh apps/api
tools/scripts/check_web_limits.sh apps/web
tools/scripts/check_cpp_limits.sh apps/desktop/qt
tools/scripts/check_template_clean.sh

echo "Starter integrity check passed"
