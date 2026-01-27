---
title: Scan values
description: Learn how to retrieve Beamed values.
nav_order: 7
---

# Scan values

Scanning works only with Beamed values. The purpose is not to find matching values, but to find the status value that has been pinged. There is no `granularity` or `from` to `to` because we're trying to retrieve one value and one value only.

## `scan(key: String, **options)`

Use to retrieve last recived beam signal.

:::signature scan(key: String, **options) -> Hash
key | String | required |  | Identifier for metrics.
config | Trifle::Stats::Configuration | optional | `nil` | Instance of Configuration. Defaults to global configuration.
:::

## Example

:::tabs

@tab Scan

Here is an example how to get latest values for specific key.

```ruby
Trifle::Stats.scan(key: 'event::logs')
=> {:at=>[2021-01-25 16:22:16 +0200], :values=>[{"count"=>1, "duration"=>5, "lines"=>361}]}
```
:::

Thats it. Just a single value with a single timestamp indicating when the ping has been received last time.
