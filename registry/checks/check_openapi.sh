#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${1:-.}"

for required in \
  contracts/openapi/openapi.root.yaml \
  contracts/openapi/endpoints.inventory.tsv \
  contracts/openapi/modules \
  contracts/openapi/components; do
  if [ ! -e "$PROJECT_DIR/$required" ]; then
    echo "VIOLATION missing_openapi_path path=$required"
    exit 1
  fi
done

echo "OpenAPI structure check passed"
