---
title: Configuration
description: Configure Trifle Stats (Go) with the SQLite driver.
nav_order: 2
---

# Configuration

Trifle Stats for Go uses a `Config` struct. Start with `DefaultConfig()` and override what you need.

```go
cfg := TrifleStats.DefaultConfig()
cfg.Driver = driver
cfg.TimeZone = "UTC"
cfg.BeginningOfWeek = time.Monday
cfg.Granularities = []string{"1m", "1h", "1d"}
cfg.Separator = "::"
cfg.JoinedIdentifier = TrifleStats.JoinedFull
```

## Options

- `Driver` (required) — a driver instance (SQLite driver below).
- `TimeZone` — IANA timezone string (default: `"GMT"`).
- `BeginningOfWeek` — week boundary for `1w` buckets (default: `time.Monday`).
- `Granularities` — list of granularities (default: all standard granularities).
- `Separator` — key separator for joined identifiers (default: `"::"`).
- `JoinedIdentifier` — `JoinedFull`, `JoinedPartial`, or `JoinedSeparated`.

## Identifier modes

- **JoinedFull**: a single `key` column including `prefix::key::granularity::unix`.
- **JoinedPartial**: `key` + `at` columns.
- **JoinedSeparated**: `key` + `granularity` + `at` columns.
