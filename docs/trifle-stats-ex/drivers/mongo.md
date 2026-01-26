---
title: Mongo
description: Learn in depth about Mongo driver implementation.
nav_order: 4
---

# Mongo Driver

The MongoDB driver uses `mongodb_driver` and supports joined or separated identifiers plus optional TTL expiration.

## Setup

```elixir
{:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/trifle")

# Create collection + indexes
Trifle.Stats.Driver.Mongo.setup!(conn)

# Build driver
driver = Trifle.Stats.Driver.Mongo.new(conn)
```

## Custom options

```elixir
{:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/trifle")

# Custom collection + TTL
Trifle.Stats.Driver.Mongo.setup!(conn, "analytics_stats", :full, 86_400)

driver = Trifle.Stats.Driver.Mongo.new(
  conn,
  "analytics_stats",
  "::",
  1,
  :full,
  86_400
)
```

## Using with configuration

```elixir
config = Trifle.Stats.Configuration.configure(
  driver,
  driver_options: %{
    collection_name: "analytics_stats",
    joined_identifier: :partial,
    expire_after: 86_400
  }
)
```

## Interaction

```elixir
key = "event::logs"
at = DateTime.utc_now()

Trifle.Stats.track(key, at, %{count: 1}, config)
Trifle.Stats.values(key, at, at, "1d", config)
```
