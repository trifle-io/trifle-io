---
title: Beam status
description: Learn how to send status pings.
nav_order: 3
---

# Beam status

`beam/4` stores status-style metrics (latest value per key).

:::signature Trifle.Stats.beam
key | String | required |  | Status key.
at | DateTime | required |  | Timestamp of the ping.
values | map | required |  | Payload to store.
config | Trifle.Stats.Configuration | optional | `nil` | Overrides global config.
:::

## Example

```elixir
Trifle.Stats.beam("worker::sync", DateTime.utc_now(), %{count: 1, status: 200})
```

You can read the latest status with `scan/2`.
