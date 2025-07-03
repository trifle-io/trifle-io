---
title: Scan values
description: Learn how to retrieve Beamed values.
nav_order: 7
---

# Scan values

Scanning works only with Beamed values. The purpose is not to find matching values, but to find the status value that has been pinged. There is no `range` or `from` to `to` because we're trying to retrieve one value and one value only.

## `scan(key: String, **options)`
- `key` - string identifier for the metrics
- `options` - hash of optional arguments:
    - `config` - optional configuration instance of `Trifle::Stats::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.
    - `skip_blanks` - optional argument that will instruct driver not to return empty hash in timeline when no value was being tracked.

Here is an example how to get today values for specific key.

```ruby
Trifle::Stats.scan(key: 'event::logs')
=> {:at=>[2021-01-25 16:22:16 +0200], :values=>[{"count"=>1, "duration"=>5, "lines"=>361}]}
```

Thats it. Just a single value with a single timestamp indicating when the ping has been received last time.