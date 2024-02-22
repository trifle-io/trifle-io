---
title: Distribution
description: Learn how to leverage distribution calculation.
nav_order: 3
---

# Distribution

There are times when displaying distribution is really what you need. And `Trifle::Stats` got you covered! Sorry if that sounds corny.

`Trifle::Stats` uses concept of [designators](../designators) to categorize values into buckets and then increment these buckets by 1.

## Designators

There are several pre-defined designators that you can use and you can also create your own. It's purpose is to perform conversion of the payload. So lets start with simple linear designator that goes from 0 to 100 and creates buckets with size of 10.

```ruby
irb(main):001:0> designator = Trifle::Stats::Designator::Linear.new(min: 0, max: 100, step: 10)
=> #<Trifle::Stats::Designator::Linear:0x0000ffff8b0c42a8 @max=100, @min=0, @step=10>
irb(main):002:0> designator.designate(value: 15)
=> "20"
irb(main):003:0> designator.designate(value: 20)
=> "20"
irb(main):004:0> designator.designate(value: 24)
=> "30"
irb(main):005:0> designator.designate(value: 1)
=> "10"
irb(main):006:0> designator.designate(value: 98)
=> "100"
irb(main):007:0> designator.designate(value: 121)
=> "100+"
```

That should illustrate the categorization process. To track histograms, you need to run different command `.assort`.

```ruby
irb(main):001:0> require 'redis'
=> true
irb(main):002:0>
irb(main):003:1* Trifle::Stats.configure do |config|
irb(main):004:1*   config.driver = Trifle::Stats::Driver::Redis.new(Redis.new)
irb(main):005:1*   config.track_ranges = [:hour, :day]
irb(main):006:1*   config.time_zone = 'Europe/Bratislava'
irb(main):007:1*   config.beginning_of_week = :monday
irb(main):008:1*   config.designator = Trifle::Stats::Designator::Linear.new(min: 0, max: 100, step: 10)
irb(main):009:0> end
=>
#<Trifle::Stats::Configuration:0x0000ffff8d25eee0
 @beginning_of_week=:monday,
 @designator=#<Trifle::Stats::Designator::Linear:0x0000ffff8d25d540 @max=100, @min=0, @step=10>,
 @driver=#<Trifle::Stats::Driver::Redis:0x0000ffff8d25d6f8 @client=#<Redis client v4.3.1 for redis://redis:6379/0>, @prefix="trfl", @separator="::">,
 @ranges=[:minute, :hour, :day, :week, :month, :quarter, :year],
 @time_zone="Europe/Bratislava",
 @track_ranges=[:hour, :day]>
 
 irb(main):010:0> Trifle::Stats.assort(key: 'event::temperature', at: Time.now, values: { indoor: 24, outdoor: 33 })
=> [{"indoor.30"=>1, "outdoor.40"=>1}, {"indoor.30"=>1, "outdoor.40"=>1}]
 ```
 
Now you can see how your values gets converted into buckets with increments. The important part is to decide on bucket size. Increments are linear no matter how many buckets you have, but fetching values with 10 buckets will be much faster then with 10000 buckets. So make sure to make the best tradeoff for your usecase.
