---
title: Timeline
description: Format a series as timeline points.
nav_order: 1
---

# Timeline

Timeline format builds a map of path -> list of timeline points (or slices of points).

:::callout note "Slices"
When `slices > 1`, each path maps to a list of slices (each slice is its own list of points).
:::

## `FormatTimeline(path string, slices int, transform TimelineTransform) map[string]any`

:::signature FormatTimeline(path string, slices int, transform TimelineTransform) map[string]any
path | string | required |  | Dotted path to format.
slices | int | optional | `1` | Number of equal slices.
transform | TimelineTransform | optional | `nil` | Custom transformer with signature `func(time.Time, any) any`.
:::

## Example (default points)

```go
series := TrifleStats.SeriesFromResult(result)
points := series.FormatTimeline("events.count", 1, nil)
// points["events.count"] is []TimelinePoint
```

## Example (custom transformer)

```go
series := TrifleStats.SeriesFromResult(result)
points := series.FormatTimeline("events.count", 1, func(at time.Time, value any) any {
  return []any{at.Unix(), TrifleStats.NormalizeNumeric(value)}
})
```

This lets you output any structure your charting library expects.
