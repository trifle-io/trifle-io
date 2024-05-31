---
title: Usage
description: Learn how to use Trifle::Stats DSL.
nav_order: 4
---

# Usage

`Trifle::Stats` comes with a couple module level methods that are shorthands for operations. They do it's thing to understand what type of operation are you trying to perform. If you pass in `at` parameter, it will know you need timeline operations, etc. There are two main methods `track` and `values`. As you guessed, `track` tracks and `values` values. Duh.

Now there is also `.series` method that behaves similarly as `.values` but returned series of values is wrapped around an object that helps you perform different operations on top of this series of values.

`Trifle::Stats` offers most rudimental operations to build up your metrics. If you need to calculate an average value, you need to make sure to track value as well as counter. Later you can devide value by counter to calculate the average.

For example if you track your values with

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```

Then you can retrieve their metrics with `.values` or `.series` methods. While the `.values` method returns _raw_ series of values that you can manipulate, `.series` returns an object wrapped around the data that helps you perform different modifications and calculations on the series of values itself.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>1, "duration"=>2, "lines"=>241}]}
Trifle::Stats.series(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>1, "duration"=>2, "lines"=>241}]}>
```

While `track` runs increments to build up your metrics, there is also `assert` that sets values and `assort` that categorizes values.

## Ranges

Ranges are the sensitivity of data when retrieving values. Available ranges are `:minute`, `:hour`, `:day`, `:week`, `:month`, `:quarter`, `:year`.

<sub><sup>Honestly, thats it. Now instead of building your own analytics, go do something useful. You can buy me coffee later. K, thx, bye!</sup></sub>
