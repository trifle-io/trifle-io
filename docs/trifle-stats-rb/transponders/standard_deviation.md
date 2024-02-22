---
title: Standard Deviation
description: Learn how to add standard deviation to your series.
nav_order: 2
---

# Standard Deviation

Standard Deviation transponder expects three variables to be present. It utilises rapid Standard Deviation formula that depends on `count`, `sum` of values and sum of `square` root of values. The easiest way to populate this is to make sure every time you preserve a value, you do something like this.

```ruby
def duration(value:)
  {
    count: 1,
    sum: value,
    square: value**2
  }
end
```

These will make sure your sums are incremented correctly and you can use them to calculate Standard Deviation.

```ruby
series = [{a: {count: 2, sum: 10, square: 50}}, {count: 3, sum: 21, square: 147}]
transponder = Trifle::Stats::Transponder::StandardDeviation.new(count: 'count', sum: 'sum', square: 'square')
transponder.transpond(series: series, path: 'a')
=> [{a: {count: 2, sum: 10, square: 50, sd: 5}}, {count: 3, sum: 21, square: 147, sd: 7}]
```

> Note: `count`, `sum` and `square` are default values of the keys. You need to pass only overrides.
