---
title: Linear
description: Learn more how Linear designator creates buckets.
nav_order: 2
---

# Linear

`Linear` Designator allows you to specify `min` and `max` range of a bucket and `step` of each bucket within a range.

### `Trifle::Stats::Designator::Linear.new(min: Integer, max: Integer, step: Integer)`
- `min` - lower range of the bucket.
- `max` - upper range of the bucket.
- `step` - size of an each bucket.

This Designator calculates matching bucket by mathematical equation. That means categorizing is quick no matter the number of buckets. Just keep on mind that the more buckets you have, the more buckets you will need to fetch.

## Configuration

```ruby
irb(main):001:0> designator = Trifle::Stats::Designator::Linear.new(min: 0, max: 50, step: 5)
=> #<Trifle::Stats::Designator::Linear:0x000055ae8bf621d0 @min=0, @max=50, @step=5>
```

Do not use decimal points for step.

## Usage

`Linear` Designator then categorizes your to upper bucket. Anything lower then first value of a bucket gets categorized within first bucket. Anything over last bucket goes into `+` bucket.

Here are few examples:

```ruby
irb(main):002:0> designator.designate(value: -10)
=> "0"
irb(main):003:0> designator.designate(value: 0.04)
=> "5"
irb(main):004:0> designator.designate(value: 45)
=> "45"
irb(main):005:0> designator.designate(value: 67)
=> "50+"
```
