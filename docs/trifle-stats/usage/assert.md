---
title: .assert
nav_order: 2
---

# Assert values

Asserting values works same way like incrementing, but instead of increment, it sets the value. Asserting values runs `set` on the driver. Every time you assert a value, it will set the metrics.

### `Trifle::Stats.assert(key: String, at: Time, values: Hash, **options)`
- `key` - string identifier for the metrics
- `at` - timestamp of the sample (in most cases current timestamp)
- `values` - hash of values. Can contain only nested hashes and numbers (Integer, Float, BigDecimal). Any other objects will cause an error.
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Assert your first values

```ruby
Trifle::Stats.assert(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```

Then do it few more times

```ruby
Trifle::Stats.assert(key: 'event::logs', at: Time.now, values: {count: 1, duration: 1, lines: 56})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>1, :lines=>56}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>1, :lines=>56}}]
Trifle::Stats.assert(key: 'event::logs', at: Time.now, values: {count: 1, duration: 5, lines: 361})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>5, :lines=>361}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>5, :lines=>361}}]
```

## Get values

Retrieve your values for specific `range`. As you just used `assert` above, it will return latest value you've asserted.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>1, "duration"=>5, "lines"=>361}]}
```
