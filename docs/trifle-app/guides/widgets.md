---
title: Widget Cookbook
description: Practical layout patterns for Trifle dashboards.
nav_order: 4
---

# Widget Cookbook

This is the pragmatic stuff: layouts that look good, read fast, and survive real data.

## Grid basics

- Grid is **12 columns** wide.
- Widgets use `x`, `y`, `w`, `h`.
- Missing values default to `w: 3`, `h: 2`, `x: 0`, `y: 0`.

## Pattern: KPI strip + trend

Good for exec overviews or status boards.

```json
{
  "grid": [
    { "id": "kpi-1", "type": "kpi", "title": "Total", "path": "count", "function": "sum", "x": 0, "y": 0, "w": 3, "h": 2 },
    { "id": "kpi-2", "type": "kpi", "title": "Failed", "path": "failed", "function": "sum", "x": 3, "y": 0, "w": 3, "h": 2 },
    { "id": "kpi-3", "type": "kpi", "title": "Avg Duration", "path": "duration", "function": "mean", "x": 6, "y": 0, "w": 3, "h": 2 },
    { "id": "kpi-4", "type": "kpi", "title": "Success Rate", "path": "success_rate", "function": "mean", "x": 9, "y": 0, "w": 3, "h": 2 },
    { "id": "ts-1", "type": "timeseries", "title": "Volume", "paths": ["count", "failed"], "chart_type": "area", "stacked": true, "legend": true, "x": 0, "y": 2, "w": 12, "h": 4 }
  ]
}
```

:::callout note "Success rate"
- Compute `success_rate` with a transponder or ingest it directly.
:::

## Pattern: Breakdown board

Great when you need to explain *why* the number is moving.

```json
{
  "grid": [
    { "id": "kpi-1", "type": "kpi", "title": "Total", "path": "count", "function": "sum", "x": 0, "y": 0, "w": 4, "h": 3 },
    { "id": "ts-1", "type": "timeseries", "title": "Trend", "paths": ["count"], "chart_type": "line", "legend": false, "x": 4, "y": 0, "w": 8, "h": 3 },
    { "id": "cat-1", "type": "category", "title": "By Country", "path": "country.*", "chart_type": "donut", "x": 0, "y": 3, "w": 4, "h": 3 },
    { "id": "list-1", "type": "list", "title": "Top Channels", "path": "channel.*", "limit": 6, "x": 4, "y": 3, "w": 4, "h": 3 },
    { "id": "tbl-1", "type": "table", "title": "Raw Data", "paths": ["count", "failed", "duration"], "x": 8, "y": 3, "w": 4, "h": 3 }
  ]
}
```

## Pattern: Ops board (alerts + latency)

```json
{
  "grid": [
    { "id": "text-1", "type": "text", "title": "Service Health", "subtype": "header", "alignment": "left", "x": 0, "y": 0, "w": 12, "h": 1 },
    { "id": "kpi-1", "type": "kpi", "title": "p95 Latency", "path": "p95", "function": "mean", "x": 0, "y": 1, "w": 3, "h": 2 },
    { "id": "kpi-2", "type": "kpi", "title": "Error Rate", "path": "rate", "function": "mean", "x": 3, "y": 1, "w": 3, "h": 2 },
    { "id": "ts-1", "type": "timeseries", "title": "Latency", "paths": ["p50", "p95", "p99"], "chart_type": "line", "legend": true, "x": 6, "y": 1, "w": 6, "h": 4 },
    { "id": "dist-1", "type": "distribution", "title": "Latency Dist", "paths": ["duration"], "mode": "2d", "chart_type": "bar", "designators": { "horizontal": { "type": "linear", "count": 12, "min": 0, "max": 1200 } }, "x": 0, "y": 3, "w": 6, "h": 4 }
  ]
}
```

## Segment-aware dashboards

If you use segments, keep widget paths stable and let segments drive filtering. It keeps your dashboard readable and avoids "path spaghetti".

:::callout warn "Edge case"
- If your metric payload is missing paths, widgets render empty. That is not a bug, it is a reminder.
:::
