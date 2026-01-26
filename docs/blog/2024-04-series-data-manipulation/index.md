---
title: 'Series data manipulation in Trifle::Stats'
description: 'Working with the Series API for aggregates, categories, and chart-ready data.'
date: '2024-04-31 15:32:33'
author: 'Jozef Vaclavik'
template: blog
---

# `Series` data manipulation in `Trifle::Stats`

The idea of `Trifle::Stats` has always been to do as little work as possible and give developers ground tools to build whatever they are building. This sounds great as a motto, but in practice not all developers want to go low-level on a daily basis. I've seen this myself over and over as team members had to build dashboards around tracked data. Sometimes there was a common solution to performing calculation on tracked values. Sometimes this solution was somewhat reusable, most of the times it was not.

As I was going through their different approaches, I've noticed a few patterns. There are 3 main areas that kept coming up.

- You need to perform calculation on existing values (add, subtract, or multiply different values)
- You need to calculate overview numbers on the values (sum, average, etc)
- You need to prepare values for charts (timeline, category, etc)

These are not hard problems, but it is easy to come up with different solutions to each of these. If you require strong optimisation, you will most likely end up with a custom solution. For general use, `Trifle::Stats` got you covered with new `Series` object.

To illustrate `Series` object a little bit better, lets work on actual example for a dashboard _one_ may want to build. For this example lets keep track of visitors on the website. We're interested to track these values:

- total number of visits
- page load time
- country
- mobile vs desktop
- browser

Here is a basic Redis configuration that we will use. The rest is gonna fallback to default values.

```ruby
require 'redis'
configuration = Trifle::Stats::Configuration.new
configuration.driver = Trifle::Stats::Driver::Redis.new(Redis.new)
```

Now lets generate 1000 random visits over last 14 days timeframe.

```ruby
countries = %w[US UK FR SP DE PT AT CZ SK]
browsers = %w[chrome safari firefox internet_explorer]
platforms = %w[mobile desktop]

at = Time.now
1000.times do
  browser = browsers.sample
  platform = platforms.sample
  values = {
    visit: 1,
    time: rand(1000),
    platform: {
      platforms.sample => 1
    },
    browser: {
      browsers.sample => 1
    },
    country: {
      countries.sample => 1
    }
  }
  Trifle::Stats.track(key: 'events::visitors', at: at - rand(14 * 24 * 60 * 60), values: values, config: configuration)
end
```

Boom! That was quick! Am I right?

## Series or Values

This new version introduces new method `Trifle::Stats.series` that wrapes `Trifle::Stats.values` into `Trifle::Stats::Series` object. Thats really it. The reason for it is quite simple. Originally I thought of having dedicated classes that would perform actions on a values hash, but that had two main drawbacks. User had to preserve result between transponders and always had to type long class names, pass around proper arguments to do simple things. Hence why `Trifle::Stats::Series` was born. Lets see the difference between `.values` and `.series` below.

```ruby
values = Trifle::Stats.values(key: 'events::visitors', from: Time.now, to: Time.now, range: :year, config: configuration)
=> {:at=>[2024-01-01 00:00:00 +0000],
 :values=>
  [{"visit"=>"1000",
    "time"=>"499636",
    "platform"=>{"desktop"=>"501", "mobile"=>"499"},
    "browser"=>{"chrome"=>"234", "internet_explorer"=>"221", "safari"=>"265", "firefox"=>"280"},
    "country"=>{"SP"=>"114", "DE"=>"114", "UK"=>"95", "SK"=>"119", "US"=>"111", "PT"=>"100", "FR"=>"111", "AT"=>"123", "CZ"=>"113"}}]}

series = Trifle::Stats.series(key: 'events::visitors', from: Time.now, to: Time.now, range: :year, config: configuration)
=> #<Trifle::Stats::Series:0x0000ffff81045f20
 @series=
  {:at=>[2024-01-01 00:00:00 +0000],
   :values=>
    [{"visit"=>0.1e4,
      "time"=>0.499636e6,
      "platform"=>{"desktop"=>0.501e3, "mobile"=>0.499e3},
      "browser"=>{"chrome"=>0.234e3, "internet_explorer"=>0.221e3, "safari"=>0.265e3, "firefox"=>0.28e3},
      "country"=>{"SP"=>0.114e3, "DE"=>0.114e3, "UK"=>0.95e2, "SK"=>0.119e3, "US"=>0.111e3, "PT"=>0.1e3, "FR"=>0.111e3, "AT"=>0.123e3, "CZ"=>0.113e3}}]}>

```

It's kinda the same thing, but also different. All values has been converted to BigDecimals. Now let me illustrate how `Trifle::Stats::Series` makes working with values easier.

> NOTE: Getting stats for current year is a clever way to see an overview of all tracked numbers. You can see that there has been 1000 visits. Desktop had 2 more visits than Mobile. Busiest browser was Firefox and country with most visits was Austria. Cool, and now what?

## Series expansion with `transponders`

As soon as you start tracking anything more than a simple `count` you will realize you need to know whats the average value of the total events. Knowing people spend 5.7 hours on your website today and 10.1 hours yesterday doesn't provide much value if you don't know the number of visits you've had during those days.

You can always calculate average yourself by iterating over the values and dividing `time` by `count`. I know it's easy. You could also use `transponder` to add `average` to your orignal hash by doing `series.transpond.average(path: nil, count: 'visit', sum: 'time')` where `path` is set to `nil` as we want to add new value at the root of values, `count` is set to number of `visits` and `sum` is set to `time` spend on website. Average transponder then sets (locally) a key `average` on each value of a timeframe.

```ruby
series.transpond.average(path: nil, count: 'visit', sum: 'time')
=> {:at=>[2024-01-01 00:00:00 +0000],
 :values=>
  [{"visit"=>0.1e4,
    "time"=>0.499636e6,
    "platform"=>{"desktop"=>0.501e3, "mobile"=>0.499e3},
    "browser"=>{"chrome"=>0.234e3, "internet_explorer"=>0.221e3, "safari"=>0.265e3, "firefox"=>0.28e3},
    "country"=>{"SP"=>0.114e3, "DE"=>0.114e3, "UK"=>0.95e2, "SK"=>0.119e3, "US"=>0.111e3, "PT"=>0.1e3, "FR"=>0.111e3, "AT"=>0.123e3, "CZ"=>0.113e3},
    "average"=>0.499636e3}]}
```

And that is it. This now modified the values inside of `series` object by adding calculated `average`.

## Series calculations with `aggregators`

Now lets say you wanna know how many visitors you had within a specific timeframe. Like in last 30 days. And what was your highest number of visitors. You can again iterate over the values and figure out these yourself. Or you can do `series.aggregate.sum(path: 'visits')` and `series.aggregate.max(path: 'visits')` to get these faster.

In above example we loaded one year timeframe that returned single value. We don't really need to aggregate over single value. So lets load last 48h of hourly stats.

```ruby
series = Trifle::Stats.series(key: 'events::visitors', from: Time.now - 2 * 24 * 60 * 60, to: Time.now, range: :hour, config: configuration)
irb(main):106:0> series
=>
#<Trifle::Stats::Series:0x0000ffff80f80158
 @series=
  {:at=>
    [2024-06-16 11:00:00 +0000,
     2024-06-16 12:00:00 +0000,
     2024-06-16 13:00:00 +0000,
     2024-06-16 14:00:00 +0000,
     2024-06-16 15:00:00 +0000,
     2024-06-16 16:00:00 +0000,
     2024-06-16 17:00:00 +0000,
     2024-06-16 18:00:00 +0000,
     2024-06-16 19:00:00 +0000,
     2024-06-16 20:00:00 +0000,
     2024-06-16 21:00:00 +0000,
     2024-06-16 22:00:00 +0000,
     2024-06-16 23:00:00 +0000,
     2024-06-17 00:00:00 +0000,
     2024-06-17 01:00:00 +0000,
     2024-06-17 02:00:00 +0000,
     2024-06-17 03:00:00 +0000,
     2024-06-17 04:00:00 +0000,
     2024-06-17 05:00:00 +0000,
     2024-06-17 06:00:00 +0000,
     2024-06-17 07:00:00 +0000,
     2024-06-17 08:00:00 +0000,
     2024-06-17 09:00:00 +0000,
     2024-06-17 10:00:00 +0000,
     2024-06-17 11:00:00 +0000,
     2024-06-17 12:00:00 +0000,
     2024-06-17 13:00:00 +0000,
     2024-06-17 14:00:00 +0000,
     2024-06-17 15:00:00 +0000,
     2024-06-17 16:00:00 +0000,
     2024-06-17 17:00:00 +0000,
     2024-06-17 18:00:00 +0000,
     2024-06-17 19:00:00 +0000,
     2024-06-17 20:00:00 +0000,
     2024-06-17 21:00:00 +0000,
     2024-06-17 22:00:00 +0000,
     2024-06-17 23:00:00 +0000,
     2024-06-18 00:00:00 +0000,
     2024-06-18 01:00:00 +0000,
     2024-06-18 02:00:00 +0000,
     2024-06-18 03:00:00 +0000,
     2024-06-18 04:00:00 +0000,
     2024-06-18 05:00:00 +0000,
     2024-06-18 06:00:00 +0000,
     2024-06-18 07:00:00 +0000,
     2024-06-18 08:00:00 +0000,
     2024-06-18 09:00:00 +0000,
     2024-06-18 10:00:00 +0000,
     2024-06-18 11:00:00 +0000],
   :values=>
    [{"visit"=>0.4e1, "time"=>0.2584e4, "platform"=>{"mobile"=>0.2e1, "desktop"=>0.2e1}, "browser"=>{"chrome"=>0.2e1, "internet_explorer"=>0.2e1}, "country"=>{"SK"=>0.3e1, "AT"=>0.1e1}},
     {},
     {"visit"=>0.4e1, "time"=>0.2159e4, "platform"=>{"desktop"=>0.2e1, "mobile"=>0.2e1}, "browser"=>{"chrome"=>0.1e1, "firefox"=>0.3e1}, "country"=>{"SK"=>0.1e1, "FR"=>0.2e1, "AT"=>0.1e1}},
     {"visit"=>0.4e1, "time"=>0.1333e4, "platform"=>{"desktop"=>0.2e1, "mobile"=>0.2e1}, "browser"=>{"chrome"=>0.3e1, "internet_explorer"=>0.1e1}, "country"=>{"CZ"=>0.2e1, "SK"=>0.1e1, "US"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.175e3, "platform"=>{"desktop"=>0.2e1}, "browser"=>{"chrome"=>0.1e1, "safari"=>0.1e1}, "country"=>{"SP"=>0.1e1, "DE"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1437e4, "platform"=>{"desktop"=>0.2e1, "mobile"=>0.1e1}, "browser"=>{"internet_explorer"=>0.1e1, "chrome"=>0.1e1, "firefox"=>0.1e1}, "country"=>{"SK"=>0.2e1, "UK"=>0.1e1}},
     {"visit"=>0.4e1, "time"=>0.2268e4, "platform"=>{"desktop"=>0.2e1, "mobile"=>0.2e1}, "browser"=>{"internet_explorer"=>0.3e1, "chrome"=>0.1e1}, "country"=>{"AT"=>0.1e1, "SK"=>0.1e1, "CZ"=>0.1e1, "SP"=>0.1e1}},
     {"visit"=>0.7e1, "time"=>0.3568e4, "platform"=>{"mobile"=>0.5e1, "desktop"=>0.2e1}, "browser"=>{"chrome"=>0.1e1, "firefox"=>0.5e1, "internet_explorer"=>0.1e1}, "country"=>{"AT"=>0.2e1, "DE"=>0.2e1, "SK"=>0.1e1, "US"=>0.1e1, "SP"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.2127e4, "platform"=>{"mobile"=>0.3e1}, "browser"=>{"firefox"=>0.1e1, "chrome"=>0.1e1, "internet_explorer"=>0.1e1}, "country"=>{"SK"=>0.1e1, "CZ"=>0.1e1, "UK"=>0.1e1}},
     {"visit"=>0.1e1, "time"=>0.43e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"chrome"=>0.1e1}, "country"=>{"SK"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.1172e4, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.1e1}, "browser"=>{"chrome"=>0.1e1, "internet_explorer"=>0.1e1}, "country"=>{"SK"=>0.1e1, "US"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1268e4, "platform"=>{"mobile"=>0.2e1, "desktop"=>0.1e1}, "browser"=>{"internet_explorer"=>0.2e1, "firefox"=>0.1e1}, "country"=>{"CZ"=>0.2e1, "UK"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.146e3, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.1e1}, "browser"=>{"firefox"=>0.1e1, "safari"=>0.1e1}, "country"=>{"SK"=>0.1e1, "DE"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.1792e4, "platform"=>{"desktop"=>0.2e1}, "browser"=>{"chrome"=>0.2e1}, "country"=>{"SK"=>0.1e1, "SP"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1498e4, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.2e1}, "browser"=>{"safari"=>0.2e1, "internet_explorer"=>0.1e1}, "country"=>{"PT"=>0.1e1, "CZ"=>0.1e1, "AT"=>0.1e1}},
     {"visit"=>0.1e1, "time"=>0.846e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"firefox"=>0.1e1}, "country"=>{"SP"=>0.1e1}},
     {},
     {"visit"=>0.1e1, "time"=>0.332e3, "platform"=>{"desktop"=>0.1e1}, "browser"=>{"firefox"=>0.1e1}, "country"=>{"US"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.183e4, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1, "chrome"=>0.1e1}, "country"=>{"AT"=>0.1e1, "FR"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.1138e4, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1, "chrome"=>0.1e1}, "country"=>{"DE"=>0.2e1}},
     {"visit"=>0.4e1, "time"=>0.1984e4, "platform"=>{"mobile"=>0.2e1, "desktop"=>0.2e1}, "browser"=>{"safari"=>0.3e1, "chrome"=>0.1e1}, "country"=>{"DE"=>0.1e1, "UK"=>0.2e1, "PT"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.747e3, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.1e1}, "browser"=>{"chrome"=>0.1e1, "firefox"=>0.1e1}, "country"=>{"US"=>0.1e1, "SP"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.1338e4, "platform"=>{"desktop"=>0.2e1}, "browser"=>{"internet_explorer"=>0.1e1, "safari"=>0.1e1}, "country"=>{"CZ"=>0.1e1, "UK"=>0.1e1}},
     {"visit"=>0.4e1, "time"=>0.3218e4, "platform"=>{"desktop"=>0.4e1}, "browser"=>{"firefox"=>0.2e1, "internet_explorer"=>0.1e1, "chrome"=>0.1e1}, "country"=>{"UK"=>0.1e1, "SK"=>0.1e1, "CZ"=>0.2e1}},
     {"visit"=>0.2e1, "time"=>0.1171e4, "platform"=>{"mobile"=>0.2e1}, "browser"=>{"firefox"=>0.2e1}, "country"=>{"PT"=>0.1e1, "SP"=>0.1e1}},
     {"visit"=>0.4e1, "time"=>0.2398e4, "platform"=>{"desktop"=>0.3e1, "mobile"=>0.1e1}, "browser"=>{"safari"=>0.3e1, "internet_explorer"=>0.1e1}, "country"=>{"SP"=>0.1e1, "SK"=>0.1e1, "PT"=>0.1e1, "FR"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.812e3, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.1e1}, "browser"=>{"internet_explorer"=>0.1e1, "firefox"=>0.1e1}, "country"=>{"SK"=>0.1e1, "DE"=>0.1e1}},
     {"visit"=>0.8e1, "time"=>0.509e4, "platform"=>{"desktop"=>0.5e1, "mobile"=>0.3e1}, "browser"=>{"internet_explorer"=>0.2e1, "firefox"=>0.3e1, "safari"=>0.3e1}, "country"=>{"SP"=>0.2e1, "PT"=>0.1e1, "SK"=>0.1e1, "CZ"=>0.2e1, "US"=>0.1e1, "AT"=>0.1e1}},
     {"visit"=>0.1e1, "time"=>0.886e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"internet_explorer"=>0.1e1}, "country"=>{"US"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.2409e4, "platform"=>{"desktop"=>0.3e1}, "browser"=>{"firefox"=>0.1e1, "chrome"=>0.1e1, "safari"=>0.1e1}, "country"=>{"SP"=>0.1e1, "AT"=>0.1e1, "PT"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.642e3, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.1e1}, "browser"=>{"firefox"=>0.1e1, "safari"=>0.1e1}, "country"=>{"SP"=>0.1e1, "PT"=>0.1e1}},
     {"visit"=>0.5e1, "time"=>0.2562e4, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.4e1}, "browser"=>{"chrome"=>0.2e1, "safari"=>0.1e1, "internet_explorer"=>0.1e1, "firefox"=>0.1e1}, "country"=>{"PT"=>0.2e1, "AT"=>0.1e1, "CZ"=>0.2e1}},
     {"visit"=>0.1e1, "time"=>0.658e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1}, "country"=>{"DE"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.1262e4, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1, "firefox"=>0.1e1}, "country"=>{"US"=>0.1e1, "PT"=>0.1e1}},
     {"visit"=>0.1e1, "time"=>0.764e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1}, "country"=>{"UK"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.1317e4, "platform"=>{"desktop"=>0.2e1}, "browser"=>{"internet_explorer"=>0.2e1}, "country"=>{"CZ"=>0.1e1, "AT"=>0.1e1}},
     {"visit"=>0.4e1, "time"=>0.1546e4, "platform"=>{"desktop"=>0.3e1, "mobile"=>0.1e1}, "browser"=>{"chrome"=>0.2e1, "firefox"=>0.2e1}, "country"=>{"DE"=>0.1e1, "AT"=>0.1e1, "SK"=>0.1e1, "FR"=>0.1e1}},
     {"visit"=>0.4e1, "time"=>0.3119e4, "platform"=>{"desktop"=>0.4e1}, "browser"=>{"chrome"=>0.2e1, "safari"=>0.1e1, "firefox"=>0.1e1}, "country"=>{"CZ"=>0.2e1, "US"=>0.1e1, "AT"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1178e4, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.2e1}, "browser"=>{"internet_explorer"=>0.1e1, "firefox"=>0.1e1, "chrome"=>0.1e1}, "country"=>{"PT"=>0.1e1, "US"=>0.1e1, "DE"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1796e4, "platform"=>{"desktop"=>0.2e1, "mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1, "firefox"=>0.1e1, "chrome"=>0.1e1}, "country"=>{"UK"=>0.2e1, "PT"=>0.1e1}},
     {"visit"=>0.5e1, "time"=>0.1682e4, "platform"=>{"mobile"=>0.4e1, "desktop"=>0.1e1}, "browser"=>{"firefox"=>0.1e1, "safari"=>0.1e1, "internet_explorer"=>0.1e1, "chrome"=>0.2e1}, "country"=>{"UK"=>0.2e1, "DE"=>0.2e1, "PT"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1706e4, "platform"=>{"desktop"=>0.3e1}, "browser"=>{"firefox"=>0.2e1, "internet_explorer"=>0.1e1}, "country"=>{"DE"=>0.1e1, "SP"=>0.1e1, "PT"=>0.1e1}},
     {"visit"=>0.1e1, "time"=>0.725e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"internet_explorer"=>0.1e1}, "country"=>{"AT"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.114e4, "platform"=>{"desktop"=>0.1e1, "mobile"=>0.1e1}, "browser"=>{"safari"=>0.2e1}, "country"=>{"CZ"=>0.1e1, "SK"=>0.1e1}},
     {"visit"=>0.3e1, "time"=>0.1902e4, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.2e1}, "browser"=>{"internet_explorer"=>0.1e1, "firefox"=>0.1e1, "chrome"=>0.1e1}, "country"=>{"FR"=>0.2e1, "SP"=>0.1e1}},
     {"visit"=>0.1e1, "time"=>0.146e3, "platform"=>{"mobile"=>0.1e1}, "browser"=>{"safari"=>0.1e1}, "country"=>{"CZ"=>0.1e1}},
     {"visit"=>0.8e1, "time"=>0.4162e4, "platform"=>{"desktop"=>0.4e1, "mobile"=>0.4e1}, "browser"=>{"firefox"=>0.4e1, "safari"=>0.1e1, "internet_explorer"=>0.2e1, "chrome"=>0.1e1}, "country"=>{"AT"=>0.1e1, "UK"=>0.1e1, "SK"=>0.1e1, "US"=>0.4e1, "CZ"=>0.1e1}},
     {"visit"=>0.5e1, "time"=>0.2176e4, "platform"=>{"desktop"=>0.3e1, "mobile"=>0.2e1}, "browser"=>{"safari"=>0.3e1, "chrome"=>0.1e1, "internet_explorer"=>0.1e1}, "country"=>{"US"=>0.1e1, "AT"=>0.2e1, "CZ"=>0.1e1, "DE"=>0.1e1}},
     {"visit"=>0.2e1, "time"=>0.944e3, "platform"=>{"mobile"=>0.1e1, "desktop"=>0.1e1}, "browser"=>{"safari"=>0.2e1}, "country"=>{"AT"=>0.1e1, "PT"=>0.1e1}}]}>
     
```

Thats lots of values and _noise_ to go through. Lets use aggregate functions mentioned above.
     
```ruby
irb(main):109:0> series.aggregate.sum(path: 'visit')
=> [0.139e3] # 139


irb(main):112:0> series.aggregate.max(path: 'visit')
=> [0.8e1] # 8
```

You can also split these into multiple chunks or slices if you want to display comparison/trend of last slice of 24h vs previous slice of 24h.

```ruby
irb(main):111:0> series.aggregate.sum(path: 'visit', slices: 2)
=> [0.6e2, 0.75e2] # 60, 75
```

> NOTE: You may have noticed that `sum` over single split is 139 and over two splits its 135. This is not a glitch in a matrix. Our `from` and `to` unfortunately result in loading 49 items, but once you try slice it, `Trifle::Stats` automatically makes these equal parts of 24+24 ommiting the oldest value. If you scroll up, you will see that first value of visits is `4`, hence why 139 when aggregating over the whole series of values.

## Series presentation with `formatters`

Getting single number is all cool and stuff but having charts is even better. That usually requires some data manipulation to get it into shape charting library requires. This usually ends up being timeline series where you have two coordinates where one represents timestamp and the other value; or category series where one coordinate represents category and the other value. You can do this manually by iterating over timestamps and then digging a desired key from appropriate value hash and then format both of these; or you can simply do `series.format.timeline(path: 'average')` and worry only about formatting itself (if you have to).

```ruby
series.format.timeline(path: 'average')
=> [[[2024-06-16 11:00:00 +0000, 646.0],
  [2024-06-16 12:00:00 +0000, 0.0],
  [2024-06-16 13:00:00 +0000, 539.75],
  [2024-06-16 14:00:00 +0000, 333.25],
  [2024-06-16 15:00:00 +0000, 87.5],
  [2024-06-16 16:00:00 +0000, 479.0],
  [2024-06-16 17:00:00 +0000, 567.0],
  [2024-06-16 18:00:00 +0000, 509.7142857142857],
  [2024-06-16 19:00:00 +0000, 709.0],
  [2024-06-16 20:00:00 +0000, 430.0],
  [2024-06-16 21:00:00 +0000, 586.0],
  [2024-06-16 22:00:00 +0000, 422.6666666666667],
  [2024-06-16 23:00:00 +0000, 73.0],
  [2024-06-17 00:00:00 +0000, 896.0],
  [2024-06-17 01:00:00 +0000, 499.3333333333333],
  [2024-06-17 02:00:00 +0000, 846.0],
  [2024-06-17 03:00:00 +0000, 0.0],
  [2024-06-17 04:00:00 +0000, 332.0],
  [2024-06-17 05:00:00 +0000, 915.0],
  [2024-06-17 06:00:00 +0000, 569.0],
  [2024-06-17 07:00:00 +0000, 496.0],
  [2024-06-17 08:00:00 +0000, 373.5],
  [2024-06-17 09:00:00 +0000, 669.0],
  [2024-06-17 10:00:00 +0000, 804.5],
  [2024-06-17 11:00:00 +0000, 585.5],
  [2024-06-17 12:00:00 +0000, 599.5],
  [2024-06-17 13:00:00 +0000, 406.0],
  [2024-06-17 14:00:00 +0000, 636.25],
  [2024-06-17 15:00:00 +0000, 886.0],
  [2024-06-17 16:00:00 +0000, 803.0],
  [2024-06-17 17:00:00 +0000, 321.0],
  [2024-06-17 18:00:00 +0000, 512.4],
  [2024-06-17 19:00:00 +0000, 658.0],
  [2024-06-17 20:00:00 +0000, 631.0],
  [2024-06-17 21:00:00 +0000, 764.0],
  [2024-06-17 22:00:00 +0000, 658.5],
  [2024-06-17 23:00:00 +0000, 386.5],
  [2024-06-18 00:00:00 +0000, 779.75],
  [2024-06-18 01:00:00 +0000, 392.6666666666667],
  [2024-06-18 02:00:00 +0000, 598.6666666666666],
  [2024-06-18 03:00:00 +0000, 336.4],
  [2024-06-18 04:00:00 +0000, 568.6666666666666],
  [2024-06-18 05:00:00 +0000, 725.0],
  [2024-06-18 06:00:00 +0000, 570.0],
  [2024-06-18 07:00:00 +0000, 634.0],
  [2024-06-18 08:00:00 +0000, 146.0],
  [2024-06-18 09:00:00 +0000, 520.25],
  [2024-06-18 10:00:00 +0000, 435.2],
  [2024-06-18 11:00:00 +0000, 472.0]]]
  
series.format.timeline(path: 'average') { |x, y| { x: x.to_i, y: y.to_f.round(2) } }
=> [[{:x=>1718535600, :y=>646.0},
  {:x=>1718539200, :y=>0.0},
  {:x=>1718542800, :y=>539.75},
  {:x=>1718546400, :y=>333.25},
  {:x=>1718550000, :y=>87.5},
  {:x=>1718553600, :y=>479.0},
  {:x=>1718557200, :y=>567.0},
  {:x=>1718560800, :y=>509.71},
  {:x=>1718564400, :y=>709.0},
  {:x=>1718568000, :y=>430.0},
  {:x=>1718571600, :y=>586.0},
  {:x=>1718575200, :y=>422.67},
  {:x=>1718578800, :y=>73.0},
  {:x=>1718582400, :y=>896.0},
  {:x=>1718586000, :y=>499.33},
  {:x=>1718589600, :y=>846.0},
  {:x=>1718593200, :y=>0.0},
  {:x=>1718596800, :y=>332.0},
  {:x=>1718600400, :y=>915.0},
  {:x=>1718604000, :y=>569.0},
  {:x=>1718607600, :y=>496.0},
  {:x=>1718611200, :y=>373.5},
  {:x=>1718614800, :y=>669.0},
  {:x=>1718618400, :y=>804.5},
  {:x=>1718622000, :y=>585.5},
  {:x=>1718625600, :y=>599.5},
  {:x=>1718629200, :y=>406.0},
  {:x=>1718632800, :y=>636.25},
  {:x=>1718636400, :y=>886.0},
  {:x=>1718640000, :y=>803.0},
  {:x=>1718643600, :y=>321.0},
  {:x=>1718647200, :y=>512.4},
  {:x=>1718650800, :y=>658.0},
  {:x=>1718654400, :y=>631.0},
  {:x=>1718658000, :y=>764.0},
  {:x=>1718661600, :y=>658.5},
  {:x=>1718665200, :y=>386.5},
  {:x=>1718668800, :y=>779.75},
  {:x=>1718672400, :y=>392.67},
  {:x=>1718676000, :y=>598.67},
  {:x=>1718679600, :y=>336.4},
  {:x=>1718683200, :y=>568.67},
  {:x=>1718686800, :y=>725.0},
  {:x=>1718690400, :y=>570.0},
  {:x=>1718694000, :y=>634.0},
  {:x=>1718697600, :y=>146.0},
  {:x=>1718701200, :y=>520.25},
  {:x=>1718704800, :y=>435.2},
  {:x=>1718708400, :y=>472.0}]]=> 
```

This works great when you wanna plot change of variable over the time. Sometimes you just want to know the summary of all the tracked keys. For that you can use `series.format.category(path: 'browser')` and (again) worry only about how to format keys and values.

```ruby
series.format.category(path: 'browser')
=> [{"chrome"=>34.0, "internet_explorer"=>31.0, "firefox"=>40.0, "safari"=>34.0}]
```

To me, the process of building dashboards and doing analytics is always about answering questions you have over your data. Once you know what are you looking for, `Trifle::Stats` will help you answering it.

## Complete Example

Alrite, I've showed you some random bits and pieces. It kinda make sense, but lets say we wanna build a bit more full-featured example of how to prepare data for dashboard using `Series` object.

Our dashboard is gonna display last 7 days of data with some comparison to previous 7 days to illustrate change/trend. We're gonna show 7 day summary of visits and time spend on website while comparing these to previous 7 days. We will show timeline of visits and time over the whole 14 days and we will show breakdown of platforms, browsers and countries for last 7 days. Should be fun.

```ruby
now = Time.now
series = Trifle::Stats.series(key: 'events::visitors', from: now - 14 * 24 * 60 * 60, to: now, range: :day, config: configuration)
series.transpond.average(path: nil, sum: 'time', count: 'visit')

visits = series.aggregate.sum(path: 'visit', slices: 2)
=> [0.497e3, 0.457e3]
time = series.aggregate.avg(path: 'average', slices: 2)
=> [0.497103313416444937598147009241787200669142857143e3, 0.510377297662863738609105248911856486393142857143e3]

visit_series = series.format.timeline(path: 'visit', slices: 2)
=> [[[2024-06-05 00:00:00 +0000, 56.0], [2024-06-06 00:00:00 +0000, 62.0], [2024-06-07 00:00:00 +0000, 74.0], [2024-06-08 00:00:00 +0000, 74.0], [2024-06-09 00:00:00 +0000, 78.0], [2024-06-10 00:00:00 +0000, 67.0], [2024-06-11 00:00:00 +0000, 86.0]],
 [[2024-06-12 00:00:00 +0000, 73.0], [2024-06-13 00:00:00 +0000, 62.0], [2024-06-14 00:00:00 +0000, 68.0], [2024-06-15 00:00:00 +0000, 80.0], [2024-06-16 00:00:00 +0000, 74.0], [2024-06-17 00:00:00 +0000, 60.0], [2024-06-18 00:00:00 +0000, 40.0]]]

time_series = series.format.timeline(path: 'average', slices: 2) { |at, value| [at, value.to_f.round(2)] }
=> [[[2024-06-05 00:00:00 +0000, 502.77], [2024-06-06 00:00:00 +0000, 487.73], [2024-06-07 00:00:00 +0000, 523.46], [2024-06-08 00:00:00 +0000, 494.31], [2024-06-09 00:00:00 +0000, 524.97], [2024-06-10 00:00:00 +0000, 484.09], [2024-06-11 00:00:00 +0000, 462.4]],
 [[2024-06-12 00:00:00 +0000, 502.75], [2024-06-13 00:00:00 +0000, 497.0], [2024-06-14 00:00:00 +0000, 525.24], [2024-06-15 00:00:00 +0000, 460.89], [2024-06-16 00:00:00 +0000, 465.86], [2024-06-17 00:00:00 +0000, 604.0], [2024-06-18 00:00:00 +0000, 516.9]]]

platforms = series.format.category(path: 'platform', slices: 2)
=> [{"desktop"=>249.0, "mobile"=>248.0}, {"mobile"=>230.0, "desktop"=>227.0}]

browsers = series.format.category(path: 'browser', slices: 2)
=> [{"safari"=>131.0, "chrome"=>121.0, "internet_explorer"=>105.0, "firefox"=>140.0}, {"firefox"=>128.0, "chrome"=>107.0, "safari"=>119.0, "internet_explorer"=>103.0}]

countries = series.format.category(path: 'country', slices: 2)\
=> [{"US"=>57.0, "UK"=>50.0, "FR"=>52.0, "DE"=>62.0, "SP"=>60.0, "AT"=>58.0, "PT"=>46.0, "SK"=>59.0, "CZ"=>53.0}, {"DE"=>50.0, "PT"=>48.0, "FR"=>54.0, "AT"=>60.0, "UK"=>38.0, "CZ"=>58.0, "US"=>48.0, "SK"=>56.0, "SP"=>45.0}]
```

You may have noticed that we pass `slices: 2` everywhere. That is simply because we're working with 14 days of values and then are splitting these to display statistics for last 7 days vs previous 7 days. In next part, where we're gonna be displaying statistics, we're gonna pick up only the later slice.

We're not gonna do any kind of charting, but lets try to use at least tables to illustrate how that could have looked. Here is rough ERB template.

```ruby
<div>

</div>
```

And _somewhat_ rendered version would look something like this.

```ruby

```

I hope this illustrate how much simpler it is to work with data when wrapped in a `Series` object. 
