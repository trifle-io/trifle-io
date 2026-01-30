---
title: Min
description: Find the minimum value in a series.
nav_order: 3
---

# Min

Use `AggregateMin` to compute the minimum for a numeric path.

## `AggregateMin(path string, slices int) []any`

:::signature AggregateMin(path string, slices int) []any
path | string | required |  | Dotted path to aggregate.
slices | int | optional | `1` | Number of equal slices.
:::

## Example

```go
series := TrifleStats.SeriesFromResult(result)
values := series.AggregateMin("events.duration", 1)
// values == []any{1.2}
```
