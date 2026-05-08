#!/usr/bin/env bash
set -euo pipefail

ROOT="packages/contracts/openapi/openapi.root.yaml"
CONFIG="packages/contracts/openapi/redocly.yaml"
DIST="packages/contracts/openapi/dist"

mkdir -p "$DIST"

run_redocly() {
  if [ -x "node_modules/.bin/redocly" ]; then
    node_modules/.bin/redocly "$@"
    return
  fi

  npx -y @redocly/cli@^2.30.4 "$@"
}

run_openapi_to_postman() {
  if [ -x "node_modules/.bin/openapi2postmanv2" ]; then
    node_modules/.bin/openapi2postmanv2 "$@"
    return
  fi

  npx -y openapi-to-postmanv2@^6.0.1 "$@"
}

run_redocly lint "$ROOT" --config "$CONFIG"
run_redocly bundle "$ROOT" --config "$CONFIG" -o "$DIST/openapi.yaml"
run_redocly bundle "$ROOT" --config "$CONFIG" --ext json -o "$DIST/openapi.json"
run_redocly build-docs "$ROOT" --config "$CONFIG" -o "$DIST/openapi.html" >/dev/null 2>&1 || {
  echo "WARN: build-docs skipped for current OpenAPI version/tooling combination."
}

# Optional testing collection artifact (best effort).
run_openapi_to_postman -s "$DIST/openapi.json" -o "$DIST/postman.collection.json" -p >/dev/null 2>&1 || true

# Endpoint catalog for /api/v1/docs/endpoints.
jq '
  {
    generated_at: (now | todateiso8601),
    version: .info.version,
    endpoints: [
      .paths
      | to_entries[]
      | . as $path_entry
      | $path_entry.value
      | to_entries[]
      | {
          method: (.key | ascii_upcase),
          path: $path_entry.key,
          summary: (.value.summary // ""),
          tag: ((.value.tags // ["untagged"])[0]),
          operation_id: (.value.operationId // ""),
          curl_examples: (
            (.value["x-codeSamples"] // [])
            | map(select(.lang == "curl") | .source)
          ),
          test_hints: [
            "happy_path",
            "invalid_input",
            "unauthorized_or_forbidden_if_protected"
          ]
        }
    ]
  }
' "$DIST/openapi.json" >"$DIST/endpoints.catalog.json"

echo "OpenAPI bundle built at $DIST"
