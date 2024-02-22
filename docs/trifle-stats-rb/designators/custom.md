---
title: Custom
description: Learn more how Custom designator creates buckets.
nav_order: 1
---

# Custom

`Custom` Designator allows you to specify your own buckets.

### `Trifle::Stats::Designator::Custom.new(buckets: Array)`
- `buckets` - list of buckets.

This Designator iterates over bucket options until it finds first matching bucket. That means the more buckets you specify, the slower it will perform. Keep that on your mind.

This is great for cases when you want to create somewhat narrow list of options for a histogram.

## Configuration

```ruby
irb(main):001:0> designator = Trifle::Stats::Designator::Custom.new(buckets: [1, 10, 20, 50, 100, 200, 500, 1000])
=> #<Trifle::Stats::Designator::Custom:0x000056293ab689d8 @buckets=[1, 10, 20, 50, 100, 200, 500, 1000]>
```

## Usage

`Custom` Designator then categorizes your to upper bucket. Anything lower then first value of a bucket gets categorized within first bucket. Anything over last bucket goes into `+` bucket.

Here are few examples:

```ruby
irb(main):002:0> designator.designate(value: -10)
=> "1"
irb(main):003:0> designator.designate(value: 0.04)
=> "1"
irb(main):004:0> designator.designate(value: 45)
=> "50"
irb(main):005:0> designator.designate(value: 678)
=> "1000"
irb(main):006:0> designator.designate(value: 2048)
=> "1000+"
```
