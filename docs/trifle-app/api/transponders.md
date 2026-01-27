---
title: /transponders
description: Create and manage expression transponders.
nav_order: 4
---

# /api/v1/transponders

Transponders let you transform metrics using expressions. Only expression transponders are supported right now.

:::callout note "Base URL"
Replace `<TRIFLE_APP_URL>` with `https://app.trifle.io` or your self-hosted URL.
:::

## Auth

`Authorization: Bearer <TOKEN>`

---

## GET /transponders

List expression-based transponders for the current source.

### Response fields

- `id`, `name`, `key`
- `type`, `config`, `enabled`, `order`
- `source_type`, `source_id`

### Request

:::tabs
@tab CURL
```sh
curl -s "<TRIFLE_APP_URL>/api/v1/transponders" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
uri = URI("#{base}/api/v1/transponders")

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
url = "#{base}/api/v1/transponders"

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

const res = await fetch(`${base}/api/v1/transponders`, {
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
  f"{base}/api/v1/transponders",
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

$ch = curl_init("$base/api/v1/transponders");
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
:::

---

## POST /transponders

Create a new expression transponder.

:::signature POST /api/v1/transponders
name | String | required |  | Display name.
key | String | required |  | Metric key to transform.
type | String | optional | `Trifle.Stats.Transponder.Expression` | Only expression transponders are supported.
config | Map | optional |  | Transponder config (see below). If omitted, you can send `paths`, `expression`, and `response_path` at the top level.
enabled | Boolean | optional | `true` | Toggle on/off.
order | Integer | optional | next | Display order.
:::

:::callout note "Config shortcuts"
- You can send `config` **or** top-level `paths`, `expression`, `response_path`.
:::

### Expression config

:::signature config
paths | Array<String> | required |  | Metric paths (assigned to a, b, c...).
expression | String | required |  | Math expression using variables a, b, c.
response_path | String | required |  | Where to store the computed result.
:::

### Request

:::tabs
@tab CURL Simple double
```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/transponders" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Double count",
    "key": "event::signup",
    "config": {
      "paths": ["count"],
      "expression": "a * 2",
      "response_path": "count_twice"
    }
  }'
```

@tab CURL Ratio
```sh
curl -X POST "<TRIFLE_APP_URL>/api/v1/transponders" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Success rate",
    "key": "event::signup",
    "paths": ["success", "count"],
    "expression": "a / b",
    "response_path": "success_rate"
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
uri = URI("#{base}/api/v1/transponders")

payload = {
  name: "Success rate",
  key: "event::signup",
  paths: ["success", "count"],
  expression: "a / b",
  response_path: "success_rate"
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
url = "#{base}/api/v1/transponders"

payload = %{
  "name" => "Success rate",
  "key" => "event::signup",
  "paths" => ["success", "count"],
  "expression" => "a / b",
  "response_path" => "success_rate"
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

const res = await fetch(`${base}/api/v1/transponders`, {
  method: "POST",
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    name: "Success rate",
    key: "event::signup",
    paths: ["success", "count"],
    expression: "a / b",
    response_path: "success_rate",
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
  "name": "Success rate",
  "key": "event::signup",
  "paths": ["success", "count"],
  "expression": "a / b",
  "response_path": "success_rate",
}

resp = requests.post(
  f"{base}/api/v1/transponders",
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
  "name" => "Success rate",
  "key" => "event::signup",
  "paths" => ["success", "count"],
  "expression" => "a / b",
  "response_path" => "success_rate",
];

$ch = curl_init("$base/api/v1/transponders");
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
}
```
:::

---

## PUT /transponders/:id

Update an existing transponder by id.

:::signature PUT /api/v1/transponders/:id
name | String | optional |  | Display name.
key | String | optional |  | Metric key to transform.
config | Map | optional |  | Transponder config (paths/expression/response_path).
enabled | Boolean | optional |  | Toggle on/off.
order | Integer | optional |  | Sort order.
:::

### Request

:::tabs
@tab CURL
```sh
curl -X PUT "<TRIFLE_APP_URL>/api/v1/transponders/TRANS_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{ "enabled": false }'
```

@tab Ruby
```ruby
require "net/http"
require "json"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
transponder_id = "TRANS_ID"
uri = URI("#{base}/api/v1/transponders/#{transponder_id}")

payload = { enabled: false }

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
transponder_id = "TRANS_ID"
url = "#{base}/api/v1/transponders/#{transponder_id}"

payload = %{"enabled" => false}

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
const transponderId = "TRANS_ID";

const res = await fetch(`${base}/api/v1/transponders/${transponderId}`, {
  method: "PUT",
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ enabled: false }),
});

console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
token = os.environ["TRIFLE_TOKEN"]
transponder_id = "TRANS_ID"

payload = {"enabled": False}

resp = requests.put(
  f"{base}/api/v1/transponders/{transponder_id}",
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
$transponderId = "TRANS_ID";

$payload = ["enabled" => false];

$ch = curl_init("$base/api/v1/transponders/$transponderId");
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

:::callout warn "No other types yet"
- If you pass a non-expression type, the API returns `422`.
:::

:::callout note "Variable mapping"
- `paths` are assigned in order: first path → `a`, second → `b`, third → `c`, etc.
- `response_path` can be nested (e.g. `metrics.rates.success`).
:::

---

## DELETE /transponders/:id

Delete a transponder by id. Returns the deleted transponder.

### Request

:::tabs
@tab CURL
```sh
curl -X DELETE "<TRIFLE_APP_URL>/api/v1/transponders/TRANS_ID" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
transponder_id = "TRANS_ID"
uri = URI("#{base}/api/v1/transponders/#{transponder_id}")

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
transponder_id = "TRANS_ID"
url = "#{base}/api/v1/transponders/#{transponder_id}"

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
const transponderId = "TRANS_ID";

const res = await fetch(`${base}/api/v1/transponders/${transponderId}`, {
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
transponder_id = "TRANS_ID"

resp = requests.delete(
  f"{base}/api/v1/transponders/{transponder_id}",
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
$transponderId = "TRANS_ID";

$ch = curl_init("$base/api/v1/transponders/$transponderId");
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
