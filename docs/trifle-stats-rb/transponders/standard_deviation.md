---
title: Standard Deviation
description: Learn how to add standard deviation to your series.
nav_order: 2
---

# Standard Deviation

Standard Deviation transponder expects three variables to be present. It utilises rapid Standard Deviation formula that depends on `count`, `sum` of values and sum of `square` root of values. The easiest way to populate this is to make sure every time you preserve a value, you do something like this.

```ruby
def duration(value:)
  {
    count: 1,
    sum: value,
    square: value**2
  }
end
```

These will make sure your sums are incremented correctly and you can use them to calculate Standard Deviation.

> Note: `count`, `sum` and `square` are default values of the keys. You need to pass only overrides.

```ruby
series = Trifle::Stats.series(...)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184}}, {events: {count: 33, sum: 1553}}]}>
series.transpond.standard_deviation(path: 'events')
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184, sd: 123}}, {events: {count: 33, sum: 1553, sd: 456}}]}>
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.


