---
title: Max
description: Learn how to aggregate Max from your series.
nav_order: 2
---

# Max

Sometimes you just want to know whats the biggest value in the series. You can do that by using `max` aggregator.

```ruby
series = Trifle::Stats.series(...)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184}}, {events: {count: 33, sum: 1553}}]}>
series.aggregate.max(path: 'events.count')
=> [42]
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.

Enjoy!
