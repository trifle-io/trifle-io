---
title: Max
description: Find the maximum value in a series.
nav_order: 4
---

# Max

Use `AggregateMax` to compute the maximum for a numeric path.

## `AggregateMax(path string, slices int) []any`

:::signature AggregateMax(path string, slices int) []any
path | string | required |  | Dotted path to aggregate.
slices | int | optional | `1` | Number of equal slices.
:::

## Example

```go
series := TrifleStats.SeriesFromResult(result)
values := series.AggregateMax("events.duration", 1)
// values == []any{9.7}
```
