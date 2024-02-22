---
title: Assort values
description: Learn how to categorize values in buckets.
nav_order: 3
---

# Assort values

Assorting values runs `inc` on the driver with a twist. Before passing values to `inc` method, it categorizes values into a category keys and sets values to `1`. This way it increments the metrics within specific bucket. Effectively creating a metrics for a histogram.

## `assort(key: String, at: Time, values: Hash, **options)`
- `key` - string identifier for the metrics
- `at` - timestamp of the sample (in most cases current timestamp)
- `values` - hash of values. Can contain only nested hashes and numbers (Integer, Float, BigDecimal). Any other objects will cause an error.
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Assort is using concept of Designator to define buckets for categorizing values. Please see the [Designator](../designators) documentation for more details.

Below examples are using following designator: `Trifle::Stats::Designator::Linear.new(min: 0, max: 100, step: 10)`

Assort your first values

```ruby
Trifle::Stats.assort(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{"count.10"=>1, "duration.10"=>1, "lines.100+"=>1}, {"count.10"=>1, "duration.10"=>1, "lines.100+"=>1}]
```

Then do it few more times

```ruby
Trifle::Stats.assort(key: 'event::logs', at: Time.now, values: {count: 1, duration: 1, lines: 56})
=> [{"count.10"=>1, "duration.10"=>1, "lines.60"=>1}, {"count.10"=>1, "duration.10"=>1, "lines.60"=>1}]
Trifle::Stats.assort(key: 'event::logs', at: Time.now, values: {count: 1, duration: 5, lines: 361})
=> [{"count.10"=>1, "duration.10"=>1, "lines.100+"=>1}, {"count.10"=>1, "duration.10"=>1, "lines.100+"=>1}]
```

## Get values

Retrieve your values for specific `range`. As you just used `assort` above, it will return categorized values you've tracked.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2022-06-18 00:00:00 +0200], :values=>[{"count"=>{"10"=>3}, "duration"=>{"10"=>3}, "lines"=>{"100+"=>2, "60"=>1}}]}
```
