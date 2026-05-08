#!/usr/bin/env bash
set -euo pipefail

ROOT="packages/contracts/openapi/openapi.root.yaml"
CONFIG="packages/contracts/openapi/redocly.yaml"
INVENTORY="packages/contracts/openapi/endpoints.inventory.tsv"
TMP_JSON="${TMPDIR:-/tmp}/ai-app-openapi.bundle.json"

if [ ! -f "$INVENTORY" ]; then
  echo "Inventory file not found: $INVENTORY" >&2
  exit 2
fi

run_redocly() {
  if [ -x "node_modules/.bin/redocly" ]; then
    node_modules/.bin/redocly "$@"
    return
  fi

  npx -y @redocly/cli@^2.30.4 "$@"
}

run_redocly bundle "$ROOT" --config "$CONFIG" --ext json -o "$TMP_JSON" >/dev/null

violations=0

while IFS=$'\t' read -r method path module; do
  [ -z "${method:-}" ] && continue
  [[ "$method" =~ ^# ]] && continue

  method_lc="$(echo "$method" | tr 'A-Z' 'a-z')"

  if ! jq -e --arg p "$path" --arg m "$method_lc" '.paths[$p][$m] != null' "$TMP_JSON" >/dev/null; then
    echo "VIOLATION missing_endpoint_contract module=$module method=$method path=$path"
    violations=$((violations + 1))
    continue
  fi

  if ! jq -e --arg p "$path" --arg m "$method_lc" '
    def has_media_examples:
      ((.example? != null) or ((.examples? // {}) | length > 0));
    .paths[$p][$m] as $op |
    if ($op.requestBody? != null) then
      (($op.requestBody.content // {}) | to_entries | map(.value | has_media_examples) | any)
    else
      true
    end
  ' "$TMP_JSON" >/dev/null; then
    echo "VIOLATION missing_request_examples module=$module method=$method path=$path"
    violations=$((violations + 1))
  fi

  if ! jq -e --arg p "$path" --arg m "$method_lc" '
    def has_media_examples:
      ((.example? != null) or ((.examples? // {}) | length > 0));
    .paths[$p][$m] as $op |
    (($op.responses // {}) | to_entries | all(
      if ((.value.content // {}) | length) == 0 then
        true
      else
        ((.value.content // {}) | to_entries | map(.value | has_media_examples) | any)
      end
    ))
  ' "$TMP_JSON" >/dev/null; then
    echo "VIOLATION missing_response_examples module=$module method=$method path=$path"
    violations=$((violations + 1))
  fi

  if ! jq -e --arg p "$path" --arg m "$method_lc" '
    .paths[$p][$m] as $op |
    (($op["x-codeSamples"] // []) | length) > 0
  ' "$TMP_JSON" >/dev/null; then
    echo "VIOLATION missing_code_samples module=$module method=$method path=$path"
    violations=$((violations + 1))
  fi

  if ! jq -e --arg p "$path" --arg m "$method_lc" '
    .paths[$p][$m] as $op |
    (($op.responses // {}) | to_entries | all(
      ((.value.headers // {}) | has("X-Request-Id"))
      and ((.value.headers // {}) | has("X-App-Result"))
      and ((.value.headers // {}) | has("Content-Language"))
    ))
  ' "$TMP_JSON" >/dev/null; then
    echo "VIOLATION missing_mandatory_response_headers module=$module method=$method path=$path"
    violations=$((violations + 1))
  fi
done <"$INVENTORY"

if [ "$violations" -gt 0 ]; then
  echo "OpenAPI coverage check failed: violations=$violations"
  exit 1
fi

echo "OpenAPI coverage check passed"
