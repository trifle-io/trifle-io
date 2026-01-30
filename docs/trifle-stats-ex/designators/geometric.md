---
title: Geometric
description: Classify values using logarithmic buckets.
nav_order: 3
---

# Geometric

Geometric designators classify values into logarithmic buckets. They are useful for latency or size ranges that span orders of magnitude.

:::signature Trifle.Stats.Designator.Geometric.new
min | number | required |  | Minimum value.
max | number | required |  | Maximum value.
:::

:::signature Trifle.Stats.Designator.Geometric.designate
designator | Trifle.Stats.Designator.Geometric | required |  | Designator instance.
value | number | required |  | Value to classify.
:::

## Example

```elixir
geometric = Trifle.Stats.Designator.Geometric.new(1, 200)

bucket = Trifle.Stats.Designator.Geometric.designate(geometric, 125)

Trifle.Stats.track("payload", DateTime.utc_now(), %{bucket => 1})
```
