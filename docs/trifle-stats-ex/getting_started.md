---
title: Getting Started
description: Learn how to start using Trifle.Stats.
nav_order: 3
---

# Getting Started

Start by adding `Trifle.Stats` into your Mix file as `{:trifle_stats, "~> 0.1.0"}` and then run `mix deps.get`.

Once you're done with that, create a global configuration. If you are doing this as a part of a Rails App, add an initializer `config/initializers/trifle.rb`; otherwise place the configuration __somewhere_ in your ruby code that gets called once your app gets launched.

Once you're done with that, create a global configuration. If you are doing this as a part of Phoenix App, add it into `config/config.exs` or appropriate environment file. Otherwise you can create a local configuration and use that.

```elixir
{:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/trifle")
driver = Trifle.Stats.Driver.Mongo.new(connection)
config = Trifle.Stats.Configuration.configure(driver, "Europe/Bratislava", Tzdata.TimeZoneDatabase, :monday, [:hour, :day], "::")
```

This configuration will create a Mongo driver that will be used to persist your metrics. It will create metrics for two ranges: per-hour and per-day. These ranges will be localized against `Europe/Bratislava` timezone.

The `beginning_of_week` setting is used if you track weekly metrics (which in above case we don't).

## Storing some metrics

Lets say for the sake of sample that we're gonna track execution of a background job that handles uploading your customers _something_ into 3rd party service. We run tons of them and need to know what/how they perform.

### The TL;DR version

If you just want to throw some metrics into `Trifle.Stats`, go ahead and run couple times following snippet.

```elixir
now = DateTime.now("Europe/Bratislava")
for i <- 0..10, i > 0, do: Trifle.Stats.track('event::uploads', DateTime.add(now, Enum.random(1..24) * -1, :hour, Tzdata.TimeZoneDatabase), %{ count: 1, duration: Enum.random(4..16) }, config)
```

What this will do is create you bunch of metrics within last 24h that will track `count` as how many times specific event happened, `duration` as how long it took it to happen and `products` as additional data related to that event.

### In depth version

It may sounds contraproductive, but one of the hardest parts of dealing with analytics is modeling your data. So before we start storing anything, lets talk a bit what we're trying to track and what will be its structure.

It doesn't matter if you use Oban, Verc or anything else. There is usually _some kind of_ `perform` method and thats all that matters now. The job from this example may have look something like this.

```elixir
defmodule UploadJob
  def perform(customer_id) do
    customer = MyApp.Business.get_customer(customer_id)
    products = MyApp.Business.list_customers_products(customer)
    
    upload(products)
  end
  
  def upload(products) do
    # the magic of uploading lives here
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

```elixir
def track(start, products) do
  Trifle.Stats.track(
    'event::uploads', DateTime.utc_now(),
    %{
      count: 1,
      duration: DateTime.diff(DateTime.utc_now(), start),
      products: List.count(products)
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

```elixir
def track(start, customer, products) do
  Trifle.Stats.track(
    'event::uploads', DateTime.utc_now(),
    %{
      count: 1,
      duration: DateTime.diff(DateTime.utc_now(), start),
      products: List.count(products),
      customers: %{
        customer.id => %{
          count: 1,
          duration: DateTime.diff(DateTime.utc_now(), start),
          products: List.count(products)
        }
      }
    }
  )
end
```

Now within the `values` you will be storing `count`, `duration` and `products` per specific customer as well. We may want to dry this up a bit as calling `DateTime.utc_now()` may result in bit different values each time you call it. So lets do something with it.

```elixir
def track(start, customer, products) do
  values = %{
    count: 1,
    duration: DateTime.diff(DateTime.utc_now(), start),
    products: List.count(products)
  }
  Trifle.Stats.track(
    'event::uploads', DateTime.utc_now(),
    Map.merge(values, %{customers: %{ customer.id => values }})
  )
end
```

Alright, now we store `values` and inside of it we merge `customers` values under each customers ID. Sounds reasonable. Here is the full job sample.

```elixir
defmodule UploadJob
  def perform(customer_id) do
    start = DateTime.utc_now()
    customer = MyApp.Business.get_customer(customer_id)
    products = MyApp.Business.list_customers_products(customer)
    
    upload(products)
    track(start, customer, product)
  end
  
  def upload(products) do
    # the magic of uploading lives here
  end

  def track(start, customer, products) do
    values = %{
      count: 1,
      duration: DateTime.diff(DateTime.utc_now(), start),
      products: List.count(products)
    }
    Trifle.Stats.track(
      'event::uploads', DateTime.utc_now(),
      Map.merge(values, %{customers: %{ customer.id => values }}),
      config()
    )
  end
  
  def config do
    Trifle.Stats.Configuration.configure(...)
  end
end
```

You may feel like by now we've already invested too much time into this. Trust me when I say that modeling your data early on will save you headaches down the road. I can already tell you that we've made a mistake by storing `duration` as a value. You can read more about that in `How to Guides`. Now lets move on to retrieving the data.

## Retrieving stats

By now you've either run the quick snippet or you let the background job be executed couple times. That means you should have some numbers stored in.

`Trifle.Stats` allows you to retrieve values for a tracked `range` and specified period between `from` and `to`.

```elixir
now = DateTime.now("Europe/Bratislava")
before = DateTime.add(now, -24, :hour, Tzdata.TimeZoneDatabase)

stats = Trifle.Stats.values('event::uploads', before, now, :hour, UploadJob.config())
```

In above case we're retrieving hourly values for last 24 hours for the `event::uploads` key. The returned data is a hash with two arrays. In first array under key `at` you receive list of timestamps and in second array under key `values` you receive list of values.

```elixir
%{
  at: [#DateTime<2023-06-23 04:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 05:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 06:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 07:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 08:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 09:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 10:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 11:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 12:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 13:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 14:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 15:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 16:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 17:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 18:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 19:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 20:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 21:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 22:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-23 23:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-24 00:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-24 01:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-24 02:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-24 03:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-24 04:00:00+02:00 CEST Europe/Bratislava>],
  values: [
    %{"count" => 6, "duration" => 70},
    %{"count" => 2, "duration" => 25},
    %{"count" => 3, "duration" => 31},
    %{"count" => 2, "duration" => 20},
    %{"count" => 2, "duration" => 9},
    %{"count" => 2, "duration" => 16},
    %{"count" => 2, "duration" => 15},
    %{"count" => 3, "duration" => 16},
    %{"count" => 3, "duration" => 19},
    %{"count" => 3, "duration" => 29},
    %{"count" => 3, "duration" => 24},
    %{"count" => 2, "duration" => 20},
    %{"count" => 2, "duration" => 24},
    %{"count" => 4, "duration" => 27},
    %{"count" => 4, "duration" => 34},
    %{"count" => 4, "duration" => 45},
    %{"count" => 5, "duration" => 52},
    %{"count" => 2, "duration" => 20},
    %{"count" => 4, "duration" => 42},
    %{"count" => 3, "duration" => 35},
    %{"count" => 3, "duration" => 26},
    %{"count" => 2, "duration" => 24},
    %{"count" => 2, "duration" => 21},
    %{"count" => 2, "duration" => 21},
    %{"count" => 3, "duration" => 25}
  ]
}
```

You may recall that in `configure` we specified that we want to track `hour` and `day`. All you need to do is to provide a desired `range`.

```elixir
iex(37)> stats = Trifle.Stats.values('event::uploads', before, now, :day, config)
%{
  at: [#DateTime<2023-06-23 00:00:00+02:00 CEST Europe/Bratislava>,
   #DateTime<2023-06-24 00:00:00+02:00 CEST Europe/Bratislava>],
  values: [
    %{"count" => 61, "duration" => 573},
    %{"count" => 9, "duration" => 92}
  ]
}
```

And thats it. Now you've successfully stored bunch of metrics in Mongo and retrieved the hourly stats for last day. I know it's simple. It's crazy simple. And you can do quite a lot with it. Check out [Case Studies](./case_studies) for some real world examples.
