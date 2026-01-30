---
title: Category
description: Format series into category totals.
nav_order: 2
---

# Category

Category format aggregates numeric values across the series and returns totals per path.

:::callout note "Slices"
When `slices > 1`, the formatter returns a list of category maps (one per slice).
:::

## `FormatCategory(path string, slices int, transform CategoryTransform) any`

:::signature FormatCategory(path string, slices int, transform CategoryTransform) any
path | string | required |  | Dotted path to format.
slices | int | optional | `1` | Number of equal slices.
transform | CategoryTransform | optional | `nil` | Custom transformer with signature `func(string, any) (string, any)`.
:::

## Example (default totals)

```go
series := TrifleStats.SeriesFromResult(result)
category := series.FormatCategory("events.country", 1, nil)
// category is map[string]any
```

## Example (custom transformer)

```go
series := TrifleStats.SeriesFromResult(result)
category := series.FormatCategory("events.country", 1, func(key string, value any) (string, any) {
  // normalize keys or transform values
  return strings.ToUpper(key), TrifleStats.NormalizeNumeric(value)
})
```
