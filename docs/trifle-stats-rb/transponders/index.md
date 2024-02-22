---
title: Transponders
description: Learn how you can use Transponders to add calculated data into series.
nav_order: 7
---

# Transponders

`Trifle::Stats` only builds up your stats series. It does not do any calculations on the background by itself. Sooner than later you will need to add _some_ data manipulation to expand your values.

The easiest example is to think of calculating average. `Trifle::Stats` does not do that for you and you need to keep track of two values: `sum` and `count`. To calculate the average you simply divide `sum` by `count`. While this and other calculations are quite easy to perform yourself, `Trifle::Stats` gives you an easy way how to expand your series with calculated values.

Before you start, you need to understand data structure inside of the series. After all you want to expand values inside of it. Once you retrieve your series, go ahead and define the list of transponders to manipulate data inside of it. After that, pass both `series` and `transponders` into main transponder and call `.transpond` to receive updated series.

Transponders needs to be list of hashes where key represents the path of a tree you want to expand and value is a specific transponder that performs calculations for you. Transponders expect certain keys to be part of that branch and you can customize them by passing your own key name.

`Trifle::Stats` comes with couple pre-defined transponders and you are free to add your own.

```ruby
series = Trifle::Stats.values(...)
=> {at: [...], values: [{a: 1, b: {sum: 12, count: 3}}, {a: 2, b: {sum: 42, count: 6}}]}
transponders = [
  { 'b' => Trifle::Stats::Transponder::Average.new }
]
=> [...]
Trifle::Stats::Transponder.new(series: series, transponders: transponders).transpond
=> {at: [...], values: [{a: 1, b: {sum: 12, count: 3, average: 4}}, {a: 2, b: {sum: 42, count: 6, average: 7}}]}
```

> Note: `path` is a list of keys joined by dot. Ie `orders.shipped.count` would represent value at `{orders: { shipped: { count: ... } } }`.

You can define as many transponders as you want. They are executed in the specified order and any following transponder can consume values added by previous transponder.
