---
title: Track values
description: Learn how to increment values.
nav_order: 1
---

# Track values

Tracking values runs `inc` on the driver. Every time you track a value, it will increment the metrics.

## `track(key=String, at=DateTime, values=Map, config=Trifle.Stats.Configuration)`
- `key` - string identifier for the metrics
- `at` - timestamp of the sample (in most cases current timestamp)
- `values` - map of values. Can contain only nested maps and numbers (Integer, Float). Any other type will cause an error.
- `config` - optional configuration variable of `Trifle.Stats.Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Track your first values

```elixir
Trifle.Stats.track('event::logs', DateTime.utc_now(), %{count: 1, duration: 2, lines: 241})
=> ...
```

Then do it few more times

```elixir
Trifle.Stats.track('event::logs', DateTime.utc_now(), %{count: 1, duration: 1, lines: 56})
=> ...
Trifle.Stats.track('event::logs', DateTime.utc_now(), %{count: 1, duration: 5, lines: 361})
=> ...
```

You can also store nested counters like

```elixir
Trifle.Stats.track('event::logs', DateTime.utc_now(), %{
  count: 1,
  duration: %{
    parsing: 21,
    compression: 8,
    upload: 1
  },
  lines: 25432754
})
```

## Get values

Retrieve your values for specific `range`. Adding increments above will return sum of all the values you've tracked.

```elixir
Trifle.Stats.values('event::logs', DateTime.utc_now, DateTime.utc_now, :day)
=> ...
```
