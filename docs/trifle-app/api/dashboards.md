---
title: /dashboards
description: Create and manage dashboards.
nav_order: 2
---

# /api/v1/dashboards

Dashboards are JSON payloads that define widgets, layout, and defaults.

## Auth

`Authorization: Bearer <TOKEN>`

---

## Dashboard object

Fields:

- `id`, `name`, `key`
- `visibility`, `locked`
- `source_type`, `source_id`
- `organization_id`, `user_id`, `database_id`, `group_id`
- `position`, `default_timeframe`, `default_granularity`
- `payload`, `segments`
- `inserted_at`, `updated_at`

Only dashboards with `visibility: true` are listed and fetchable via API.

---

## GET /dashboards

List dashboards visible to the organization bound to the token.

### Request

:::tabs
@tab CURL
```sh
curl -s "https://app.trifle.io/api/v1/dashboards" \
  -H "Authorization: Bearer <TOKEN>"
```
:::

---

## GET /dashboards/:id

Fetch a dashboard by id (visible dashboards only).

### Request

:::tabs
@tab CURL
```sh
curl -s "https://app.trifle.io/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>"
```
:::

---

## POST /dashboards

Create a new dashboard. Body can be sent at the top level or under a `dashboard` key.

:::signature POST /api/v1/dashboards
name | String | required | Dashboard name.
key | String | required | Metric key used for widgets.
source_type | String | required | `database` or `project`.
source_id | String | required | Source UUID.
visibility | Boolean | optional | Defaults to `true` for API creates.
locked | Boolean | optional | Defaults to `false`.
payload | Map | optional | Widget layout (default `{}`).
segments | Array | optional | Segment definitions (default `[]`).
position | Integer | optional | Ordering value.
default_timeframe | String | optional | Default timeframe (e.g. `24h`).
default_granularity | String | optional | Default granularity (e.g. `1h`).
group_id | String | optional | Dashboard group id.
database_id | String | optional | Alternate way to set source (database only).
source | Map | optional | `{ "type": "database", "id": "..." }`.
:::

### Widget examples

:::tabs
@tab KPI
```json
{ "id": "kpi-1", "type": "kpi", "title": "Total", "path": "count", "function": "sum", "subtype": "number", "size": "l" }
```

@tab Timeseries
```json
{ "id": "ts-1", "type": "timeseries", "title": "Trend", "paths": ["count", "failed"], "chart_type": "area", "stacked": true, "legend": true }
```

@tab Category
```json
{ "id": "cat-1", "type": "category", "title": "By Country", "path": "country.*", "chart_type": "donut" }
```

@tab Table
```json
{ "id": "tbl-1", "type": "table", "title": "Raw", "paths": ["count", "failed", "duration"] }
```

@tab List
```json
{ "id": "list-1", "type": "list", "title": "Top Channels", "path": "channel.*", "limit": 6, "sort": "desc" }
```

@tab Text
```json
{ "id": "text-1", "type": "text", "title": "Week 3 Goals", "subtype": "header", "alignment": "left", "title_size": "large" }
```

@tab Distribution
```json
{ "id": "dist-1", "type": "distribution", "title": "Latency Dist", "paths": ["duration"], "mode": "2d", "designators": { "horizontal": { "type": "linear", "count": 12, "min": 0, "max": 1200 } } }
```
:::

Want more patterns? See the [Widget Cookbook](/trifle-app/guides/widgets).

### Request

Full dashboard:

:::tabs
@tab CURL
```sh
curl -X POST "https://app.trifle.io/api/v1/dashboards" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Signup Overview",
    "key": "event::signup",
    "source_type": "database",
    "source_id": "db-uuid",
    "payload": {
      "grid": [
        { "id": "kpi-1", "type": "kpi", "title": "Total", "path": "count", "function": "sum", "x": 0, "y": 0, "w": 4, "h": 3 },
        { "id": "ts-1", "type": "timeseries", "title": "Trend", "paths": ["count", "failed"], "chart_type": "area", "stacked": true, "legend": true, "x": 4, "y": 0, "w": 8, "h": 3 },
        { "id": "cat-1", "type": "category", "title": "By Country", "path": "country.*", "chart_type": "donut", "x": 0, "y": 3, "w": 4, "h": 3 },
        { "id": "tbl-1", "type": "table", "title": "Raw", "paths": ["count", "failed", "duration"], "x": 4, "y": 3, "w": 8, "h": 3 }
      ]
    }
  }'
```
:::

---

## PUT /dashboards/:id

Update a dashboard. Body can be sent at the top level or under a `dashboard` key.

:::signature PUT /api/v1/dashboards/:id
name | String | optional | Dashboard name.
key | String | optional | Metric key used for widgets.
source_type | String | optional | `database` or `project`.
source_id | String | optional | Source UUID.
visibility | Boolean | optional | Toggle visibility.
locked | Boolean | optional | Toggle lock.
payload | Map | optional | Widget layout.
segments | Array | optional | Segment definitions.
position | Integer | optional | Ordering value.
default_timeframe | String | optional | Default timeframe (e.g. `24h`).
default_granularity | String | optional | Default granularity (e.g. `1h`).
group_id | String | optional | Dashboard group id.
database_id | String | optional | Alternate way to set source (database only).
source | Map | optional | `{ "type": "database", "id": "..." }`.
:::

### Request

:::tabs
@tab CURL
```sh
curl -X PUT "https://app.trifle.io/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "visibility": true,
    "default_timeframe": "7d"
  }'
```
:::

---

## DELETE /dashboards/:id

Delete a dashboard by id. Returns the deleted dashboard object.

### Request

:::tabs
@tab CURL
```sh
curl -X DELETE "https://app.trifle.io/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>"
```
:::
