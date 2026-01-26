---
title: Redis
description: Learn how to use the Redis driver.
nav_order: 3
---

# Redis Driver

The Redis driver stores counters in Redis hashes. It supports a configurable key prefix and optional system tracking.

## Example

```elixir
{:ok, conn} = Redix.start_link()

driver = Trifle.Stats.Driver.Redis.new(conn, "trfl")
config = Trifle.Stats.Configuration.configure(driver)

Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1}, config)
```

## Options

- `prefix` (default: "trfl") — key namespace
- `separator` (default: "::") — key separator for joined identifiers
- `system_tracking` (default: true) — track usage in a system key
