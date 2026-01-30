---
title: Min
description: Find minimum values across a series.
nav_order: 1
---

# Min

Use `aggregate_min/3` to compute minimum values for a numeric path.

:::signature Trifle.Stats.Series.aggregate_min
series | Trifle.Stats.Series | required |  | Series wrapper.
path | String | required |  | Dot path to numeric values.
slices | integer | optional | 1 | Number of slices.
:::

## Example

```elixir
series |> Trifle.Stats.Series.aggregate_min("events.duration")
```
