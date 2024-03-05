---
title: Sum
description: Learn how to aggregate Sum from your series.
nav_order: 3
---

# Sum

Sometimes you just want to know whats the total sum of values. You can do that by using `Sum` aggregator.

```ruby
series = {at: [...], values: [...]}
total = Trifle::Stats::Aggregator::Sum.new(series: series).aggregate(path: 'a.count')
=> 12345
```

Enjoy!
