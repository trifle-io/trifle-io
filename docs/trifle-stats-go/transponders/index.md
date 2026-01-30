---
title: Transponders
description: Add derived values into a series.
nav_order: 7
---

# Transponders

Transponders calculate derived values and write them back into the series. Each method returns an updated `Series`, so you can chain multiple transforms.

```go
series := TrifleStats.SeriesFromResult(result)
series = series.TransformRatio("success", "count", "success_rate")
series = series.TransformMean([]string{"p50", "p95"}, "latency.avg")
```

:::callout note "Paths"
Transponders use dotted paths (`events.count`) to locate numeric values inside each row.
:::

:::callout note "Response names"
If `response` is empty, each transform uses a default label (`sum`, `mean`, `ratio`, etc).
:::

:::callout note "Missing values"
If a path is missing or non-numeric in a row, that row is left unchanged for the transform.
:::

## Binary transforms

### `TransformAdd(left, right, response string) Series`

:::signature TransformAdd(left, right, response string) Series
left | string | required |  | Left path.
right | string | required |  | Right path.
response | string | optional | `add` | Output path for the result.
:::

Adds two paths and stores the result at `response`.

```go
series = series.TransformAdd("a", "b", "sum")
```

### `TransformSubtract(left, right, response string) Series`

:::signature TransformSubtract(left, right, response string) Series
left | string | required |  | Left path.
right | string | required |  | Right path.
response | string | optional | `subtract` | Output path for the result.
:::

Subtracts `right` from `left`.

```go
series = series.TransformSubtract("a", "b", "diff")
```

### `TransformMultiply(left, right, response string) Series`

:::signature TransformMultiply(left, right, response string) Series
left | string | required |  | Left path.
right | string | required |  | Right path.
response | string | optional | `multiply` | Output path for the result.
:::

Multiplies two paths.

```go
series = series.TransformMultiply("a", "b", "product")
```

### `TransformDivide(left, right, response string) Series`

:::signature TransformDivide(left, right, response string) Series
left | string | required |  | Left path.
right | string | required |  | Right path.
response | string | optional | `divide` | Output path for the result.
:::

Divides `left` by `right`. Division by zero yields `0`.

```go
series = series.TransformDivide("sum", "count", "avg")
```

### `TransformRatio(left, right, response string) Series`

:::signature TransformRatio(left, right, response string) Series
left | string | required |  | Left path.
right | string | required |  | Right path.
response | string | optional | `ratio` | Output path for the result.
:::

Divides `left` by `right` and multiplies by 100.

```go
series = series.TransformRatio("success", "count", "success_rate")
```

## Multi-path transforms

### `TransformSum(paths []string, response string) Series`

:::signature TransformSum(paths []string, response string) Series
paths | []string | required |  | List of paths to sum.
response | string | optional | `sum` | Output path for the result.
:::

```go
series = series.TransformSum([]string{"a", "b", "c"}, "total")
```

### `TransformMin(paths []string, response string) Series`

:::signature TransformMin(paths []string, response string) Series
paths | []string | required |  | List of paths to compare.
response | string | optional | `min` | Output path for the result.
:::

```go
series = series.TransformMin([]string{"p50", "p95"}, "latency.min")
```

### `TransformMax(paths []string, response string) Series`

:::signature TransformMax(paths []string, response string) Series
paths | []string | required |  | List of paths to compare.
response | string | optional | `max` | Output path for the result.
:::

```go
series = series.TransformMax([]string{"p50", "p95"}, "latency.max")
```

### `TransformMean(paths []string, response string) Series`

:::signature TransformMean(paths []string, response string) Series
paths | []string | required |  | List of paths to average.
response | string | optional | `mean` | Output path for the result.
:::

```go
series = series.TransformMean([]string{"p50", "p95"}, "latency.avg")
```

## Standard deviation

### `TransformStandardDeviation(sumPath, countPath, squarePath, response string) Series`

:::signature TransformStandardDeviation(sumPath, countPath, squarePath, response string) Series
sumPath | string | required |  | Path to sum values.
countPath | string | required |  | Path to count values.
squarePath | string | required |  | Path to sum of squares.
response | string | optional | `sd` | Output path for the result.
:::

Computes standard deviation using `sum`, `count`, and `square` paths.

```go
series = series.TransformStandardDeviation("events.sum", "events.count", "events.square", "events.sd")
```
