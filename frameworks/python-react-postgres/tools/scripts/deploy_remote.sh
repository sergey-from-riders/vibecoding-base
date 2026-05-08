#!/usr/bin/env bash
set -euo pipefail

# Deploy backend+frontend to remote server by pulling prebuilt container images.
# Source code is not built on the server.
# Usage:
#   DEPLOY_HOST=user@server DEPLOY_PATH=/opt/ai-app ./tools/scripts/deploy_remote.sh

: "${DEPLOY_HOST:?DEPLOY_HOST is required (e.g. user@server)}"
: "${DEPLOY_PATH:?DEPLOY_PATH is required (e.g. /opt/ai-app)}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "[deploy] Syncing deployment manifests to ${DEPLOY_HOST}:${DEPLOY_PATH}"
rsync -az --delete \
  "${ROOT_DIR}/infra/docker/" "${DEPLOY_HOST}:${DEPLOY_PATH}/infra/docker/"
rsync -az --delete \
  "${ROOT_DIR}/infra/nginx/" "${DEPLOY_HOST}:${DEPLOY_PATH}/infra/nginx/"

echo "[deploy] Running remote compose deploy"
ssh "${DEPLOY_HOST}" "bash -lc '
  set -euo pipefail
  cd ${DEPLOY_PATH}

  if [ ! -f infra/docker/.env ]; then
    echo "infra/docker/.env not found. Create it from infra/docker/.env.example" >&2
    exit 1
  fi

  cd infra/docker
  docker compose --env-file .env -f docker-compose.server.yml pull
  docker compose --env-file .env -f docker-compose.server.yml up -d --remove-orphans
'"

echo "[deploy] Done"
echo "[deploy] If you changed infra/nginx config, run on server: nginx -t && systemctl reload nginx"
