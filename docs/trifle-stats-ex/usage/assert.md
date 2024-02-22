---
title: Assert values
description: Learn how to set values.
nav_order: 2
---

# Assert values

Asserting values works same way like incrementing, but instead of increment, it sets the value. Asserting values runs `set` on the driver. Every time you assert a value, it will set the metrics.

## `assert(key=String, at=DateTime, values=Map, config=Trifle.Stats.Configuration)`
- `key` - string identifier for the metrics
- `at` - timestamp of the sample (in most cases current timestamp)
- `values` - map of values. Can contain only nested maps and numbers (Integer, Float). Any other type will cause an error.
- `config` - optional configuration variable of `Trifle.Stats.Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Assert your first values

```elixir
Trifle.Stats.assert('event::logs', DateTime.utc_now(), %{count: 1, duration: 2, lines: 241})
=> ...
```

Then do it few more times

```elixir
Trifle.Stats.assert('event::logs', DateTime.utc_now(), %{count: 1, duration: 1, lines: 56})
=> ...
Trifle.Stats.assert('event::logs', DateTime.utc_now(), %{count: 1, duration: 5, lines: 361})
=> ...
```

## Get values

Retrieve your values for specific `range`. As you just used `assert` above, it will return latest value you've asserted.

```elixir
Trifle.Stats.values('event::logs', DateTime.utc_now(), DateTime.utc_now(), :day)
=> ...
```
