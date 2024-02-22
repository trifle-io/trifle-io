---
title: Get values
description: Learn how to retrieve values.
nav_order: 100
---

# Get values

Getting values runs `get` on the driver.

## `values(key=String, from=DateTime, to=DateTime, range=Atom, config=Trifle.Stats.Configuration)`
- `key` - string identifier for the metrics
- `from` - timestamp you want to get values from
- `to` - timestamp you want to get values to
- `range` - specific range you want to get values in
- `config` - optional configuration variable of `Trifle.Stats.Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Using `from` and `to` gives you flexibility to exactly specify what data you are interested in.

Use `range` to specify _sensitivity_ of returned data (aka how many data points you want to get). For example if you're trying to get daily values for current a specific month, use `:day` as a range. This will give you ~30 data points. If you need to increase your sensitivity for chart, you may use `:hour` as a range which will give you ~30 * 24 data points.

The more data you're fetching, the slower the response time. Thats a trade-off you need to decide.

Here is an example how to get today values for specific key.

```elixir
Trifle.Stats.values('event::logs', DateTime.utc_now(), DateTime.utc_now(), :day)
=> ...
```

And here is another how to get daily values for a last 30 days for specific key.

```elixir
now = DateTime.utc_now()
before = DateTime.add(now, -30, :day, Tzdata.TimeZoneDatabase)
Trifle.Stats.values('event::logs', before, now, :day)
=> ...
```
