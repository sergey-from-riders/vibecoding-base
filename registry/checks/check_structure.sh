#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${1:-.}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

node "$REPO_DIR/tools/vibe.mjs" verify "$PROJECT_DIR" --project-only
