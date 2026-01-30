---
title: Custom
description: Classify values using explicit bucket boundaries.
nav_order: 1
---

# Custom

Custom designators use explicit bucket boundaries that you provide.

## `NewCustomDesignator(buckets []float64) CustomDesignator`

:::signature NewCustomDesignator(buckets []float64) CustomDesignator
buckets | []float64 | required |  | Bucket boundaries.
:::

## `Designate(value any) string`

:::signature Designate(value any) string
value | any | required |  | Numeric value to classify.
:::

## Example

```go
custom := TrifleStats.NewCustomDesignator([]float64{0, 10, 25, 50, 100})
bucket := custom.Designate(30)
// bucket == "50"
```
