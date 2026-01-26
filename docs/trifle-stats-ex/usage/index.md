---
title: Usage
description: Learn how to use Trifle.Stats DSL.
nav_order: 4
---

# Usage

`Trifle.Stats` provides a small, consistent API:

- `track/4` — increment values
- `assert/4` — set values
- `values/5` — retrieve time-series values
- `beam/4` and `scan/2` — store and read status pings

## Incrementing data

```elixir
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1, duration: 2.1})
```

## Reading data

```elixir
now = DateTime.utc_now()
from = DateTime.add(now, -30, :day)

Trifle.Stats.values("event::logs", from, now, "1d")
# => %{at: [...], values: [%{"count" => 1, "duration" => 2.1}, ...]}
```

## Averages and derived metrics

Trifle.Stats doesn’t compute averages for you. Track both a value and a counter:

```elixir
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1, duration: 250})
```

Later you can compute `avg_duration = duration / count` in your code.

## Granularity format

Granularities are **strings** like:

- `"1m"`, `"5m"`
- `"1h"`
- `"1d"`
- `"1w"`
- `"1mo"`, `"1q"`, `"1y"`

Use the same format in `track_granularities` and `values/5`.
