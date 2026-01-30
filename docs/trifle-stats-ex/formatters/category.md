---
title: Category
description: Format series into category totals.
nav_order: 2
---

# Category

Category formatter groups values into category totals, useful for histograms.

:::signature Trifle.Stats.Series.format_category
series | Trifle.Stats.Series | required |  | Series wrapper.
path | String | required |  | Dot path to numeric values.
slices | integer | optional | 1 | Number of slices.
transform_fn | function | optional | `nil` | Optional `fn key, value -> {key, value} | value end` mapper.
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

series |> Trifle.Stats.Series.format_category("events.*")
```
