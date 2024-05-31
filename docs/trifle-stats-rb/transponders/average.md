---
title: Average
description: Learn how to add average to your series.
nav_order: 1
---

# Average

Average transponder expands your data with calculated average of `sum` over `count`.

> Note: `sum` and `count` are default values of the keys. You need to pass only overrides.

```ruby
series = Trifle::Stats.series(...)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184}}, {events: {count: 33, sum: 1553}}]}>
series.transpond.average(path: 'events')
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184, average: 52}}, {events: {count: 33, sum: 1551, average: 47}}]}
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.


There really isn't much to it. Sometime it's just nice to do even simple things easy.

