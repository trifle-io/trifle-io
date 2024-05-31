---
title: Category
description: Learn how to use Category Formatter.
nav_order: 2
---

# Category

Category formatter will help you to prepare data for any (reasonable) charging library that displays category-like type of data. Think of bar/column or pie charts.

`format` method accepts a block where `key` and `value` variables are available. You can use this to format `key` string into desired version as well as `value` into its final format. It needs to return an array of `[key, value]` in their final form. These two are then used to sum `value` under specific `key`. The choice is yours!

```ruby
series = Trifle::Stats.series(...)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184}}, {events: {count: 33, sum: 1553}}]}>

default_data = series.format.category(path: 'events')
=> {"count" => 0.75e2, "sum" => 0.3737e4}

formatted_data = series.format.category(path: 'events') do |key, value|
  [key.to_s.upcase, value.to_i]
end
=> {"COUNT" => 75, "SUM" => 3737}
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.


And thats it. Now you prepared series for plotting your categories.

> Note: You may have noticed that category formatter gives you basically same output as running sum aggregator over each key of the branch. Do with that what you want.
