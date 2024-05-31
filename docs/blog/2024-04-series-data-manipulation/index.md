---
title: 'Series data manipulation in Trifle::Stats'
date: '2024-04-31 15:32:33'
author: 'Jozef Vaclavik'
template: blog
---

# `Series` data manipulation in `Trifle::Stats`

The idea of `Trifle::Stats` has always been to do as little work as possible and give developers ground tools to build whatever they are building. This sounds great as a slogan, but in practice even developers don't want to go low-level on a daily basis. I've seen this myself over the time as team members had to build dashboards around tracked data. Sometimes there was a common solution how to perform calculation on tracked values. Sometimes that solution was somewhat reusable, sometimes it was not.

As I was going through the codebase they wrote to build charts, I've noticed a pattern. There are 3 main areas that kept repeating itself.
- You need to perform calculation on existing values (add, subtract, multiply, and so on)
- You need to calculate overview numbers on the values (sum, max, min, etc)
- You need to prepare values for charts (timeline, category, etc)

These are not hard problems, but it is easy to come up with different solutions to different problems. If you require strong optimisation, you may always end up with a custom solution. For everything else, `Trifle::Stats` got you covered with new `Series` object.

To make this little bit practical, lets work on actual example for dashboard one may want to build. For this example lets keep track of visitors on the website. We're gonna track these couple values:
- total number of visits
- page load time
- country
- mobile vs desktop
- browser

Here is a basic Redis configuration that we will use. The rest is gonna be default values.

```ruby

```

Now lets generate bunch of random data for a period of 30 days.

```ruby
countries = %w[]
browsers = %w[chrome safari firefox internet_explorer]
platforms = %w[mobile desktop]

while true do
  at = Time.now
  browser = browsers.sample
  platform = platforms.sample
  values = {
    visit: 1,
    time: rand(1000),
    platform: {
      platforms.sample => 1
    },
    browser {
      browsers.sample => 1
    },
    country: {
      countries.sample => 1
    }
  }
  Trifle::Stats.track('events::visitors', at: at, config: config, values: values)
end
```

## Series expansion with `transponders`



## Series calculations with `aggregators`

fdsa

## Series presentation with `formatters`

asdf
