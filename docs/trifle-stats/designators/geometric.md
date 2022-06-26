---
title: Geometric
nav_order: 3
---

# Geometric

`Geometric` Designator allows you to specify `min` and `max` range. It then uses decimal points to create buckets.

### `Trifle::Stats::Designator::Geometric.new(min: Float, max: Float)`
- `min` - lower boundary of the range.
- `max` - upper boundary of the range.

This Designator calculates matching bucket by somewhat mathematical equation. As each decimal point gets its own bucket, it uses slightly different logic for calculating numbers below and over 1. For below 1 it uses counts heading 0s and for above 1 it counts number of digits.

## Configuration

```ruby
irb(main):001:0> designator = Trifle::Stats::Designator::Geometric.new(min: 0.0001, max: 100)
=> #<Trifle::Stats::Designator::Geometric:0x00005618e8a67b68 @min=0.0001, @max=100>
```

## Usage

`Geometric` Designator then categorizes your to upper bucket. Anything lower then first value of a bucket gets categorized within first bucket. Anything over last bucket goes into `+` bucket.

Here are few examples:

```ruby
irb(main):002:0> designator.designate(value: -10)
=> "0.0001"
irb(main):003:0> designator.designate(value: 0.04)
=> "0.1"
irb(main):004:0> designator.designate(value: 0.32)
=> "1.0"
irb(main):005:0> designator.designate(value: 1.45)
=> "10.0"
irb(main):006:0> designator.designate(value: 45)
=> "100.0"
irb(main):007:0> designator.designate(value: 678)
=> "100.0+"
```
