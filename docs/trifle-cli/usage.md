---
title: Usage
description: Common CLI workflows for metrics and transponders.
nav_order: 3
---

# Usage

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

@tab SQLite (local)
```sh
trifle metrics setup --driver sqlite --db ./stats.db

trifle metrics push --driver sqlite --db ./stats.db --key event::signup --values '{"count":1}'
trifle metrics get --driver sqlite --db ./stats.db --key event::signup --granularity 1h
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

## SQLite driver

Use `--driver sqlite` with a local SQLite database. Initialize the schema once:

```sh
trifle metrics setup --driver sqlite --db ./stats.db
```

If you configure sqlite as a named source, select it with `--source`:

```sh
trifle metrics get --source sqlite --key event::signup --granularity 1h
```

Supported commands:
- `metrics push` (with `--mode track|assert`)
- `metrics get` (with `--skip-blanks`)
- `metrics keys` (reads `__system__key__` when available)
- `metrics aggregate`
- `metrics timeline`
- `metrics category`

## Metrics

### List keys

Fetch available metric keys from the system series.

:::tabs
@tab API
```sh
trifle metrics keys --from 2026-01-24T00:00:00Z --to 2026-01-25T00:00:00Z
```

@tab SQLite
```sh
trifle metrics keys --driver sqlite --db ./stats.db --granularity 1h
```
:::

Output formats:

:::tabs
@tab JSON
```sh
trifle metrics keys --format json
```

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

@tab Table
```sh
trifle metrics keys --format table
```

```
metric_key      observations
----------      ------------
event::signup   42
service.latency 18
```

@tab CSV
```sh
trifle metrics keys --format csv
```

```
metric_key,observations
event::signup,42
service.latency,18
```
:::

### Fetch series

:::tabs
@tab API
```sh
trifle metrics get \
  --key event::signup \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```

@tab SQLite
```sh
trifle metrics get \
  --driver sqlite \
  --db ./stats.db \
  --key event::signup \
  --granularity 1h \
  --skip-blanks
```
:::

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

### Push a metric

:::tabs
@tab API
```sh
trifle metrics push \
  --key event::signup \
  --at 2026-01-24T12:00:00Z \
  --values '{"count": 1, "duration": 0.42}'
```

@tab SQLite
```sh
trifle metrics push \
  --driver sqlite \
  --db ./stats.db \
  --mode assert \
  --key event::signup \
  --at 2026-01-24T12:00:00Z \
  --values '{"count": 5}'
```
:::

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

### Aggregate series

:::tabs
@tab API
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

@tab SQLite
```sh
trifle metrics aggregate \
  --driver sqlite \
  --db ./stats.db \
  --key event::signup \
  --value-path count \
  --aggregator sum \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h \
  --format table
```
:::

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

:::tabs
@tab API
```sh
trifle metrics timeline \
  --key service.latency \
  --value-path p95 \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```

@tab SQLite
```sh
trifle metrics timeline \
  --driver sqlite \
  --db ./stats.db \
  --key service.latency \
  --value-path p95 \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```
:::

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

:::tabs
@tab API
```sh
trifle metrics category \
  --key event::signup \
  --value-path country \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```

@tab SQLite
```sh
trifle metrics category \
  --driver sqlite \
  --db ./stats.db \
  --key event::signup \
  --value-path country \
  --from 2026-01-24T00:00:00Z \
  --to 2026-01-25T00:00:00Z \
  --granularity 1h
```
:::

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
  "paths": ["count"],
  "expression": "a * 2",
  "response_path": "double_count"
}
```

### Update a transponder

```sh
trifle transponders update \
  --id <TRANSPONDER_ID> \
  --payload '{
    "expression": "a / b"
  }'
```

### Delete a transponder

```sh
trifle transponders delete --id <TRANSPONDER_ID>
```
