---
title: /source
description: Inspect the current source (project/database).
nav_order: 5
---

# /api/v1/source

Returns metadata about the source bound to the token.

:::callout note "Base URL"
Replace `<TRIFLE_APP_URL>` with `https://app.trifle.io` or your self-hosted URL.
:::

## Auth

`Authorization: Bearer <TOKEN>`

## Request

:::tabs
@tab CURL
```sh
curl -s "<TRIFLE_APP_URL>/api/v1/source" \
  -H "Authorization: Bearer <TOKEN>"
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
token = ENV.fetch("TRIFLE_TOKEN")
uri = URI("#{base}/api/v1/source")

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
url = "#{base}/api/v1/source"

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

const res = await fetch(`${base}/api/v1/source`, {
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
  f"{base}/api/v1/source",
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

$ch = curl_init("$base/api/v1/source");
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Authorization: Bearer $token"]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo $code . PHP_EOL;
echo $body;
```
:::

## Response

:::signature 200 OK -> JSON
api_version | String | required |  | API version string.
server_version | String | required |  | App version string.
id | String | required |  | Source id (UUID as string).
type | String | required |  | `"project"` or `"database"`.
display_name | String | required |  | Human name for the source.
default_timeframe | String | required |  | Default timeframe label.
default_granularity | String | required |  | Default granularity (e.g. `1h`).
available_granularities | Array<String> | required |  | Allowed granularities.
time_zone | String | required |  | Time zone (e.g. `UTC`).
:::

:::tabs
@tab Database source
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

@tab Project source
```json
{
  "data": {
    "api_version": "v1",
    "server_version": "0.11.8",
    "id": "project-uuid",
    "type": "project",
    "display_name": "Growth API",
    "default_timeframe": "24h",
    "default_granularity": "1h",
    "available_granularities": ["1m", "5m", "1h", "1d"],
    "time_zone": "UTC"
  }
}
```
:::

:::callout note "Granularity rules"
- If `available_granularities` is empty, any valid granularity is accepted.
- Use this response to determine whether a token is `project` or `database` scoped.
:::
