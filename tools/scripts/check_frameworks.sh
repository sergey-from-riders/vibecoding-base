#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

violations=0

for framework in frameworks/*; do
  [ -d "$framework" ] || continue
  echo "==> checking $framework"

  if [ ! -x "$framework/tools/scripts/check_starter_integrity.sh" ]; then
    echo "VIOLATION missing_integrity_check framework=$framework"
    violations=$((violations + 1))
    continue
  fi

  if ! (cd "$framework" && tools/scripts/check_starter_integrity.sh); then
    echo "VIOLATION framework_check_failed framework=$framework"
    violations=$((violations + 1))
  fi
done

if [ "$violations" -gt 0 ]; then
  echo "Framework catalog check failed: violations=$violations"
  exit 1
fi

echo "Framework catalog check passed"
