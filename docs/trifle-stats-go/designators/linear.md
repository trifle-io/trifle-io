---
title: Linear
description: Classify values using fixed linear steps.
nav_order: 2
---

# Linear

Linear designators map values into fixed-size steps.

## `NewLinearDesignator(min, max float64, step int) LinearDesignator`

:::signature NewLinearDesignator(min, max float64, step int) LinearDesignator
min | float64 | required |  | Lowest bucket boundary.
max | float64 | required |  | Highest bucket boundary.
step | int | required |  | Step size.
:::

## `Designate(value any) string`

:::signature Designate(value any) string
value | any | required |  | Numeric value to classify.
:::

## Example

```go
linear := TrifleStats.NewLinearDesignator(0, 100, 10)
bucket := linear.Designate(37)
// bucket == "40"
```
