---
title: Beam values
description: Learn how to announce values with a single point of time reference.
nav_order: 6
---

# Beam values

Beam values runs `ping` on the driver that behaves similarly like `set` but does not uses `Nocturnal` to round the `at` timestamps. Instead it uses raw value of `at` to indicate when ping has been received.

## `beam(key: String, at: Time, values: Hash, **options)`
- `key` - string identifier for the metrics
- `at` - timestamp of the sample (in most cases current timestamp)
- `values` - hash of values. Can contain only nested hashes and numbers (Integer, Float, BigDecimal). Any other objects will cause an error.
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Beam your first values

```ruby
Trifle::Stats.beam(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:21:33 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```

Then do it few more times

```ruby
Trifle::Stats.beam(key: 'event::logs', at: Time.now, values: {count: 1, duration: 1, lines: 56})
=> [{2021-01-25 16:22:12 +0100=>{:count=>1, :duration=>1, :lines=>56}}]
Trifle::Stats.beam(key: 'event::logs', at: Time.now, values: {count: 1, duration: 5, lines: 361})
=> [{2021-01-25 16:22:16 +0100=>{:count=>1, :duration=>5, :lines=>361}}]
```

## Get values

In case of `beam` there is no range to retrieve. Instead you need to `scan` for specific key that returns last ping received for the value. `Trifle::Stats` stores only the latest value of a ping.

```ruby
Trifle::Stats.scan(key: 'event::logs')
=> {:at=>[2021-01-25 16:22:16 +0200], :values=>[{"count"=>1, "duration"=>5, "lines"=>361}]}
```
