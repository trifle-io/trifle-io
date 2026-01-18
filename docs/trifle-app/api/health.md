---
title: /health
description: Health check for the Trifle API.
nav_order: 6
---

# /api/v1/health

Quick health check. No auth required.

## Request

:::tabs
@tab CURL
```sh
curl -s https://app.trifle.io/api/v1/health
```
:::

## Response

:::signature 200 OK -> JSON
status | String | required | Always `"ok"`.
timestamp | ISO8601 | required | Server time in UTC.
api_version | String | required | API version.
server_version | String | required | Trifle app version.
:::

:::tabs
@tab Body
```json
{
  "status": "ok",
  "timestamp": "2026-01-17T12:00:00Z",
  "api_version": "v1",
  "server_version": "0.11.8"
}
```
:::
