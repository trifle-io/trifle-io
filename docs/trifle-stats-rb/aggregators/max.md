---
title: Max
description: Learn how to aggregate Max from your series.
nav_order: 2
---

# Max

Sometimes you just want to know whats the biggest value in the series. You can do that by using `Max` aggregator.

```ruby
series = []
total = Trifle::Stats::Aggregator::Max.new(series: series, path: 'a.count').aggregate
=> 3313
```

Enjoy!
