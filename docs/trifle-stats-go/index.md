---
title: Trifle Stats
nav_order: 5
svg: M7.5 14.25v2.25m3-4.5v4.5m3-6.75v6.75m3-9v9M6 20.25h12A2.25 2.25 0 0020.25 18V6A2.25 2.25 0 0018 3.75H6A2.25 2.25 0 003.75 6v12A2.25 2.25 0 006 20.25z
lang: <circle cx="40" cy="64" r="24" fill="none" stroke="currentColor" stroke-width="10"></circle><path d="M40 64h16v12" fill="none" stroke="currentColor" stroke-width="10" stroke-linecap="round" stroke-linejoin="round"></path><circle cx="92" cy="64" r="18" fill="none" stroke="currentColor" stroke-width="10"></circle>
---

# Trifle Stats

`trifle_stats_go` is a Go library for tracking time-series metrics with a SQLite driver.

## What it does

- Tracks counters and numeric payloads per key.
- Reads back series by timeframe and granularity.
- Supports SQLite as the storage backend.
- Includes aggregators, formatters, and transponders for post-processing series.

## Quick example

```go
package main

import (
  "database/sql"
  "time"

  _ "modernc.org/sqlite"
  TrifleStats "github.com/trifle-io/trifle_stats_go"
)

func main() {
  db, _ := sql.Open("sqlite", "file:stats.db?cache=shared&mode=rwc")
  driver := TrifleStats.NewSQLiteDriver(db, "trifle_stats", TrifleStats.JoinedFull)
  _ = driver.Setup()

  cfg := TrifleStats.DefaultConfig()
  cfg.Driver = driver
  cfg.TimeZone = "UTC"
  cfg.Granularities = []string{"1h", "1d"}

  _ = TrifleStats.Track(cfg, "event::uploads", time.Now().UTC(), map[string]any{"count": 1})

  from := time.Now().UTC().Add(-24 * time.Hour)
  _ = TrifleStats.Values(cfg, "event::uploads", from, time.Now().UTC(), "1h", false)
}
```

## What to expect

- `Values` returns `{ at: [...], values: [...] }` for the bucketed series.
- Payloads can be nested maps; leaf values must be numeric.
- The SQLite driver uses JSON1 functions for in-place updates.

## Next steps

- [Installation](/trifle-stats-go/installation)
- [Configuration](/trifle-stats-go/configuration)
- [Getting Started](/trifle-stats-go/getting_started)
- [Usage](/trifle-stats-go/usage)
- [Drivers](/trifle-stats-go/drivers)
- [Designators](/trifle-stats-go/designators)
- [Transponders](/trifle-stats-go/transponders)
- [Aggregators](/trifle-stats-go/aggregators)
- [Formatters](/trifle-stats-go/formatters)
