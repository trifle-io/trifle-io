---
title: Usage
nav_order: 3
---

# Usage

`Trifle::Stats` comes with a couple module level methods that are shorthands for operations. They do it's thing to understand what type of operation are you trying to perform. If you pass in `at` parameter, it will know you need timeline operations, etc. There are two main methods `track` and `values`. As you guessed, `track` tracks and `values` values. Duh.

Available ranges are `:minute`, `:hour`, `:day`, `:week`, `:month`, `:quarter`, `:year`.

`Trifle::Stats` offers most rudimental operations to build up your metrics. If you need to calculate an average value, you need to make sure to track value as well as counter. Later you can devide value by counter to calculate the average.

For example if you track your values with

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}, {2021-01-25 00:00:00 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```

Then you can retrieve their metrics with

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0200], :values=>[{"count"=>1, "duration"=>2, "lines"=>241}]}
```

While `track` runs increments to build up your metrics, there is also `assert` that sets values and `assort` that categorizes values.

<sub><sup>Honestly, thats it. Now instead of building your own analytics, go do something useful. You can buy me coffee later. K, thx, bye!</sup></sub>
