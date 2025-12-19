---
title: Usage
description: Learn how to use Trifle::Stats DSL.
nav_order: 4
---

# Usage

`Trifle::Stats` comes with a couple module level methods that are shorthands for operations. There are two main methods `track` and `values`. As you guessed, `track` tracks and `values` values. Duh.

There is also `.series` method that behaves similarly as `.values` but returned series of values is wrapped around an object that helps you perform different operations on top of this series of values.

:::callout note "Main methods"
- `track` runs increments to build up your metrics.
- `assert` sets values at specific times for your metrics.
- `values` returns raw values for specific timerange with desired granularity.
- `series` returns wrapper around values for specific timerange with desired granularity. You know, for further processing.
:::

`Trifle::Stats` offers most rudimental operations to build up your metrics. If you need to calculate an average value, you need to make sure to track value as well as counter. Later you can devide value by counter to calculate the average.

For example if you track your values with

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```

Then you can retrieve their metrics with `.values` or `.series` methods. While the `.values` method returns _raw_ series of values that you can manipulate yourself, `.series` returns an object wrapped around the data that helps you perform different modifications and calculations on the series of values itself. See [Transponders](./transponders), [Formatters](./formatters) and [Aggregators](./aggregators) for more details.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, granularity: '1d')
=> {:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>1, "duration"=>2, "lines"=>241}]}
Trifle::Stats.series(key: 'event::logs', from: Time.now, to: Time.now, granularity: '1d')
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>1, "duration"=>2, "lines"=>241}]}>
```

## Granularities

Granularities are the sensitivity of data when retrieving values. Granularities are configured on your driver, you can use `"#{number}#{unit}"` convention to build up granularities like `'1m'` or `'10m'`, `'1h'` and so on.

:::callout warn "Supported units"
- `s` - second
- `m` - minute
- `h` - hour
- `d` - day
- `w` - week
- `mo` - month
- `q` - quarter
- `y` - year
:::


<sub><sup>Honestly, thats it. Now instead of building your own analytics, go do something useful. You can buy me coffee later. K, thx, bye!</sup></sub>
