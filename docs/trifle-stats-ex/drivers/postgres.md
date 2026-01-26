---
title: Postgres
description: Learn how to use the PostgreSQL driver.
nav_order: 5
---

# Postgres Driver

The Postgres driver stores metrics in JSONB columns and supports joined or separated identifier modes.

## Setup

```elixir
{:ok, conn} = Postgrex.start_link(
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  database: "trifle_stats"
)

# Create tables + indexes
Trifle.Stats.Driver.Postgres.setup!(conn)

# Build driver
driver = Trifle.Stats.Driver.Postgres.new(conn)
```

## Options

- `table_name` (default: "trifle_stats")
- `ping_table_name` (default: "trifle_stats_ping")
- `joined_identifier` (`:full`, `:partial`, or `nil`)
- `system_tracking` (default: true)

## Example usage

```elixir
config = Trifle.Stats.Configuration.configure(driver)
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1}, config)
```
