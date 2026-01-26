---
title: /dashboards
description: Create and manage dashboards.
nav_order: 2
---

# /api/v1/dashboards

Dashboards are JSON payloads that define widgets, layout, and defaults.

:::callout note "Base URL"
Replace `<TRIFLE_APP_URL>` with `https://app.trifle.io` or your self-hosted URL.
:::

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

:::callout note "Sources in self-hosted"
- If you self-host with projects disabled, only `source_type: "database"` is valid.
:::

---

## GET /dashboards

List dashboards visible to the organization bound to the token.

### Request

:::tabs
@tab CURL
```sh
curl -s "<TRIFLE_APP_URL>/api/v1/dashboards" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
uri = URI("#{base}/api/v1/dashboards")

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
url = "#{base}/api/v1/dashboards"

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

const res = await fetch(`${base}/api/v1/dashboards`, {
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
  f"{base}/api/v1/dashboards",
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

$ch = curl_init("$base/api/v1/dashboards");
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
      "id": "dashboard-uuid",
      "name": "Signup Overview",
      "key": "event::signup",
      "visibility": true,
      "locked": false,
      "source_type": "database",
      "source_id": "db-uuid",
      "organization_id": "org-uuid",
      "user_id": "user-uuid",
      "database_id": "db-uuid",
      "group_id": null,
      "position": 1,
      "default_timeframe": "24h",
      "default_granularity": "1h",
      "payload": { "grid": [] },
      "segments": [],
      "inserted_at": "2026-01-24T12:00:00Z",
      "updated_at": "2026-01-24T12:00:00Z"
    }
  ]
}
```
:::

---

## GET /dashboards/:id

Fetch a dashboard by id (visible dashboards only).

### Request

:::tabs
@tab CURL
```sh
curl -s "<TRIFLE_APP_URL>/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
dashboard_id = "DASHBOARD_ID"
uri = URI("#{base}/api/v1/dashboards/#{dashboard_id}")

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
dashboard_id = "DASHBOARD_ID"
url = "#{base}/api/v1/dashboards/#{dashboard_id}"

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
const dashboardId = "DASHBOARD_ID";

const res = await fetch(`${base}/api/v1/dashboards/${dashboardId}`, {
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
dashboard_id = "DASHBOARD_ID"

resp = requests.get(
  f"{base}/api/v1/dashboards/{dashboard_id}",
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
$dashboardId = "DASHBOARD_ID";

$ch = curl_init("$base/api/v1/dashboards/$dashboardId");
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

Returns the same dashboard object as the list endpoint, wrapped in `data`.

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

:::callout note "Source shortcuts"
- You can send `source` instead of `source_type`/`source_id`.
- For database dashboards, `database_id` is accepted and will map to the source.
:::

### Widget examples

:::tabs
@tab KPI
```json
{ "id": "kpi-1", "type": "kpi", "title": "Total", "path": "count", "function": "sum", "subtype": "number", "size": "l" }
```

@tab KPI Goal
```json
{ "id": "kpi-goal", "type": "kpi", "title": "ARR Target", "path": "revenue", "function": "sum", "subtype": "goal", "goal_target": 100000, "goal_progress": true, "goal_invert": false, "size": "l" }
```

@tab Timeseries
```json
{ "id": "ts-1", "type": "timeseries", "title": "Trend", "paths": ["count", "failed"], "chart_type": "area", "stacked": true, "legend": true }
```

@tab Timeseries Normalized
```json
{ "id": "ts-2", "type": "timeseries", "title": "Mix", "paths": ["organic", "paid", "referral"], "chart_type": "line", "normalized": true, "legend": true, "y_label": "%" }
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
{ "id": "dist-1", "type": "distribution", "title": "Latency Dist", "paths": ["duration"], "mode": "2d", "designators": { "horizontal": { "type": "linear", "min": 0, "max": 1200, "step": 100 } } }
```
:::

Want more patterns? See the [Widget Cookbook](/trifle-app/guides/widgets).

### Request

Full dashboard:

:::tabs
@tab CURL
```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/dashboards" \
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

@tab CURL Minimal
```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/dashboards" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Quick Start",
    "key": "event::signup",
    "source": { "type": "database", "id": "db-uuid" }
  }'
```

@tab CURL (source map)
```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/dashboards" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Revenue Mix",
    "key": "billing.revenue",
    "source": { "type": "database", "id": "db-uuid" },
    "default_timeframe": "7d",
    "default_granularity": "1d",
    "payload": {
      "grid": [
        { "id": "kpi-1", "type": "kpi", "title": "Total", "path": "amount", "function": "sum", "x": 0, "y": 0, "w": 3, "h": 2 },
        { "id": "cat-1", "type": "category", "title": "By Plan", "path": "plan.*", "chart_type": "donut", "x": 3, "y": 0, "w": 3, "h": 2 },
        { "id": "ts-1", "type": "timeseries", "title": "Trend", "paths": ["amount"], "chart_type": "line", "legend": false, "x": 6, "y": 0, "w": 6, "h": 4 }
      ]
    }
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
uri = URI("#{base}/api/v1/dashboards")

payload = {
  name: "Quick Start",
  key: "event::signup",
  source: { type: "database", id: "db-uuid" }
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
url = "#{base}/api/v1/dashboards"

payload = %{
  "name" => "Quick Start",
  "key" => "event::signup",
  "source" => %{"type" => "database", "id" => "db-uuid"}
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

const res = await fetch(`${base}/api/v1/dashboards`, {
  method: "POST",
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    name: "Quick Start",
    key: "event::signup",
    source: { type: "database", id: "db-uuid" },
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
  "name": "Quick Start",
  "key": "event::signup",
  "source": {"type": "database", "id": "db-uuid"},
}

resp = requests.post(
  f"{base}/api/v1/dashboards",
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
  "name" => "Quick Start",
  "key" => "event::signup",
  "source" => ["type" => "database", "id" => "db-uuid"],
];

$ch = curl_init("$base/api/v1/dashboards");
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
    "id": "dashboard-uuid",
    "name": "Signup Overview",
    "key": "event::signup",
    "visibility": true,
    "locked": false,
    "source_type": "database",
    "source_id": "db-uuid",
    "organization_id": "org-uuid",
    "user_id": "user-uuid",
    "database_id": "db-uuid",
    "group_id": null,
    "position": 1,
    "default_timeframe": "24h",
    "default_granularity": "1h",
    "payload": { "grid": [] },
    "segments": [],
    "inserted_at": "2026-01-24T12:00:00Z",
    "updated_at": "2026-01-24T12:00:00Z"
  }
}
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
curl -X PUT "<TRIFLE_APP_URL>/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "visibility": true,
    "default_timeframe": "7d"
  }'
```

@tab CURL (update grid)
```sh
curl -X PUT "<TRIFLE_APP_URL>/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "payload": {
      "grid": [
        { "id": "kpi-1", "type": "kpi", "title": "Total", "path": "count", "function": "sum", "x": 0, "y": 0, "w": 4, "h": 3 }
      ]
    }
  }'
```

@tab Ruby
```ruby
require "net/http"
require "json"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
dashboard_id = "DASHBOARD_ID"
uri = URI("#{base}/api/v1/dashboards/#{dashboard_id}")

payload = { visibility: true, default_timeframe: "7d" }

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
dashboard_id = "DASHBOARD_ID"
url = "#{base}/api/v1/dashboards/#{dashboard_id}"

payload = %{"visibility" => true, "default_timeframe" => "7d"}

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
const dashboardId = "DASHBOARD_ID";

const res = await fetch(`${base}/api/v1/dashboards/${dashboardId}`, {
  method: "PUT",
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ visibility: true, default_timeframe: "7d" }),
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]
dashboard_id = "DASHBOARD_ID"

payload = {"visibility": True, "default_timeframe": "7d"}

resp = requests.put(
  f"{base}/api/v1/dashboards/{dashboard_id}",
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
$dashboardId = "DASHBOARD_ID";

$payload = ["visibility" => true, "default_timeframe" => "7d"];

$ch = curl_init("$base/api/v1/dashboards/$dashboardId");
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

## DELETE /dashboards/:id

Delete a dashboard by id. Returns the deleted dashboard object.

### Request

:::tabs
@tab CURL
```sh
curl -X DELETE "<TRIFLE_APP_URL>/api/v1/dashboards/DASHBOARD_ID" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
dashboard_id = "DASHBOARD_ID"
uri = URI("#{base}/api/v1/dashboards/#{dashboard_id}")

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
dashboard_id = "DASHBOARD_ID"
url = "#{base}/api/v1/dashboards/#{dashboard_id}"

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
const dashboardId = "DASHBOARD_ID";

const res = await fetch(`${base}/api/v1/dashboards/${dashboardId}`, {
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
dashboard_id = "DASHBOARD_ID"

resp = requests.delete(
  f"{base}/api/v1/dashboards/{dashboard_id}",
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
$dashboardId = "DASHBOARD_ID";

$ch = curl_init("$base/api/v1/dashboards/$dashboardId");
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
