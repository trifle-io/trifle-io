---
title: /health
description: Health check for the Trifle API.
nav_order: 6
---

# /api/v1/health

Quick health check. No auth required.

:::callout note "Base URL"
Replace `<TRIFLE_APP_URL>` with `https://app.trifle.io` or your self-hosted URL.
:::

## Request

:::tabs
@tab CURL
```sh
curl -s <TRIFLE_APP_URL>/api/v1/health
```

@tab HTTPie
```sh
http GET <TRIFLE_APP_URL>/api/v1/health
```

@tab Ruby
```ruby
require "net/http"

base = ENV.fetch("TRIFLE_APP_URL")
uri = URI("#{base}/api/v1/health")

res = Net::HTTP.get_response(uri)
puts res.code
puts res.body
```

@tab Elixir
```elixir
base = System.fetch_env!("TRIFLE_APP_URL")
url = "#{base}/api/v1/health"

:inets.start()
:ssl.start()
{:ok, {{_, status, _}, _resp_headers, body}} =
  :httpc.request(:get, {String.to_charlist(url), []}, [], [])

IO.puts(status)
IO.puts(body)
```

@tab Node.js
```js
const base = process.env.TRIFLE_APP_URL;
const res = await fetch(`${base}/api/v1/health`);
console.log(await res.json());
```

@tab Python
```python
import os
import requests

base = os.environ["TRIFLE_APP_URL"]
resp = requests.get(f"{base}/api/v1/health")
print(resp.status_code)
print(resp.json())
```

@tab PHP
```php
<?php
$base = getenv("TRIFLE_APP_URL");
$ch = curl_init("$base/api/v1/health");
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
status | String | required |  | Always `"ok"`.
timestamp | ISO8601 | required |  | Server time in UTC.
api_version | String | required |  | API version.
server_version | String | required |  | Trifle app version.
:::

:::tabs
@tab Body
```json
{
  "status": "ok",
  "timestamp": "2026-01-17T12:00:00Z",
  "api_version": "v1",
  "server_version": "0.11.8"
}
```
:::
