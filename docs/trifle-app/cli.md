---
title: CLI
description: Use the Trifle CLI to query and push metrics.
nav_order: 4
---

# Trifle CLI

The Trifle CLI talks to the Trifle App API (`/api/v1`) to fetch or submit metrics and manage transponders.

:::callout note "Scope"
- The CLI currently supports **metrics** and **transponders** only.
- Dashboards and monitors are managed via the API or UI.
:::

## Install

:::tabs
@tab Download
- Download a release from GitHub (macOS/Linux).
- Place `trifle` somewhere on your PATH.

@tab Build locally
```sh
cd cli
go build -o trifle .
```
Requires Go `1.22+`.
:::

## Configuration

### Environment variables

- `TRIFLE_URL` (required): Base URL for Trifle App.
- `TRIFLE_TOKEN` (required for non-interactive): API token.

### Flags (override env vars)

:::signature Common flags
--url | String | optional |  | Trifle base URL (fallback: `TRIFLE_URL`).
--token | String | optional |  | API token (fallback: `TRIFLE_TOKEN`).
--timeout | Duration | optional | `30s` | HTTP timeout.
:::

:::callout note "SaaS vs self-hosted"
- SaaS: `TRIFLE_URL=https://app.trifle.io`
- Self-hosted: `TRIFLE_URL=https://<your-host>`
:::

:::callout warn "URL scheme matters"
- If you omit the scheme, the CLI assumes `http://`.
- Use `https://` for SaaS and most self-hosted deployments.
:::

:::callout warn "Token scopes"
- Read-only tokens work for all `metrics` read commands and `transponders list`.
- Write tokens are required for `metrics push` and MCP `write_metric`.
:::

:::callout note "Interactive prompt"
- If no token is provided, the CLI prompts on stdin.
- MCP mode skips prompting (token required upfront).
:::

## Quick start

:::tabs
@tab SaaS
```sh
export TRIFLE_URL="https://app.trifle.io"
export TRIFLE_TOKEN="<READ_TOKEN>"

trifle metrics keys --from 2026-01-24T00:00:00Z --to 2026-01-25T00:00:00Z
```

@tab Self-hosted
```sh
export TRIFLE_URL="https://trifle.example.com"
export TRIFLE_TOKEN="<READ_TOKEN>"

trifle metrics get --key event::signup --from 2026-01-24T00:00:00Z --to 2026-01-25T00:00:00Z --granularity 1h
```

@tab One-off (flags)
```sh
trifle metrics get \
  --url https://app.trifle.io \
  --token <READ_TOKEN> \
  --key event::signup \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```
:::

## Common behaviors

- If `--from` and `--to` are omitted, the CLI uses the **last 24 hours**.
- `--from` and `--to` must be provided together (RFC3339).
- If `--granularity` is omitted, the CLI uses the source default from `/api/v1/source`.
- Value paths (`--value-path`) must be **single paths** (no wildcards).

## Metrics

### List keys

Fetch available metric keys from the system series.

```sh
trifle metrics keys --from 2026-01-24T00:00:00Z --to 2026-01-25T00:00:00Z
```

Output formats:

```sh
trifle metrics keys --format table
trifle metrics keys --format csv
```

Sample JSON output:

```json
{
  "status": "ok",
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "granularity": "1h"
  },
  "paths": [
    { "metric_key": "event::signup", "observations": 42 },
    { "metric_key": "service.latency", "observations": 18 }
  ],
  "total_paths": 2
}
```

Sample table output:

```
metric_key      observations
----------      ------------
event::signup   42
service.latency 18
```

### Fetch raw series

```sh
trifle metrics get \
  --key event::signup \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```

Sample output:

```json
{
  "data": {
    "at": ["2026-01-24T00:00:00Z", "2026-01-24T01:00:00Z"],
    "values": [
      { "count": 1, "duration": 0.42 },
      { "count": 3, "duration": 1.09 }
    ]
  }
}
```

### Aggregate series

```sh
trifle metrics aggregate \
  --key event::signup \
  --value-path count \
  --aggregator sum \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h \
  --format table
```

Sample JSON output (when `--format json`):

```json
{
  "status": "ok",
  "aggregator": "sum",
  "metric_key": "event::signup",
  "value_path": "count",
  "slices": 1,
  "value": 42.0,
  "values": [42.0],
  "count": 1,
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "label": "custom",
    "granularity": "1h"
  },
  "available_paths": ["count", "duration"],
  "matched_paths": ["count"],
  "table": {
    "columns": ["at", "count"],
    "rows": [
      ["2026-01-24T00:00:00Z", 1.0],
      ["2026-01-24T01:00:00Z", 2.0]
    ]
  }
}
```

### Timeline format

```sh
trifle metrics timeline \
  --key service.latency \
  --value-path p95 \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```

Sample output:

```json
{
  "status": "ok",
  "formatter": "timeline",
  "metric_key": "service.latency",
  "value_path": "p95",
  "slices": 1,
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "label": "custom",
    "granularity": "1h"
  },
  "result": {
    "p95": [
      { "at": "2026-01-24T12:00:00Z", "value": 350.0 }
    ]
  },
  "available_paths": ["count", "p50", "p95", "p99"],
  "matched_paths": ["p95"]
}
```

### Category format

```sh
trifle metrics category \
  --key event::signup \
  --value-path country \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```

Sample output:

```json
{
  "status": "ok",
  "formatter": "category",
  "metric_key": "event::signup",
  "value_path": "country",
  "slices": 1,
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "label": "custom",
    "granularity": "1h"
  },
  "result": {
    "country.US": 3.0,
    "country.UK": 1.0
  },
  "available_paths": ["count", "country.US", "country.UK"],
  "matched_paths": ["country.US", "country.UK"]
}
```

### Push a metric

```sh
trifle metrics push \
  --key event::signup \
  --at 2026-01-24T12:00:00Z \
  --values '{"count": 1, "duration": 0.42}'
```

:::callout note "Values must be numeric"
- Trifle accepts nested maps, but every leaf must be numeric.
:::

Sample output:

```json
{ "data": { "created": "ok" } }
```

From a file:

```sh
trifle metrics push \
  --key checkout.completed \
  --values-file ./metric_payload.json
```

Example payload file:

```json
{
  "count": 1,
  "amount": 129.99,
  "country": { "US": 1 },
  "channel": { "organic": 1 }
}
```

## Transponders

### List transponders

```sh
trifle transponders list
```

Sample output:

```json
{
  "data": [
    {
      "id": "transponder-uuid",
      "name": "Success rate",
      "key": "event::signup",
      "type": "Trifle.Stats.Transponder.Expression",
      "config": {
        "paths": ["success", "count"],
        "expression": "a / b",
        "response_path": "success_rate"
      },
      "enabled": true,
      "order": 1,
      "source_type": "database",
      "source_id": "db-uuid"
    }
  ]
}
```

### Create a transponder

```sh
trifle transponders create \
  --payload '{
    "name": "Success rate",
    "key": "event::signup",
    "paths": ["success", "count"],
    "expression": "a / b",
    "response_path": "success_rate"
  }'
```

Or from a file:

```sh
trifle transponders create --payload-file ./transponder.json
```

Example file:

```json
{
  "name": "Double count",
  "key": "event::signup",
  "config": {
    "paths": ["count"],
    "expression": "a * 2",
    "response_path": "count_twice"
  }
}
```

Sample output:

```json
{
  "data": {
    "id": "transponder-uuid",
    "name": "Double count",
    "key": "event::signup",
    "type": "Trifle.Stats.Transponder.Expression",
    "config": {
      "paths": ["count"],
      "expression": "a * 2",
      "response_path": "count_twice"
    },
    "enabled": true,
    "order": 1,
    "source_type": "database",
    "source_id": "db-uuid"
  }
}
```

### Update a transponder

```sh
trifle transponders update \
  --id <TRANSPONDER_ID> \
  --payload '{ "enabled": false }'
```

Sample output:

```json
{
  "data": {
    "id": "transponder-uuid",
    "name": "Success rate",
    "key": "event::signup",
    "type": "Trifle.Stats.Transponder.Expression",
    "config": {
      "paths": ["success", "count"],
      "expression": "a / b",
      "response_path": "success_rate"
    },
    "enabled": false,
    "order": 1,
    "source_type": "database",
    "source_id": "db-uuid"
  }
}
```

:::callout note "Payload format"
- `--payload` and `--payload-file` must be JSON objects.
:::

### Delete a transponder

```sh
trifle transponders delete --id <TRANSPONDER_ID>
```

Sample output:

```json
{
  "data": {
    "id": "transponder-uuid",
    "name": "Success rate",
    "key": "event::signup",
    "type": "Trifle.Stats.Transponder.Expression",
    "config": {
      "paths": ["success", "count"],
      "expression": "a / b",
      "response_path": "success_rate"
    },
    "enabled": false,
    "order": 1,
    "source_type": "database",
    "source_id": "db-uuid"
  }
}
```

## Troubleshooting

:::callout note "No output?"
- Use `--from` + `--to` to widen the timeframe.
- Confirm your token scope with `/api/v1/source`.
:::

:::callout warn "Self-hosted defaults"
- If you self-host and keep projects disabled, `metrics push` will return `403`.
:::
