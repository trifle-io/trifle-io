---
title: Track values
description: Learn how to increment values.
nav_order: 1
---

# Track values

Tracking values runs `inc` on the driver. Every time you track a value, it will increment the metrics.

## `Trifle::Stats.track(key: String, at: Time, values: Hash, **options)`
- `key` - string identifier for the metrics
- `at` - timestamp of the sample (in most cases current timestamp)
- `values` - hash of values. Can contain only nested hashes and numbers (Integer, Float, BigDecimal). Any other objects will cause an error.
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Track your first values

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```

Then do it few more times

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {count: 1, duration: 1, lines: 56})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>1, :lines=>56}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>1, :lines=>56}}]
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {count: 1, duration: 5, lines: 361})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>5, :lines=>361}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>5, :lines=>361}}]
```

You can also store nested counters like

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {
  count: 1,
  duration: {
    parsing: 21,
    compression: 8,
    upload: 1
  },
  lines: 25432754
})
```

## Get values

Retrieve your values for specific `range`. Adding increments above will return sum of all the values you've tracked.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>3, "duration"=>8, "lines"=>658}]}
```