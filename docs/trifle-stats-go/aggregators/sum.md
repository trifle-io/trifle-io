---
title: Sum
description: Sum values across a series.
nav_order: 1
---

# Sum

Use `AggregateSum` to compute the total for a numeric path.

## `AggregateSum(path string, slices int) []any`

:::signature AggregateSum(path string, slices int) []any
path | string | required |  | Dotted path to aggregate.
slices | int | optional | `1` | Number of equal slices.
:::

## Example

```go
series := TrifleStats.SeriesFromResult(result)
values := series.AggregateSum("events.count", 1)
// values == []any{85}
```
