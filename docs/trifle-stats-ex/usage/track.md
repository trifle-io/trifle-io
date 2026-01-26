---
title: Track values
description: Learn how to increment values.
nav_order: 1
---

# Track values

`track/4` increments counters for all configured granularities.

:::signature Trifle.Stats.track
key | String | required | Metric key (e.g., `"event::logs"`).
at | DateTime | required | Timestamp of the sample.
values | map | required | Nested maps allowed, all leaf values must be numeric.
config | Trifle.Stats.Configuration | optional | Overrides global config.
:::

## Examples

:::tabs
@tab Basic
```elixir
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1, duration: 2, lines: 241})
```

@tab Multiple increments
```elixir
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1, duration: 1})
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1, duration: 5})
```

@tab Nested values
```elixir
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{
  count: 1,
  duration: 30,
  breakdown: %{ parse: 21, upload: 9 }
})
```
:::

## Verify values

```elixir
now = DateTime.utc_now()
Trifle.Stats.values("event::logs", now, now, "1d")
```
