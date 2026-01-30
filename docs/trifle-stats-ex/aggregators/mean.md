---
title: Mean
description: Average values across a series.
nav_order: 4
---

# Mean

Use `aggregate_mean/3` to compute the mean for a numeric path.

:::signature Trifle.Stats.Series.aggregate_mean
series | Trifle.Stats.Series | required |  | Series wrapper.
path | String | required |  | Dot path to numeric values.
slices | integer | optional | 1 | Number of slices.
:::

## Example

```elixir
series |> Trifle.Stats.Series.aggregate_mean("events.duration")
```
