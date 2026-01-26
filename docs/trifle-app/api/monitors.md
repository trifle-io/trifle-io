---
title: /monitors
description: Create and manage monitors and alerts.
nav_order: 3
---

# /api/v1/monitors

Monitors automate scheduled reports and alerting.

:::callout note "Base URL"
Replace `<TRIFLE_APP_URL>` with `https://app.trifle.io` or your self-hosted URL.
:::

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

Conditional requirements:

- `type: report` → `dashboard_id` is required.
- `type: alert` → `alert_metric_key` + `alert_metric_path` are required.

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

:::callout note "Source types"
- If you self-host with projects disabled, use `source_type: "database"` only.
:::

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
    "target": "ops@example.com"
  },
  {
    "channel": "slack_webhook",
    "label": "Ops",
    "target": "https://hooks.slack.com/services/..."
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

@tab Alert (range)
```json
{
  "analysis_strategy": "range",
  "settings": {
    "range_min_value": 0.01,
    "range_max_value": 0.03
  }
}
```

@tab Alert (hampel)
```json
{
  "analysis_strategy": "hampel",
  "settings": {
    "hampel_window_size": 6,
    "hampel_k": 3.0,
    "hampel_mad_floor": 0.0001,
    "treat_nil_as_zero": false
  }
}
```

@tab Alert (cusum)
```json
{
  "analysis_strategy": "cusum",
  "settings": {
    "cusum_k": 0.001,
    "cusum_h": 0.01
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
- Include `id` in an alert entry to update that alert in place.
:::

---

## GET /monitors

List monitors visible to the organization bound to the token.

### Request

:::tabs
@tab CURL
```sh
curl -s "<TRIFLE_APP_URL>/api/v1/monitors" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
uri = URI("#{base}/api/v1/monitors")

req = Net::HTTP::Get.new(uri)
req["Authorization"] = "Bearer #{token}"

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.request(req)
end

puts res.code
puts res.body
```

@tab Elixir
```elixir
base = System.fetch_env!("TRIFLE_APP_URL")
token = System.fetch_env!("TRIFLE_TOKEN")
url = "#{base}/api/v1/monitors"

headers = [
  {'authorization', to_charlist("Bearer " <> token)}
]

:inets.start()
:ssl.start()
{:ok, {{_, status, _}, _resp_headers, body}} =
  :httpc.request(:get, {String.to_charlist(url), headers}, [], [])

IO.puts(status)
IO.puts(body)
```

@tab Node.js
```js
const base = process.env.TRIFLE_APP_URL;
const token = process.env.TRIFLE_TOKEN;

const res = await fetch(`${base}/api/v1/monitors`, {
  headers: { Authorization: `Bearer ${token}` },
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]

resp = requests.get(
  f"{base}/api/v1/monitors",
  headers={"Authorization": f"Bearer {token}"},
)

print(resp.status_code)
print(resp.json())
```

@tab PHP
```php
<?php
$base = getenv("TRIFLE_APP_URL");
$token = getenv("TRIFLE_TOKEN");

$ch = curl_init("$base/api/v1/monitors");
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Authorization: Bearer $token"]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo $code . PHP_EOL;
echo $body;
```
:::

### Response

:::tabs
@tab Body
```json
{
  "data": [
    {
      "id": "monitor-uuid",
      "name": "Latency Alerts",
      "description": null,
      "type": "alert",
      "status": "active",
      "locked": false,
      "target": {},
      "segment_values": {},
      "trigger_status": "idle",
      "source_type": "database",
      "source_id": "db-uuid",
      "dashboard_id": null,
      "alert_metric_key": "service.latency",
      "alert_metric_path": "p95",
      "alert_timeframe": "1h",
      "alert_granularity": "5m",
      "alert_notify_every": 1,
      "report_settings": null,
      "delivery_channels": [
        { "channel": "slack_webhook", "label": "Ops", "target": "https://hooks.slack.com/services/...", "config": {} }
      ],
      "delivery_media": [ { "medium": "png_light" } ],
      "alerts": [
        {
          "id": "alert-uuid",
          "analysis_strategy": "threshold",
          "status": "passed",
          "settings": { "threshold_direction": "above", "threshold_value": 350.0 },
          "last_summary": null,
          "last_evaluated_at": null,
          "continuous_trigger_count": 0,
          "inserted_at": "2026-01-24T12:00:00Z",
          "updated_at": "2026-01-24T12:00:00Z"
        }
      ],
      "inserted_at": "2026-01-24T12:00:00Z",
      "updated_at": "2026-01-24T12:00:00Z"
    }
  ]
}
```
:::

---

## GET /monitors/:id

Fetch a single monitor by id.

### Request

:::tabs
@tab CURL
```sh
curl -s "<TRIFLE_APP_URL>/api/v1/monitors/MONITOR_ID" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
monitor_id = "MONITOR_ID"
uri = URI("#{base}/api/v1/monitors/#{monitor_id}")

req = Net::HTTP::Get.new(uri)
req["Authorization"] = "Bearer #{token}"

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.request(req)
end

puts res.code
puts res.body
```

@tab Elixir
```elixir
base = System.fetch_env!("TRIFLE_APP_URL")
token = System.fetch_env!("TRIFLE_TOKEN")
monitor_id = "MONITOR_ID"
url = "#{base}/api/v1/monitors/#{monitor_id}"

headers = [
  {'authorization', to_charlist("Bearer " <> token)}
]

:inets.start()
:ssl.start()
{:ok, {{_, status, _}, _resp_headers, body}} =
  :httpc.request(:get, {String.to_charlist(url), headers}, [], [])

IO.puts(status)
IO.puts(body)
```

@tab Node.js
```js
const base = process.env.TRIFLE_APP_URL;
const token = process.env.TRIFLE_TOKEN;
const monitorId = "MONITOR_ID";

const res = await fetch(`${base}/api/v1/monitors/${monitorId}`, {
  headers: { Authorization: `Bearer ${token}` },
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]
monitor_id = "MONITOR_ID"

resp = requests.get(
  f"{base}/api/v1/monitors/{monitor_id}",
  headers={"Authorization": f"Bearer {token}"},
)

print(resp.status_code)
print(resp.json())
```

@tab PHP
```php
<?php
$base = getenv("TRIFLE_APP_URL");
$token = getenv("TRIFLE_TOKEN");
$monitorId = "MONITOR_ID";

$ch = curl_init("$base/api/v1/monitors/$monitorId");
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Authorization: Bearer $token"]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo $code . PHP_EOL;
echo $body;
```
:::

### Response

Returns the same monitor object as the list endpoint, wrapped in `data`.

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
curl -X POST "<TRIFLE_APP_URL>/api/v1/monitors" \
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
curl -X POST "<TRIFLE_APP_URL>/api/v1/monitors" \
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

@tab CURL Report (webhook)

```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/monitors" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Daily Executive Report",
    "type": "report",
    "status": "active",
    "source_type": "database",
    "source_id": "db-uuid",
    "dashboard_id": "dashboard-uuid",
    "report_settings": { "frequency": "daily", "timeframe": "24h", "granularity": "1h" },
    "delivery_channels": [
      { "channel": "webhook", "label": "BI", "target": "https://example.com/trifle-webhook" }
    ],
    "delivery_media": [ { "medium": "file_csv" }, { "medium": "file_json" } ]
  }'
```

@tab CURL Multi-strategy

```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/monitors" \
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

### Language examples

:::tabs
@tab Ruby
```ruby
require "net/http"
require "json"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
uri = URI("#{base}/api/v1/monitors")

payload = {
  name: "Weekly Growth Report",
  type: "report",
  status: "active",
  source_type: "database",
  source_id: "db-uuid",
  dashboard_id: "dashboard-uuid",
  report_settings: { frequency: "weekly", timeframe: "7d", granularity: "1d" },
  delivery_channels: [
    { channel: "email", label: "Ops", target: "ops@example.com" }
  ],
  delivery_media: [{ medium: "pdf" }]
}

req = Net::HTTP::Post.new(uri)
req["Authorization"] = "Bearer #{token}"
req["Content-Type"] = "application/json"
req.body = payload.to_json

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.request(req)
end

puts res.code
puts res.body
```

@tab Elixir
```elixir
base = System.fetch_env!("TRIFLE_APP_URL")
token = System.fetch_env!("TRIFLE_TOKEN")
url = "#{base}/api/v1/monitors"

payload = %{
  "name" => "Weekly Growth Report",
  "type" => "report",
  "status" => "active",
  "source_type" => "database",
  "source_id" => "db-uuid",
  "dashboard_id" => "dashboard-uuid",
  "report_settings" => %{"frequency" => "weekly", "timeframe" => "7d", "granularity" => "1d"},
  "delivery_channels" => [
    %{"channel" => "email", "label" => "Ops", "target" => "ops@example.com"}
  ],
  "delivery_media" => [%{"medium" => "pdf"}]
}

headers = [
  {'authorization', to_charlist("Bearer " <> token)},
  {'content-type', 'application/json'}
]

:inets.start()
:ssl.start()
{:ok, {{_, status, _}, _resp_headers, body}} =
  :httpc.request(:post, {String.to_charlist(url), headers, 'application/json', Jason.encode!(payload)}, [], [])

IO.puts(status)
IO.puts(body)
```

@tab Node.js
```js
const base = process.env.TRIFLE_APP_URL;
const token = process.env.TRIFLE_TOKEN;

const res = await fetch(`${base}/api/v1/monitors`, {
  method: "POST",
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    name: "Weekly Growth Report",
    type: "report",
    status: "active",
    source_type: "database",
    source_id: "db-uuid",
    dashboard_id: "dashboard-uuid",
    report_settings: { frequency: "weekly", timeframe: "7d", granularity: "1d" },
    delivery_channels: [{ channel: "email", label: "Ops", target: "ops@example.com" }],
    delivery_media: [{ medium: "pdf" }],
  }),
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]

payload = {
  "name": "Weekly Growth Report",
  "type": "report",
  "status": "active",
  "source_type": "database",
  "source_id": "db-uuid",
  "dashboard_id": "dashboard-uuid",
  "report_settings": {"frequency": "weekly", "timeframe": "7d", "granularity": "1d"},
  "delivery_channels": [{"channel": "email", "label": "Ops", "target": "ops@example.com"}],
  "delivery_media": [{"medium": "pdf"}],
}

resp = requests.post(
  f"{base}/api/v1/monitors",
  headers={"Authorization": f"Bearer {token}"},
  json=payload,
)

print(resp.status_code)
print(resp.json())
```

@tab PHP
```php
<?php
$base = getenv("TRIFLE_APP_URL");
$token = getenv("TRIFLE_TOKEN");

$payload = [
  "name" => "Weekly Growth Report",
  "type" => "report",
  "status" => "active",
  "source_type" => "database",
  "source_id" => "db-uuid",
  "dashboard_id" => "dashboard-uuid",
  "report_settings" => ["frequency" => "weekly", "timeframe" => "7d", "granularity" => "1d"],
  "delivery_channels" => [["channel" => "email", "label" => "Ops", "target" => "ops@example.com"]],
  "delivery_media" => [["medium" => "pdf"]],
];

$ch = curl_init("$base/api/v1/monitors");
curl_setopt($ch, CURLOPT_HTTPHEADER, [
  "Authorization: Bearer $token",
  "Content-Type: application/json",
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo $code . PHP_EOL;
echo $body;
```
:::

### Response

:::tabs
@tab Body
```json
{
  "data": {
    "id": "monitor-uuid",
    "name": "Weekly Growth Report",
    "description": null,
    "type": "report",
    "status": "active",
    "locked": false,
    "target": {},
    "segment_values": {},
    "trigger_status": "idle",
    "source_type": "database",
    "source_id": "db-uuid",
    "dashboard_id": "dashboard-uuid",
    "alert_metric_key": null,
    "alert_metric_path": null,
    "alert_timeframe": null,
    "alert_granularity": null,
    "alert_notify_every": 1,
    "report_settings": { "frequency": "weekly", "timeframe": "7d", "granularity": "1d" },
    "delivery_channels": [
      { "channel": "email", "label": "Ops", "target": "ops@example.com", "config": {} }
    ],
    "delivery_media": [ { "medium": "pdf" } ],
    "alerts": [],
    "inserted_at": "2026-01-24T12:00:00Z",
    "updated_at": "2026-01-24T12:00:00Z"
  }
}
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
curl -X PUT "<TRIFLE_APP_URL>/api/v1/monitors/MONITOR_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{ "status": "paused", "alert_notify_every": 3 }'
```

@tab Ruby
```ruby
require "net/http"
require "json"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
monitor_id = "MONITOR_ID"
uri = URI("#{base}/api/v1/monitors/#{monitor_id}")

payload = { status: "paused", alert_notify_every: 3 }

req = Net::HTTP::Put.new(uri)
req["Authorization"] = "Bearer #{token}"
req["Content-Type"] = "application/json"
req.body = payload.to_json

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.request(req)
end

puts res.code
puts res.body
```

@tab Elixir
```elixir
base = System.fetch_env!("TRIFLE_APP_URL")
token = System.fetch_env!("TRIFLE_TOKEN")
monitor_id = "MONITOR_ID"
url = "#{base}/api/v1/monitors/#{monitor_id}"

payload = %{"status" => "paused", "alert_notify_every" => 3}

headers = [
  {'authorization', to_charlist("Bearer " <> token)},
  {'content-type', 'application/json'}
]

:inets.start()
:ssl.start()
{:ok, {{_, status, _}, _resp_headers, body}} =
  :httpc.request(:put, {String.to_charlist(url), headers, 'application/json', Jason.encode!(payload)}, [], [])

IO.puts(status)
IO.puts(body)
```

@tab Node.js
```js
const base = process.env.TRIFLE_APP_URL;
const token = process.env.TRIFLE_TOKEN;
const monitorId = "MONITOR_ID";

const res = await fetch(`${base}/api/v1/monitors/${monitorId}`, {
  method: "PUT",
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ status: "paused", alert_notify_every: 3 }),
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]
monitor_id = "MONITOR_ID"

payload = {"status": "paused", "alert_notify_every": 3}

resp = requests.put(
  f"{base}/api/v1/monitors/{monitor_id}",
  headers={"Authorization": f"Bearer {token}"},
  json=payload,
)

print(resp.status_code)
print(resp.json())
```

@tab PHP
```php
<?php
$base = getenv("TRIFLE_APP_URL");
$token = getenv("TRIFLE_TOKEN");
$monitorId = "MONITOR_ID";

$payload = ["status" => "paused", "alert_notify_every" => 3];

$ch = curl_init("$base/api/v1/monitors/$monitorId");
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($ch, CURLOPT_HTTPHEADER, [
  "Authorization: Bearer $token",
  "Content-Type: application/json",
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo $code . PHP_EOL;
echo $body;
```
:::

---

## DELETE /monitors/:id

Delete a monitor by id. Returns the deleted monitor object.

### Request

:::tabs
@tab CURL
```sh
curl -X DELETE "<TRIFLE_APP_URL>/api/v1/monitors/MONITOR_ID" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
monitor_id = "MONITOR_ID"
uri = URI("#{base}/api/v1/monitors/#{monitor_id}")

req = Net::HTTP::Delete.new(uri)
req["Authorization"] = "Bearer #{token}"

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.request(req)
end

puts res.code
puts res.body
```

@tab Elixir
```elixir
base = System.fetch_env!("TRIFLE_APP_URL")
token = System.fetch_env!("TRIFLE_TOKEN")
monitor_id = "MONITOR_ID"
url = "#{base}/api/v1/monitors/#{monitor_id}"

headers = [
  {'authorization', to_charlist("Bearer " <> token)}
]

:inets.start()
:ssl.start()
{:ok, {{_, status, _}, _resp_headers, body}} =
  :httpc.request(:delete, {String.to_charlist(url), headers}, [], [])

IO.puts(status)
IO.puts(body)
```

@tab Node.js
```js
const base = process.env.TRIFLE_APP_URL;
const token = process.env.TRIFLE_TOKEN;
const monitorId = "MONITOR_ID";

const res = await fetch(`${base}/api/v1/monitors/${monitorId}`, {
  method: "DELETE",
  headers: { Authorization: `Bearer ${token}` },
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]
monitor_id = "MONITOR_ID"

resp = requests.delete(
  f"{base}/api/v1/monitors/{monitor_id}",
  headers={"Authorization": f"Bearer {token}"},
)

print(resp.status_code)
print(resp.json())
```

@tab PHP
```php
<?php
$base = getenv("TRIFLE_APP_URL");
$token = getenv("TRIFLE_TOKEN");
$monitorId = "MONITOR_ID";

$ch = curl_init("$base/api/v1/monitors/$monitorId");
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Authorization: Bearer $token"]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo $code . PHP_EOL;
echo $body;
```
:::
