---
title: Getting Started
description: Learn how to start using Trifle.Stats.
nav_order: 3
---

# Getting Started

This guide uses the **Process driver** so you can try Trifle.Stats without external services. Swap the driver later (Mongo, Postgres, Redis, SQLite) once you’re ready.

## 1) Install and configure

```elixir
{:ok, pid} = Trifle.Stats.Driver.Process.start_link()
driver = Trifle.Stats.Driver.Process.new(pid)

Trifle.Stats.configure(
  driver: driver,
  time_zone: "UTC",
  track_granularities: ["1h", "1d"],
  beginning_of_week: :monday
)
```

## 2) Track data

```elixir
Trifle.Stats.track("event::uploads", DateTime.utc_now(), %{count: 1, duration: 3})
Trifle.Stats.track("event::uploads", DateTime.utc_now(), %{count: 1, duration: 5})
```

Nested maps are allowed as long as all leaf values are numeric.

```elixir
Trifle.Stats.track("event::uploads", DateTime.utc_now(), %{
  count: 1,
  duration: 8,
  breakdown: %{ parse: 2, upload: 6 }
})
```

## 3) Read values

Use a granularity string like `"1h"`, `"1d"`, or `"1w"`.

```elixir
now = DateTime.utc_now()
from = DateTime.add(now, -24, :hour)

Trifle.Stats.values("event::uploads", from, now, "1h")
# => %{at: [...], values: [...]}
```

## 4) Status-style metrics (beam/scan)

```elixir
Trifle.Stats.beam("worker::sync", DateTime.utc_now(), %{count: 1})
Trifle.Stats.scan("worker::sync")
# => {:ok, %{...}}
```

:::callout note "Process driver is in-memory"
All data is lost when the process exits. Use a database driver for persistence.
:::

## Next steps

- [Configuration](/trifle-stats-ex/configuration)
- [Usage](/trifle-stats-ex/usage)
- [Drivers](/trifle-stats-ex/drivers)
