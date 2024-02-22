---
title: Aggregators
description: Learn how to aggregate data from the series.
nav_order: 8
---

# Aggregators

While transponders allow you to add calculations on a specific data inside of a series, Aggregators allows you to perform calculations on top of whole series.

For example you want to know the number of events that happened during the specific timeframe. Of course you can calculate that manually with some form of reduce, but you can also use build in Trifle::Stats methods to calculate this.

```ruby
series = [at: [...], values: [{a: {count: 42}}, {a: {count: 33}}]]
aggregator = Trifle::Stats::Aggregator::Sum.new(series: series, path: 'a.count')
aggregator.aggregate
=> 75
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.

You can use one of predefined aggregators or write your own.
