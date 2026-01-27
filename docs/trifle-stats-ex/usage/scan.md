---
title: Scan status
description: Learn how to read latest status pings.
nav_order: 4
---

# Scan status

`scan/2` retrieves the latest status for a key (written by `beam/4`).

:::signature Trifle.Stats.scan
key | String | required |  | Status key.
config | Trifle.Stats.Configuration | optional | `nil` | Overrides global config.
returns | {:ok, map} | required |  | Latest status payload.
:::

## Example

```elixir
Trifle.Stats.beam("worker::sync", DateTime.utc_now(), %{count: 1, status: 200})
Trifle.Stats.scan("worker::sync")
# => {:ok, %{...}}
```
