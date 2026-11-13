#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${1:-.}"
violations=0
if ! command -v rg >/dev/null 2>&1; then
  echo "NOT_RUN openapi_structure reason=missing_ripgrep" >&2
  exit 2
fi

# This checks the starter layout, not schema validity or runtime conformance.
# Propagate scanner failures instead of treating them as missing patterns.
contains() {
  local status
  if rg -q "$@"; then return 0; else status=$?; fi
  if [ "$status" -ne 1 ]; then
    echo "ERROR openapi_structure reason=scan_failed" >&2
    exit 2
  fi
  return 1
}

for required in \
  contracts/openapi/openapi.root.yaml \
  contracts/openapi/endpoints.inventory.tsv \
  contracts/openapi/modules \
  contracts/openapi/components; do
  if [ ! -e "$PROJECT_DIR/$required" ]; then
    echo "VIOLATION missing_openapi_path path=$required"
    violations=$((violations + 1))
  fi
done

ROOT="$PROJECT_DIR/contracts/openapi/openapi.root.yaml"
INVENTORY="$PROJECT_DIR/contracts/openapi/endpoints.inventory.tsv"

if [ -f "$ROOT" ]; then
  if ! contains "^openapi:[[:space:]]*(3\.(1|2)\.[0-9]+|\"3\.(1|2)\.[0-9]+\"|'3\.(1|2)\.[0-9]+')[[:space:]]*(#.*)?$" "$ROOT"; then
    echo "VIOLATION unsupported_openapi_version expected=3.1.x_or_3.2.x"
    violations=$((violations + 1))
  fi

  for endpoint in \
    "/api/v1/docs/openapi.json" \
    "/api/v1/docs/openapi.yaml" \
    "/api/v1/docs/endpoints" \
    "/api/v1/docs/testing/postman"; do
    if ! contains "$endpoint" "$ROOT"; then
      echo "VIOLATION missing_docs_endpoint endpoint=$endpoint"
      violations=$((violations + 1))
    fi
  done
fi

if [ -f "$INVENTORY" ]; then
  header=$(head -n 1 "$INVENTORY")
  for column in method path operation_id; do
    if ! contains "(^|[[:space:]])$column([[:space:]]|$)" <<< "${header#\#}"; then
      echo "VIOLATION invalid_inventory_header missing=$column"
      violations=$((violations + 1))
    fi
  done

  if [ "$(awk 'NR > 1 && NF { count++ } END { print count + 0 }' "$INVENTORY")" -lt 1 ]; then
    echo "VIOLATION empty_endpoint_inventory"
    violations=$((violations + 1))
  fi
fi

if [ -d "$PROJECT_DIR/contracts/openapi/modules" ]; then
  for required_pattern in "operationId:" "summary:" "responses:"; do
    if ! contains "$required_pattern" "$PROJECT_DIR/contracts/openapi/modules"; then
      echo "VIOLATION missing_openapi_module_pattern pattern=$required_pattern"
      violations=$((violations + 1))
    fi
  done
fi

if [ "$violations" -gt 0 ]; then
  echo "OpenAPI check failed: violations=$violations"
  exit 1
fi

echo "OpenAPI starter structure check passed; schema and runtime conformance not checked"
