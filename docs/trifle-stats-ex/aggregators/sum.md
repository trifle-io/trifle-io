---
title: Sum
description: Sum values across a series.
nav_order: 3
---

# Sum

Use `aggregate_sum/3` to compute the total for a numeric path.

:::signature Trifle.Stats.Series.aggregate_sum
series | Trifle.Stats.Series | required |  | Series wrapper.
path | String | required |  | Dot path to numeric values.
slices | integer | optional | 1 | Number of slices.
:::

## Example

```elixir
series |> Trifle.Stats.Series.aggregate_sum("events.count")
```
