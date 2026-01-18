---
title: /metrics
description: Ingest and query metrics.
nav_order: 1
---

# /api/v1/metrics

Metrics endpoints for ingesting and reading time series.

## Auth

- **GET /metrics** and **POST /metrics/query** require **read** tokens.
- **POST /metrics** requires a **write** token (project token).

`Authorization: Bearer <TOKEN>`

---

## GET /metrics

Fetch a time series for a metric key.

:::signature GET /api/v1/metrics
key | String | optional | Metric key. If omitted, the system key is used.
from | ISO8601 | required | Start timestamp.
to | ISO8601 | required | End timestamp.
granularity | String | required | Bucket size (e.g. `5m`, `1h`, `1d`).
:::

### Request

:::tabs
@tab CURL
```sh
curl "https://app.trifle.io/api/v1/metrics?key=event::signup&from=2026-01-17T00:00:00Z&to=2026-01-18T00:00:00Z&granularity=1h" \
  -H "Authorization: Bearer <READ_TOKEN>"
```
:::

### Response

:::tabs
@tab Body
```json
{
  "data": {
    "at": ["2026-01-17T00:00:00Z", "2026-01-17T01:00:00Z"],
    "values": [
      {"count": 1, "duration": 0.42},
      {"count": 3, "duration": 1.09}
    ]
  }
}
```
:::

:::callout warn "Granularity matters"
- Invalid granularity returns `400`.
- If your source restricts granularities, only allowed values pass.
:::

---

## POST /metrics

Ingest metrics into Trifle.

:::signature POST /api/v1/metrics
key | String | required | Metric key (e.g. `event::signup`).
at | ISO8601 | required | Timestamp of the event.
values | Map | required | Metrics payload. Leaves must be numeric.
:::

### Request

:::tabs
@tab CURL Signup events

```sh
curl -X POST "https://app.trifle.io/api/v1/metrics" \
  -H "Authorization: Bearer <WRITE_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "event::signup",
    "at": "2026-01-17T10:00:00Z",
    "values": {
      "count": 1,
      "failed": 0,
      "duration": 0.42,
      "country": { "US": 1 },
      "channel": { "organic": 1 }
    }
  }'
```

@tab CURL Latency

```sh
curl -X POST "https://app.trifle.io/api/v1/metrics" \
  -H "Authorization: Bearer <WRITE_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "service.latency",
    "at": "2026-01-17T12:00:00Z",
    "values": {
      "count": 1,
      "duration": 532
    }
  }'
```
:::

### Response

:::tabs
@tab Body
```json
{ "data": { "created": "ok" } }
```
:::

:::callout note "Nested values are fine"
- `values` can be a nested map, but every leaf has to be numeric.
:::

---

## POST /metrics/query

Query, aggregate, or format a metric series.

:::signature POST /api/v1/metrics/query
key | String | required | Metric key.
from | ISO8601 | required | Start timestamp.
to | ISO8601 | required | End timestamp.
granularity | String | required | Bucket size (e.g. `5m`, `1h`).
mode | String | required | `aggregate`, `timeline`, or `category`. (`format` is an alias.)
value_path | String | required | Dot path into the metric payload.
aggregator | String | required | Only for `aggregate`. One of `sum`, `mean`, `min`, `max`.
slices | Integer | optional | Number of slices for the aggregation. Default: `1`.
:::

### Request

:::tabs
@tab CURL Aggregate

```sh
curl -X POST "https://app.trifle.io/api/v1/metrics/query" \
  -H "Authorization: Bearer <READ_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "event::signup",
    "from": "2026-01-17T00:00:00Z",
    "to": "2026-01-18T00:00:00Z",
    "granularity": "1h",
    "mode": "aggregate",
    "value_path": "count",
    "aggregator": "sum"
  }'
```

@tab CURL Category

```sh
curl -X POST "https://app.trifle.io/api/v1/metrics/query" \
  -H "Authorization: Bearer <READ_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "event::signup",
    "from": "2026-01-17T00:00:00Z",
    "to": "2026-01-18T00:00:00Z",
    "granularity": "1h",
    "mode": "category",
    "value_path": "country"
  }'
```
:::

### Response

:::tabs
@tab Aggregate Body

```json
{
  "data": {
    "status": "ok",
    "aggregator": "sum",
    "metric_key": "event::signup",
    "value_path": "count",
    "slices": 1,
    "values": [42],
    "count": 1,
    "timeframe": {
      "from": "2026-01-17T00:00:00Z",
      "to": "2026-01-18T00:00:00Z",
      "label": "custom",
      "granularity": "1h"
    },
    "available_paths": ["count", "duration"],
    "matched_paths": ["count"]
  }
}
```

@tab Timeline Body

```json
{
  "data": {
    "status": "ok",
    "formatter": "timeline",
    "metric_key": "service.latency",
    "value_path": "p95",
    "result": {
      "p95": [
        { "at": "2026-01-17T12:00:00Z", "value": 350.0 }
      ]
    }
  }
}
```

@tab Category Body

```json
{
  "data": {
    "status": "ok",
    "formatter": "category",
    "metric_key": "event::signup",
    "value_path": "country",
    "result": {
      "country.US": 3.0,
      "country.UK": 1.0
    }
  }
}
```
:::

:::callout warn "Common failure modes"
- Missing `aggregator` in aggregate mode returns `422`.
- Wildcards in `value_path` are rejected.
:::
