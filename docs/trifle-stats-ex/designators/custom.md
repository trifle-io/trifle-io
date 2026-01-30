---
title: Custom
description: Classify values using explicit bucket boundaries.
nav_order: 1
---

# Custom

Custom designators use explicit bucket boundaries that you provide.

:::signature Trifle.Stats.Designator.Custom.new
buckets | list(number) | required |  | Bucket boundaries.
:::

:::signature Trifle.Stats.Designator.Custom.designate
designator | Trifle.Stats.Designator.Custom | required |  | Designator instance.
value | number | required |  | Value to classify.
:::

## Example

```elixir
custom = Trifle.Stats.Designator.Custom.new([0, 10, 25, 50, 100])

bucket = Trifle.Stats.Designator.Custom.designate(custom, 30)
# bucket == "50"

Trifle.Stats.track("latency", DateTime.utc_now(), %{bucket => 1})
```
