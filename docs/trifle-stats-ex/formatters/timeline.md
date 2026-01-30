---
title: Timeline
description: Format series into timeline points.
nav_order: 1
---

# Timeline

Timeline formatter maps each timestamp to a value, returning points that are easy to chart.

:::signature Trifle.Stats.Series.format_timeline
series | Trifle.Stats.Series | required |  | Series wrapper.
path | String | required |  | Dot path to numeric values.
slices | integer | optional | 1 | Number of slices.
transform_fn | function | optional | `nil` | Optional `fn at, value -> any end` formatter.
:::

## Example

```elixir
now = DateTime.utc_now()

series = Trifle.Stats.Series.new(%{
  at: [DateTime.add(now, -60, :second), now],
  values: [
    %{events: %{count: 2, duration: 5}},
    %{events: %{count: 3, duration: 7}}
  ]
})

series |> Trifle.Stats.Series.format_timeline("events.count")
```
