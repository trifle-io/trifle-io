---
title: Average
description: Learn how to add average to your series.
nav_order: 1
---

# Average

Average transponder expands your data with calculated average of `sum` over `count`.

```ruby
series = [{a: {sum: 10, count: 2}}, {a: {sum: 21, count: 3}}]
transponder = Trifle::Stats::Transponder::Average.new(sum: 'sum', count: 'count')
transponder.transpond(series: series, path: 'a')
=> [{a: {sum: 10, count: 2, average: 5}}, {a: {sum: 21, count: 3, average: 7}}]
```

> Note: `sum` and `count` are default values of the keys. You need to pass only overrides.

There really isn't much to it. Sometime it's just nice to do even simple things ~complicated~ unified way.
