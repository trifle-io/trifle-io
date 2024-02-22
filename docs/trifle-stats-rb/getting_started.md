---
title: Getting Started
description: Learn how to start using Trifle::Stats.
nav_order: 3
---

# Getting Started

Start by adding `Trifle::Stats` into your `Gemfile` as `gem 'trifle-stats'` and then run `bundle install`.

Once you're done with that, create a global configuration. If you are doing this as a part of a Rails App, add an initializer `config/initializers/trifle.rb`; otherwise place the configuration __somewhere_ in your ruby code that gets called once your app gets launched.

```ruby
require 'redis'

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Redis.new(Redis.new)
  config.track_ranges = [:hour, :day]
  config.time_zone = 'Europe/Bratislava'
  config.beginning_of_week = :monday
  config.designator = Trifle::Stats::Designator::Linear.new(min: 0, max: 100, step: 10)
end
```

This configuration will create a Redis driver that will be used to persist your metrics. It will create metrics for two ranges: per-hour and per-day. These ranges will be localized against `Europe/Bratislava` timezone.

The `beginning_of_week` setting is used if you track weekly metrics (which in above case we don't). The `designator` is used for tracking histogram distribution.

## Storing some metrics

Lets say for the sake of sample that we're gonna track execution of a background job that handles uploading your customers _something_ into 3rd party service. We run tons of them and need to know what/how they perform.

### The TL;DR version

If you just want to throw some metrics into `Trifle::Stats`, go ahead and run couple times following snippet.

```ruby
100.times do
  Trifle::Stats.track(key: 'event::uploads', at: Time.zone.now - rand(1.day), values: { count: 1, duration: rand(4..16), products: rand(20..1000) })
end
```

What this will do is create you bunch of metrics within last 24h that will track `count` as how many times specific event happened, `duration` as how long it took it to happen and `products` as additional data related to that event.

### In depth version

It may sounds contraproductive, but one of the hardest parts of dealing with analytics is modeling your data. So before we start storing anything, lets talk a bit what we're trying to track and what will be its structure.

The job from this example may have look something like this.

```ruby
class UploadJob
  include Sidekiq::Job
  
  def perform(customer_id)
    @customer_id = customer_id
    
    upload
  end
  
  def upload
    # the magic of uploading lives here
  end
  
  def products
    @products ||= Product.where(customer:)
  end

  def customer
    @customer ||= Customer.find(@customer_id)
  end
end
```

This looks pretty straight forward. Job gets triggered, and beyond setting up some `customer` and `products` logic, it only calls `upload` method that does the heavy lifting.

We would like to keep track of performance of these uploads. We definitely want to keep track of these per-customer and it seems that the upload is gonna be somewhat related to number of uploaded products.

We're gonna track these:

- `count` - how many times we executed the job/upload
- `duration` - how long it took to perform the upload
- `products` - how many products we uploaded

To be able to get duration, we need to store timestamp before we started the execution/upload. So lets add two new methods: `start` and `track`.

```ruby
def start
  @start ||= Time.zone.now
end

def track
  Trifle::Stats.track(
    key: 'event::uploads', at: Time.zone.now,
    values: {
      count: 1,
      duration: Time.zone.now - start,
      products: products.count
    }
  )
end
```

The `key` is the identifier of your metrics. You will use this later to retrieve all your metrics for a specified timeframe. The above example is still missing tracking per customer.

Here is a decision that you need to make. There are two ways to move forward from here and it really depends on "how many" items you will have in a subcategory.

- If you have only fixed and small number of customers, it is better to insert customer into main payload and retrieve all these values at once. This would allow you to display it all in a single dashboard with a single query without users need to filter anything out.
- If you have unknown number of customers that will (hopefully) grow, you may want to avoid putting everything into single key as these values would grow into huge payloads. In this case it is better to specify another tracking where customer is part of the key. Ie `"event::upload::#{customer.id}"`. And then use this customer-only key to retrieve the data.

It really depends on the usecase you have. For now, let's pretend that we have small and fixed number of customers.

We're gonna expand the `track` method bit further.

```ruby
def track
  Trifle::Stats.track(
    key: 'event::uploads', at: Time.zone.now,
    values: {
      count: 1,
      duration: Time.zone.now - start,
      products: products.count,
      customers: {
        customer.id => {
          count: 1,
          duration: Time.zone.now - start,
          products: products.count
        }
      }
    }
  )
end
```

Now within the `values` you will be storing `count`, `duration` and `products` per specific customer as well. We may want to dry this up a bit as calling `Time.zone.now` may result in bit different values each time you call it. So lets do something with it.

```ruby
def track
  values = {
    count: 1,
    duration: Time.zone.now - start,
    products: products.count
  }
  Trifle::Stats.track(
    key: 'event::uploads', at: Time.zone.now,
    values: values.merge(customers: { customer.id => values })
  )
end
```

Alright, now we store `values` and inside of it we merge `customers` values under each customers ID. Sounds reasonable. Here is the full job sample.

```ruby
class UploadJob
  include Sidekiq::Job
  
  def perform(customer_id)
    @customer_id = customer_id
    start
    
    upload
    track
  end
  
  def upload
    # the magic of uploading lives here
  end
  
  def products
    @products ||= Product.where(customer:)
  end

  def customer
    @customer ||= Customer.find(@customer_id)
  end
  
  def start
    @start ||= Time.zone.now
  end
  
  def track
    values = {
      count: 1,
      duration: Time.zone.now - start,
      products: products.count
    }
    Trifle::Stats.track(
      key: 'event::uploads', at: Time.zone.now,
      values: values.merge(customers: { customer.id => values })
    )
  end
end
```

You may feel like by now we've already invested too much time into this. Trust me when I say that modeling your data early on will save you headaches down the road. I can already tell you that we've made a mistake by storing `duration` as a value. You can read more about that in `How to Guides`. Now lets move on to retrieving the data.

## Retrieving stats

By now you've either run the quick snippet or you let the background job be executed couple times. That means you should have some numbers stored in.

`Trifle::Stats` allows you to retrieve values for a tracked `range` and specified period between `from` and `to`.

```ruby
irb(main):001:0> stats = Trifle::Stats.values(key: 'event::uploads', from: 1.day.ago, to: Time.zone.now, range: :hour)
```

In above case we're retrieving hourly values for last 24 hours for the `event::uploads` key. The returned data is a hash with two arrays. In first array under key `at` you receive list of timestamps and in second array under key `values` you receive list of values.

```ruby
=>
{:at=>
  [2023-03-04 16:00:00 +0100,
   2023-03-04 17:00:00 +0100,
   2023-03-04 18:00:00 +0100,
   2023-03-04 19:00:00 +0100,
   2023-03-04 20:00:00 +0100,
   2023-03-04 21:00:00 +0100,
   2023-03-04 22:00:00 +0100,
   2023-03-04 23:00:00 +0100,
   2023-03-05 00:00:00 +0100,
   2023-03-05 01:00:00 +0100,
   2023-03-05 02:00:00 +0100,
   2023-03-05 03:00:00 +0100,
   2023-03-05 04:00:00 +0100,
   2023-03-05 05:00:00 +0100,
   2023-03-05 06:00:00 +0100,
   2023-03-05 07:00:00 +0100,
   2023-03-05 08:00:00 +0100,
   2023-03-05 09:00:00 +0100,
   2023-03-05 10:00:00 +0100,
   2023-03-05 11:00:00 +0100,
   2023-03-05 12:00:00 +0100,
   2023-03-05 13:00:00 +0100,
   2023-03-05 14:00:00 +0100,
   2023-03-05 15:00:00 +0100],
 :values=>
  [{"count"=>5, "duration"=>58, "products"=>2551},
   {"count"=>5, "duration"=>57, "products"=>2844},
   {"count"=>2, "duration"=>24, "products"=>1400},
   {"count"=>3, "duration"=>32, "products"=>2019},
   {"count"=>7, "duration"=>74, "products"=>3248},
   {"count"=>5, "duration"=>42, "products"=>1520},
   {"count"=>4, "duration"=>33, "products"=>1668},
   {"count"=>10, "duration"=>89, "products"=>6172},
   {"count"=>2, "duration"=>23, "products"=>994},
   {"count"=>3, "duration"=>23, "products"=>1483},
   {"count"=>6, "duration"=>60, "products"=>4400},
   {"count"=>2, "duration"=>27, "products"=>796},
   {"count"=>1, "duration"=>10, "products"=>456},
   {"count"=>3, "duration"=>29, "products"=>1602},
   {"count"=>5, "duration"=>69, "products"=>2238},
   {"count"=>3, "duration"=>32, "products"=>1619},
   {"count"=>8, "duration"=>67, "products"=>4594},
   {"count"=>1, "duration"=>4, "products"=>322},
   {"count"=>1, "duration"=>9, "products"=>963},
   {"count"=>11, "duration"=>107, "products"=>6146},
   {"count"=>2, "duration"=>11, "products"=>1762},
   {"count"=>2, "duration"=>12, "products"=>1218},
   {"count"=>3, "duration"=>20, "products"=>2028},
   {"count"=>6, "duration"=>45, "products"=>3572}]}
```

You may recall that in `configure` we specified that we want to track `hour` and `day`. All you need to do is to provide a desired `range`.

```ruby
irb(main):001:0> stats = Trifle::Stats.values(key: 'event::uploads', from: 1.day.ago, to: Time.zone.now, range: :day)
=> {:at=>[2023-03-04 00:00:00 +0100, 2023-03-05 00:00:00 +0100], :values=>[{"count"=>41, "duration"=>409, "products"=>21422}, {"count"=>59, "duration"=>548, "products"=>34193}]}
```

And thats it. Now you've successfully stored bunch of metrics in Redis and retrieved the hourly stats for last day. I know it's simple. It's crazy simple. And you can do quite a lot with it. Check out [Case Studies](./case_studies) for some real world examples.
