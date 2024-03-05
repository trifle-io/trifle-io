---
title: Min
description: Learn how to aggregate Min from your series.
nav_order: 1
---

# Min

Sometimes you just want to know whats the lowest value in the series. You can do that by using `Min` aggregator.

```ruby
series = {at: [...], values: [...]}
total = Trifle::Stats::Aggregator::Min.new(series: series).aggregate(path: 'a.count')
=> 12
```

Enjoy!
