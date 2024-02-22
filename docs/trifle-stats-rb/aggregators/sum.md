---
title: Sum
description: Learn how to aggregate Sum from your series.
nav_order: 3
---

# Sum

Sometimes you just want to know whats the total sum of values. You can do that by using `Sum` aggregator.

```ruby
series = []
total = Trifle::Stats::Aggregator::Sum.new(series: series, path: 'a.count').aggregate
=> 12345
```

Enjoy!
