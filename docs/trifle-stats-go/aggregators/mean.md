---
title: Mean
description: Compute the mean across a series.
nav_order: 2
---

# Mean

Use `AggregateMean` to compute the average for a numeric path.

## `AggregateMean(path string, slices int) []any`

:::signature AggregateMean(path string, slices int) []any
path | string | required |  | Dotted path to aggregate.
slices | int | optional | `1` | Number of equal slices.
:::

## Example

```go
series := TrifleStats.SeriesFromResult(result)
values := series.AggregateMean("events.duration", 1)
// values == []any{4.2}
```
