---
title: Timeline
description: Learn how to use Timeline Formatter.
nav_order: 1
---

# Timeline

Timeline formatter will help you to prepare data for (pretty much) any (reasonable) charting library that supports timestamps.

`format` method accepts a block where `at` and `value` variables are available. You can use this to format `at` timestamp into desired version, or return only `value`, or return hash or multi-dimensional array. The choice is yours!

```ruby
series = {at: [...], values: [...]}
formatter = Trifle::Stats::Formatter::Timeline.new(series: series, path: 'a.count')
simple_data = formatter.format do |at, value|
  value.to_i
end
=> [1, 2, 3, 4, 5, ...]

array_data = formatter.format do |at, value|
  [at.to_i, value.to_i]
end
=> [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], ...]

hash_data = formatter.format do |at, value|
  {x: at.to_i, y: value.to_i}
end
=> [{x: 1, y: 1}, {x: 2, y: 2}, {x: 3, y: 3}, {x: 4, y: 4}, {x: 5, y: 5}, ...]
```

If your value comes from transponder like Standard Deviation, you may wanna multiply value by a constant that calculate specific percentile.

```ruby
series = {at: [...], values: [...]}

transponder = Trifle::Stats::Transponder::StandardDeviation.new(count: 'count', sum: 'sum', square: 'square')
series = transponder.transpond(series: series, path: 'a')

formatter = Trifle::Stats::Formatter::Timeline.new(series: series, path: 'a.sd')
p95 = formatter.format do |at, value|
  {x: at.to_i, y: value * 1.98}
end
p99 = formatter.format do |at, value|
  {x: at.to_i, y: value * 2.58}
end
```

And thats it. Now you prepared series for plotting your percentiles.
