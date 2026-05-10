#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${1:-.}"
violations=0

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
  if ! rg -q '^openapi:[[:space:]]*3\.2\.0$' "$ROOT"; then
    echo "VIOLATION openapi_version_not_3_2_0"
    violations=$((violations + 1))
  fi

  for endpoint in \
    "/api/v1/docs/openapi.json" \
    "/api/v1/docs/openapi.yaml" \
    "/api/v1/docs/endpoints" \
    "/api/v1/docs/testing/postman"; do
    if ! rg -q "$endpoint" "$ROOT"; then
      echo "VIOLATION missing_docs_endpoint endpoint=$endpoint"
      violations=$((violations + 1))
    fi
  done
fi

if [ -f "$INVENTORY" ]; then
  if ! head -n 1 "$INVENTORY" | rg -q 'method' || ! head -n 1 "$INVENTORY" | rg -q 'path' || ! head -n 1 "$INVENTORY" | rg -q 'operation_id'; then
    echo "VIOLATION invalid_inventory_header"
    violations=$((violations + 1))
  fi

  if [ "$(awk 'NR > 1 && NF { count++ } END { print count + 0 }' "$INVENTORY")" -lt 1 ]; then
    echo "VIOLATION empty_endpoint_inventory"
    violations=$((violations + 1))
  fi
fi

if [ -d "$PROJECT_DIR/contracts/openapi/modules" ]; then
  for required_pattern in "operationId:" "summary:" "responses:" "X-Request-Id" "X-App-Result"; do
    if ! rg -q "$required_pattern" "$PROJECT_DIR/contracts/openapi/modules"; then
      echo "VIOLATION missing_openapi_module_pattern pattern=$required_pattern"
      violations=$((violations + 1))
    fi
  done
fi

if [ "$violations" -gt 0 ]; then
  echo "OpenAPI check failed: violations=$violations"
  exit 1
fi

echo "OpenAPI structure check passed"
