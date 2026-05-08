# packages/contracts

Source-of-truth API contracts for Go Next Postgres Framework.

## OpenAPI layout

```text
packages/contracts/openapi/
├─ openapi.root.yaml
├─ redocly.yaml
├─ endpoints.inventory.tsv
├─ modules/
│  ├─ auth.yaml
│  ├─ company.yaml
│  └─ docs.yaml
├─ components/
│  └─ schemas/
│     ├─ common.yaml
│     ├─ auth.yaml
│     ├─ company.yaml
│     └─ docs.yaml
└─ dist/
```

## Build and validation

1. Build bundle/docs/catalog:
- `tools/scripts/build_openapi_bundle.sh`
2. Check endpoint coverage vs inventory:
- `tools/scripts/check_openapi_coverage.sh`

## Contract rules

1. Every endpoint must exist in OpenAPI and in `endpoints.inventory.tsv`.
2. Every endpoint must include examples or code samples.
3. Docs endpoints are mandatory:
- `GET /api/v1/docs/openapi.json`
- `GET /api/v1/docs/openapi.yaml`
- `GET /api/v1/docs/endpoints`
- `GET /api/v1/docs/testing/postman`
