---
title: Transponders
description: Learn how to add calculated values into a series.
nav_order: 7
---

# Transponders

Transponders add calculated values into a series. They return a new `Trifle.Stats.Series`, so you can chain multiple transformations before formatting or aggregating.

> Note: `path` is a list of keys joined by dot. Example: `"orders.shipped.count"` maps to `%{"orders" => %{"shipped" => %{"count" => ...}}}`.

## Arithmetic

:::signature Trifle.Stats.Series.transform_add
series | Trifle.Stats.Series | required |  | Series wrapper.
left_path | String | required |  | Dot path to left operand.
right_path | String | required |  | Dot path to right operand.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_subtract
series | Trifle.Stats.Series | required |  | Series wrapper.
left_path | String | required |  | Dot path to left operand.
right_path | String | required |  | Dot path to right operand.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_multiply
series | Trifle.Stats.Series | required |  | Series wrapper.
left_path | String | required |  | Dot path to left operand.
right_path | String | required |  | Dot path to right operand.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_divide
series | Trifle.Stats.Series | required |  | Series wrapper.
left_path | String | required |  | Dot path to left operand.
right_path | String | required |  | Dot path to right operand.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

## Multi-path

:::signature Trifle.Stats.Series.transform_sum
series | Trifle.Stats.Series | required |  | Series wrapper.
paths | list(String) | required |  | Dot paths to include in the calculation.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_min
series | Trifle.Stats.Series | required |  | Series wrapper.
paths | list(String) | required |  | Dot paths to include in the calculation.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_max
series | Trifle.Stats.Series | required |  | Series wrapper.
paths | list(String) | required |  | Dot paths to include in the calculation.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_mean
series | Trifle.Stats.Series | required |  | Series wrapper.
paths | list(String) | required |  | Dot paths to include in the calculation.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

## Ratio and deviation

:::signature Trifle.Stats.Series.transform_ratio
series | Trifle.Stats.Series | required |  | Series wrapper.
sample_path | String | required |  | Dot path to the numerator.
total_path | String | required |  | Dot path to the denominator.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

:::signature Trifle.Stats.Series.transform_stddev
series | Trifle.Stats.Series | required |  | Series wrapper.
sum_path | String | required |  | Dot path to sum values.
count_path | String | required |  | Dot path to count values.
square_path | String | required |  | Dot path to sum of squares.
response_path | String | required |  | Dot path where the result is stored.
slices | integer | optional | 1 | Number of slices.
:::

## Examples

:::tabs
@tab Average
```elixir
now = DateTime.utc_now()

series = Trifle.Stats.Series.new(%{
  at: [DateTime.add(now, -60, :second), now],
  values: [
    %{events: %{count: 2, sum: 40}},
    %{events: %{count: 3, sum: 60}}
  ]
})

series
|> Trifle.Stats.Series.transform_divide("events.sum", "events.count", "events.avg")
|> Trifle.Stats.Series.aggregate_mean("events.avg")
```

@tab Ratio
```elixir
series
|> Trifle.Stats.Series.transform_ratio("events.success", "events.total", "events.success_rate")
|> Trifle.Stats.Series.format_timeline("events.success_rate")
```

@tab Stddev
```elixir
series
|> Trifle.Stats.Series.transform_stddev(
  "events.sum",
  "events.count",
  "events.square",
  "events.stddev"
)
|> Trifle.Stats.Series.format_timeline("events.stddev")
```
:::
