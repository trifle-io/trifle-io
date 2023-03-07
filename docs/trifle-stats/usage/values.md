---
title: Get values
description: Learn how to retrieve values.
nav_order: 100
---

# Get values

Getting values runs `get` on the driver.

## `values(key: String, from: Time, to: Time, range: Symbol, **options)`
- `key` - string identifier for the metrics
- `from` - timestamp you want to get values from
- `to` - timestamp you want to get values to
- `range` - specific range you want to get values in
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Using `from` and `to` gives you flexibility to exactly specify what data you are interested in.

Use `range` to specify _sensitivity_ of returned data (aka how many data points you want to get). For example if you're trying to get daily values for current a specific month, use `range: :day`. This will give you ~30 data points. If you need to increase your sensitivity for chart, you may use `range: :hour` which will give you ~30 * 24 data points.

The more data you're fetching, the slower the response time. Thats a trade-off you need to decide.

Here is an example how to get today values for specific key.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>3, "duration"=>8, "lines"=>658}]}
```

And here is another how to get daily values for a last 30 days for specific key.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now - 60 * 60 * 24 * 30, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0200, 2021-01-24 00:00:00 +0200, ...], values: [{"count"=>3, "duration"=>8, "lines"=>658}, {"count"=>1, "duration"=>3, "lines"=>311}, ...]}
```

> If you're integrating with Rails, don't forget you can use _things_ like `1.month.ago` or `Time.zone.now - 30.days`.
