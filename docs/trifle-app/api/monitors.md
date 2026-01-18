---
title: /monitors
description: Create and manage monitors and alerts.
nav_order: 3
---

# /api/v1/monitors

Monitors automate scheduled reports and alerting.

## Auth

`Authorization: Bearer <TOKEN>`

---

## Monitor fields

Required on create:

- `name` (string)
- `type` (`report` | `alert`)
- `status` (`active` | `paused`)
- `source_type` (`database` | `project`)
- `source_id` (UUID)

Optional:

- `description` (string)
- `locked` (boolean)
- `target` (map)
- `segment_values` (map)
- `dashboard_id` (UUID)
- `report_settings` (map)
- `delivery_channels` (array)
- `delivery_media` (array)
- `alert_metric_key` (string)
- `alert_metric_path` (string)
- `alert_timeframe` (string, e.g. `1h`, `24h`)
- `alert_granularity` (string, e.g. `5m`, `1h`)
- `alert_notify_every` (integer, default: `1`)
- `alerts` (array)

### Payload snippets

:::tabs
@tab Report settings
```json
"report_settings": {
  "frequency": "daily",      // hourly | daily | weekly | monthly
  "timeframe": "7d",
  "granularity": "1d"
}
```

@tab Delivery channels
```json
"delivery_channels": [
  {
    "channel": "email",       // email | slack_webhook | discord_webhook | webhook | custom
    "label": "Primary",
    "target": "ops@example.com",
    "config": { "webhook_url": "..." }
  }
]
```

@tab Delivery media
```json
"delivery_media": [
  { "medium": "pdf" }          // pdf | png_light | png_dark | file_csv | file_json
]
```

@tab Alert
```json
{
  "analysis_strategy": "threshold",
  "settings": {
    "threshold_direction": "above",
    "threshold_value": 100
  }
}
```
:::

### Alerts

Supported strategies:

- `threshold`
- `range`
- `hampel`
- `cusum`

Strategy settings:

- `threshold`: `threshold_direction` (`above` | `below`), `threshold_value` (number)
- `range`: `range_min_value` (number), `range_max_value` (number, must be > min)
- `hampel`: `hampel_window_size` (int > 0), `hampel_k` (number > 0), `hampel_mad_floor` (number >= 0), `treat_nil_as_zero` (bool)
- `cusum`: `cusum_k` (number >= 0), `cusum_h` (number > 0)

:::callout note "Alerts are replace-on-write"
- If you include `alerts`, they replace the existing alerts.
- Omit `alerts` to keep current ones.
:::

---

## GET /monitors

List monitors visible to the organization bound to the token.

### Request

:::tabs
@tab CURL
```sh
curl -s "https://app.trifle.io/api/v1/monitors" \
  -H "Authorization: Bearer <TOKEN>"
```
:::

---

## GET /monitors/:id

Fetch a single monitor by id.

### Request

:::tabs
@tab CURL
```sh
curl -s "https://app.trifle.io/api/v1/monitors/MONITOR_ID" \
  -H "Authorization: Bearer <TOKEN>"
```
:::

---

## POST /monitors

Create a monitor. Body can be sent at the top level or under a `monitor` key.

:::signature POST /api/v1/monitors
name | String | required | Monitor name.
type | String | required | `report` or `alert`.
status | String | required | `active` or `paused`.
source_type | String | required | `database` or `project`.
source_id | String | required | Source UUID.
description | String | optional | Human description.
locked | Boolean | optional | Lock the monitor.
target | Map | optional | Target settings (alert-specific).
segment_values | Map | optional | Segment overrides.
dashboard_id | String | optional | Dashboard UUID (report).
report_settings | Map | optional | Report settings.
delivery_channels | Array | optional | Delivery channels.
delivery_media | Array | optional | Delivery media.
alert_metric_key | String | optional | Metric key (alert).
alert_metric_path | String | optional | Metric path (alert).
alert_timeframe | String | optional | Timeframe (alert).
alert_granularity | String | optional | Granularity (alert).
alert_notify_every | Integer | optional | Notify every N evaluations.
alerts | Array | optional | Alert rules (replace-on-write).
:::

### Request

:::tabs
@tab CURL Report monitor

```sh
curl -X POST "https://app.trifle.io/api/v1/monitors" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Weekly Growth Report",
    "type": "report",
    "status": "active",
    "source_type": "database",
    "source_id": "db-uuid",
    "dashboard_id": "dashboard-uuid",
    "report_settings": { "frequency": "weekly", "timeframe": "7d", "granularity": "1d" },
    "delivery_channels": [
      { "channel": "email", "label": "Ops", "target": "ops@example.com" },
      { "channel": "slack_webhook", "label": "Analytics", "target": "https://hooks.slack.com/services/..." }
    ],
    "delivery_media": [ { "medium": "pdf" }, { "medium": "png_light" } ]
  }'
```

@tab CURL Alert monitor

```sh
curl -X POST "https://app.trifle.io/api/v1/monitors" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Latency Alerts",
    "type": "alert",
    "status": "active",
    "source_type": "database",
    "source_id": "db-uuid",
    "alert_metric_key": "service.latency",
    "alert_metric_path": "p95",
    "alert_timeframe": "1h",
    "alert_granularity": "5m",
    "alert_notify_every": 1,
    "alerts": [
      { "analysis_strategy": "threshold", "settings": { "threshold_direction": "above", "threshold_value": 350 } }
    ]
  }'
```

@tab CURL Multi-strategy

```sh
curl -X POST "https://app.trifle.io/api/v1/monitors" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Error Rate Guardrails",
    "type": "alert",
    "status": "active",
    "source_type": "project",
    "source_id": "project-uuid",
    "alert_metric_key": "service.errors",
    "alert_metric_path": "rate",
    "alert_timeframe": "24h",
    "alert_granularity": "1h",
    "alert_notify_every": 2,
    "alerts": [
      { "analysis_strategy": "threshold", "settings": { "threshold_direction": "above", "threshold_value": 0.05 } },
      { "analysis_strategy": "range", "settings": { "range_min_value": 0.0, "range_max_value": 0.03 } },
      { "analysis_strategy": "hampel", "settings": { "hampel_window_size": 6, "hampel_k": 3.0, "hampel_mad_floor": 0.0001 } },
      { "analysis_strategy": "cusum", "settings": { "cusum_k": 0.001, "cusum_h": 0.01 } }
    ]
  }'
```
:::

---

## PUT /monitors/:id

Update a monitor. Body can be sent at the top level or under a `monitor` key.

:::signature PUT /api/v1/monitors/:id
name | String | optional | Monitor name.
type | String | optional | `report` or `alert`.
status | String | optional | `active` or `paused`.
source_type | String | optional | `database` or `project`.
source_id | String | optional | Source UUID.
description | String | optional | Human description.
locked | Boolean | optional | Lock the monitor.
target | Map | optional | Target settings (alert-specific).
segment_values | Map | optional | Segment overrides.
dashboard_id | String | optional | Dashboard UUID (report).
report_settings | Map | optional | Report settings.
delivery_channels | Array | optional | Delivery channels.
delivery_media | Array | optional | Delivery media.
alert_metric_key | String | optional | Metric key (alert).
alert_metric_path | String | optional | Metric path (alert).
alert_timeframe | String | optional | Timeframe (alert).
alert_granularity | String | optional | Granularity (alert).
alert_notify_every | Integer | optional | Notify every N evaluations.
alerts | Array | optional | Alert rules (replace-on-write).
:::

### Request

:::tabs
@tab CURL
```sh
curl -X PUT "https://app.trifle.io/api/v1/monitors/MONITOR_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{ "status": "paused", "alert_notify_every": 3 }'
```
:::

---

## DELETE /monitors/:id

Delete a monitor by id. Returns the deleted monitor object.

### Request

:::tabs
@tab CURL
```sh
curl -X DELETE "https://app.trifle.io/api/v1/monitors/MONITOR_ID" \
  -H "Authorization: Bearer <TOKEN>"
```
:::
