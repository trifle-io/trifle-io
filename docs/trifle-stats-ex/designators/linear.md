---
title: Linear
description: Classify values using fixed linear steps.
nav_order: 2
---

# Linear

Linear designators map values into fixed-size steps.

:::signature Trifle.Stats.Designator.Linear.new
min | number | required |  | Lowest bucket boundary.
max | number | required |  | Highest bucket boundary.
step | number | required |  | Step size.
:::

:::signature Trifle.Stats.Designator.Linear.designate
designator | Trifle.Stats.Designator.Linear | required |  | Designator instance.
value | number | required |  | Value to classify.
:::

## Example

```elixir
linear = Trifle.Stats.Designator.Linear.new(0, 100, 10)

bucket = Trifle.Stats.Designator.Linear.designate(linear, 37)
# bucket == "40"

Trifle.Stats.track("latency", DateTime.utc_now(), %{bucket => 1})
```
