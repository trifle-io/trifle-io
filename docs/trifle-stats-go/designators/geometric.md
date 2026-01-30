---
title: Geometric
description: Classify values using logarithmic buckets.
nav_order: 3
---

# Geometric

Geometric designators classify values into logarithmic buckets. They are useful for latency or size ranges that span orders of magnitude.

## `NewGeometricDesignator(min, max float64) GeometricDesignator`

:::signature NewGeometricDesignator(min, max float64) GeometricDesignator
min | float64 | required |  | Minimum value.
max | float64 | required |  | Maximum value.
:::

## `Designate(value any) string`

:::signature Designate(value any) string
value | any | required |  | Numeric value to classify.
:::

## Example

```go
geometric := TrifleStats.NewGeometricDesignator(1, 200)
bucket := geometric.Designate(125)
```
