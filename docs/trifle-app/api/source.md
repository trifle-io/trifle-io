---
title: /source
description: Inspect the current source (project/database).
nav_order: 5
---

# /api/v1/source

Returns metadata about the source bound to the token.

## Auth

`Authorization: Bearer <TOKEN>`

## Request

:::tabs
@tab CURL
```sh
curl -s "https://app.trifle.io/api/v1/source" \
  -H "Authorization: Bearer <TOKEN>"
```
:::

## Response

:::signature 200 OK -> JSON
api_version | String | required | API version string.
server_version | String | required | App version string.
id | String | required | Source id (UUID as string).
type | String | required | `"project"` or `"database"`.
display_name | String | required | Human name for the source.
default_timeframe | String | required | Default timeframe label.
default_granularity | String | required | Default granularity (e.g. `1h`).
available_granularities | Array<String> | required | Allowed granularities.
time_zone | String | required | Time zone (e.g. `UTC`).
:::

:::tabs
@tab Body
```json
{
  "data": {
    "api_version": "v1",
    "server_version": "0.11.8",
    "id": "source-uuid",
    "type": "database",
    "display_name": "Main",
    "default_timeframe": "24h",
    "default_granularity": "1h",
    "available_granularities": ["5m", "1h", "1d"],
    "time_zone": "UTC"
  }
}
```
:::
