---
title: Formatters
description: Learn how to use Formatters to prepare series for charts.
nav_order: 9
---

# Formatters

Having series of data available is cool, but you know whats even cooler? Having bunch of charts to visualize them. Sorry, I couldn't help myself.

The purpose of formatters is exactly that. To help you to prepare series for a charting library. Every library is different, but they all come together in requiring the data to be in a list of values. Sometimes this can be a list of simple values, list of hashes with `x` and `y` keys or list of lists with coordinates.

```ruby
series = {at: [...], values: [{a: {count: 132}}, {a: {count: 321}}]}
formatter = Trifle::Stats::Formatter::Timeline.new(series: series, path: 'a.count')
formatter.format
=> [[1, 123], [2, 321]]
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.

