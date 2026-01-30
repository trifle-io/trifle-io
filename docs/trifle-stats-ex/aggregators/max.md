---
title: Max
description: Find maximum values across a series.
nav_order: 2
---

# Max

Use `aggregate_max/3` to compute maximum values for a numeric path.

:::signature Trifle.Stats.Series.aggregate_max
series | Trifle.Stats.Series | required |  | Series wrapper.
path | String | required |  | Dot path to numeric values.
slices | integer | optional | 1 | Number of slices.
:::

## Example

```elixir
series |> Trifle.Stats.Series.aggregate_max("events.duration")
```
