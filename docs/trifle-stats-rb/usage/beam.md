---
title: Beam values
description: Learn how to announce values with a single point of time reference.
nav_order: 6
---

# Beam values

Beam values runs `ping` on the driver that behaves similarly like `set` but does not uses `Nocturnal` to round the `at` timestamps. Instead it uses raw value of `at` to indicate when ping has been received.

## `beam(key: String, at: Time, values: Hash, **options)`

Use only in combination with Scan and liveness tracking.

:::signature beam(key: String, at: Time, values: Hash, **options) -> nil
key | String | required |  | Identifier for the metric (e.g., `event::logs`).
at | Time | required |  | Timestamp for the sample, usually `Time.now` or `Time.zone.now`. `Trifle::Stats` will convert to configured timezone.
values | Hash<String, Numeric or Hash> | required |  | Nested hashes are allowed; every leaf must be numeric (Integer, Float, BigDecimal).
config | Trifle::Stats::Configuration | optional | `nil` | Override configuration for this call. Defaults to the global configuration when omitted.
:::

## Examples

:::tabs
@tab Beam once

Beam your first values

```ruby
Trifle::Stats.beam(key: 'event::logs', at: Time.now, values: {count: 1, duration: 2, lines: 241})
=> [{2021-01-25 16:21:33 +0100=>{:count=>1, :duration=>2, :lines=>241}}]
```
@tab Beam some more

Then do it few more times

```ruby
Trifle::Stats.beam(key: 'event::logs', at: Time.now, values: {count: 1, duration: 1, lines: 56})
=> [{2021-01-25 16:22:12 +0100=>{:count=>1, :duration=>1, :lines=>56}}]
Trifle::Stats.beam(key: 'event::logs', at: Time.now, values: {count: 1, duration: 5, lines: 361})
=> [{2021-01-25 16:22:16 +0100=>{:count=>1, :duration=>5, :lines=>361}}]
```
:::

Beam will create unique a record every time its used.

:::callout warn "Common mistakes"
- By now I hope you have realized that this will create lots and lots of records. Please either use it in combination with MongoDB and expiring indexes or set up your own data cleanup strategy.
:::

### Get values

In case of `beam` there is no range to retrieve. Instead you need to `scan` for specific key that returns last ping received for the value. `Trifle::Stats` stores only the latest value of a ping.

```ruby
Trifle::Stats.scan(key: 'event::logs')
=> {:at=>[2021-01-25 16:22:16 +0200], :values=>[{"count"=>1, "duration"=>5, "lines"=>361}]}
```
