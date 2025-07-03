---
title: Get series
description: Learn how to work with series of values.
nav_order: 5
---

# Get series

Getting series behaves same as getting values. The twist comes that series is values wrapped into an object that allows you to work further with [transponders](../transponders), [aggregators](../aggregators) and [formatters](../formatters).

## `series(key: String, from: Time, to: Time, range: Symbol, **options)`
- `key` - string identifier for the metrics
- `from` - timestamp you want to get values from
- `to` - timestamp you want to get values to
- `range` - specific range you want to get values in
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.
    - `skip_blanks` - optional argument that will instruct driver not to return empty hash in timeline when no value was being tracked.

Using `from` and `to` gives you flexibility to exactly specify what data you are interested in.

Use `range` to specify _sensitivity_ of returned data (aka how many data points you want to get). For example if you're trying to get daily values for current a specific month, use `range: :day`. This will give you ~30 data points. If you need to increase your sensitivity for chart, you may use `range: :hour` which will give you ~30 * 24 data points.

The more data you're fetching, the slower the response time. Thats a trade-off you need to decide.

Here is an example how to get today values for specific key.

```ruby
series = Trifle::Stats.series(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>3, "duration"=>8, "lines"=>658}]}>
series.aggregate.sum(path: 'count')
=> 3

```

And here is another how to get daily values for a last 30 days for specific key.

```ruby
series = Trifle::Stats.series(key: 'event::logs', from: Time.now - 60 * 60 * 24 * 30, to: Time.now, range: :day)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={:at=>[2021-01-25 00:00:00 +0200, 2021-01-24 00:00:00 +0200, ...], values: [{"count"=>3, "duration"=>8, "lines"=>658}, {"count"=>1, "duration"=>3, "lines"=>311}, ...]}>
series.aggregate.sum(path: 'count')
=> 432
```

> If you're integrating with Rails, don't forget you can use _things_ like `1.month.ago` or `Time.zone.now - 30.days`.

### Skip Blanks

Sometimes you may not have event occurence every hour or every day. Whenever you pull longer period of data, you may end up with timestamps and values where no values has been tracked. `Trifle::Stats` drivers by default return empty hash in these so you can perform continuous calculations (ie slicing in aggregators, etc). The disadvantage of this is that it may create lots of _empty_ data. For example lets say you track something ~4 times a day and you wanna pull data per minute for last 30 days. By default `Trifle::Stats` would give you 30 (days) * 24 (hours) * 60 (minutes) ~43k of points. Good luck plotting that. But if you know you have lots of empty values in between, you may decide to skip those and then you would get back 30 (days) * 4 (times a day) ~= 120 points. Theres a big difference.

```ruby
Trifle::Stats.series(key: 'events::logs', from: Time.now - 60 * 60 * 24 * 30, to: Time.now, range: :day)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={
  :at => [
    2021-01-20 00:00:00 +0200,
    2021-01-21 00:00:00 +0200,
    2021-01-22 00:00:00 +0200,
    2021-01-23 00:00:00 +0200,
    2021-01-24 00:00:00 +0200,
    2021-01-25 00:00:00 +0200,
    2021-01-26 00:00:00 +0200,
    2021-01-27 00:00:00 +0200,
    ...
  ],
  values: [
    {"count"=>3, "duration"=>8, "lines"=>658},
    {},
    {"count"=>1, "duration"=>3, "lines"=>311},
    {},
    {},
    {"count"=>2, "duration"=>4, "lines"=>541},
    {},
    {},
    ...
  ]
}>
```

And heres how that looks with `skip_blanks: true` enabled.

```ruby
Trifle::Stats.series(key: 'events::logs', from: Time.now - 60 * 60 * 24 * 30, to: Time.now, range: :day, skip_blanks: true)
=> #<Trifle::Stats::Series:0x0000ffffa14256e8 @series={
  :at => [
    2021-01-20 00:00:00 +0200,
    2021-01-22 00:00:00 +0200,
    2021-01-25 00:00:00 +0200,
    ...
  ],
  values: [
    {"count"=>3, "duration"=>8, "lines"=>658},
    {"count"=>1, "duration"=>3, "lines"=>311},
    {"count"=>2, "duration"=>4, "lines"=>541},
    ...
  ]
}>
```

