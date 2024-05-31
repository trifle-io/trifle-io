---
title: Transponders
description: Learn how you can use Transponders to add calculated data into series.
nav_order: 7
---

# Transponders

`Trifle::Stats` only builds up your stats series. It does not do any calculations on the background by itself. Sooner than later you will need to add _some_ data manipulation to expand your values.

The easiest example is to think of calculating average. `Trifle::Stats` does not do that for you automatically and you need to keep track of two values: `sum` and `count`. To calculate the average you simply divide `sum` by `count`. While this and other calculations are quite easy to perform yourself, `Trifle::Stats` gives you an even easier way to expand your series with calculated values.

Before you start, you need to understand data structure inside of the series. After all you want to expand values inside of it. Once you retrieve your series, go ahead and execute series of transponders to manipulate data inside of it. Transponders modifies data inside of a series and therefore can be chained where following transponder uses values tranponded by previous one.


```ruby
series = Trifle::Stats.series(...)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184}}, {events: {count: 33, sum: 1553}}]}>
series.transpond.average(path: 'events')
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2024-03-22 19:38:00 +0000, 2024-03-22 19:39:00 +0000], :values=>[{events: {count: 42, sum: 2184, average: 52}}, {events: {count: 33, sum: 1551, average: 47}}]}
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.

## Custom Transponders

You can use one of predefined transponders or write your own. Transponders needs to implement at least one method that accepts key parameters `series:`and `path:`and returns _transponded_ `series`. The `series:`is passed in automatically.

I strongly recommend to avoid manipulating specific leaf manually and instead use `Trifle::Stats::Mixins::Packer`and its `deep_merge` feature that merges two hashes in _unified_ and desired way.

```ruby
class MyTransponder
  include Trifle::Stats::Mixins::Packer

  def transpond(series:, path:)
    keys = path.to_s.split('.')
    key = [path, 'rand'].compact.join('.')
    series[:values] = series[:values].map do |data|
      signal = { key => rand(1000) }
      self.class.deep_merge(data, self.class.unpack(hash: signal))
    end
  end
end
```

If you write your own transponder and would like to access it through `dot` notation, you need to register it through `Trifle::Stats::Series.register_transponder(NAME, self)` inside of your transponder class.

```ruby
class MyTransponder
  include Trifle::Stats::Mixins::Packer
  Trifle::Stats::Series.register_transponder(:rand, self)

  def transpond(series:, path:)
    keys = path.to_s.split('.')
    key = [path, 'rand'].compact.join('.')
    series[:values] = series[:values].map do |data|
      signal = { key => rand(1000) } 
      self.class.deep_merge(data, self.class.unpack(hash: signal))
    end
  end
end
```

And from there you can access it through `series.transpond.rand(path: 'events')`
