---
title: API Endpoints
description: HTTP API for metrics, dashboards, and monitors.
nav_order: 4
---

# API Endpoints

Base URL: `/api/v1`

## Authentication

All API requests (except health) use bearer tokens:

### Request

:::tabs
@tab CURL
```sh
curl -H "Authorization: Bearer <TOKEN>" \
  https://app.trifle.io/api/v1/source
```
:::

- **Project tokens** can be read or write.
- **Database tokens** are read-only.
- Write permissions are enforced for metrics ingestion only.

## Error format

### Response

:::tabs
@tab Body
```json
{
  "errors": { "detail": "Bad token" }
}
```
:::

## Status codes

- `200` / `201` Success.
- `400` Invalid request or parameter.
- `401` Missing or invalid token.
- `403` Token does not have permission (e.g. write with a read-only token).
- `404` Resource not found.
- `422` Validation error.

## Troubleshooting

- **Check API health**: `GET /api/v1/health`.
- **Check token context**: `GET /api/v1/source` shows source type, granularity rules, and token scope.

## Endpoints

- [/health](/trifle-app/api/health)
- [/source](/trifle-app/api/source)
- [/metrics](/trifle-app/api/metrics)
- [/transponders](/trifle-app/api/transponders)
- [/dashboards](/trifle-app/api/dashboards)
- [/monitors](/trifle-app/api/monitors)
