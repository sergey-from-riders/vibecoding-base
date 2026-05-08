# infra/ci

Reusable CI workflow templates.

## Example
- `github-actions.deploy.example.yml`:
  - runs mandatory verify gates (backend, frontend, db, contracts, desktop-qt),
  - enforces strict backend/frontend numeric limits via scripts,
  - builds API and Web Docker images,
  - pushes images to registry,
  - deploys to remote server by updating image tags and running compose,
  - runs post-deploy smoke checks.
