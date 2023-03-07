---
title: Configuration
description: Learn how to configure Trifle::Stats for your Ruby application.
nav_order: 2
---

# Configuration

You don't need to use it with Rails, but you still need to run `Trifle::Stats.configure`.

Configuration allows you to specify:

- `driver` - backend driver used to store and retrieve data.
- `track_ranges` - list of timeline ranges you would like to track. Value must be list of symbols, defaults to `[:minute, :hour, :day, :week, :month, :quarter, :year]`.
- `separator` - keys can get serialized in backend, separator is used to join these values. Value must be string, defaults to `::`.
- `time_zone` - `TZInfo` zone to properly generate range for timeline values. Value must be valid TZ string identifier, otherwise it defaults and fallbacks to `'GMT'`.
- `beginning_of_week` - first day of week. Value must be string, defaults to `:monday`.
- `designator` - instance of Designator class used to categorize values for a Histogram. No default. Trying to `assort` without `designator` will raise an exception.

Gem fallbacks to global configuration if custom configuration is not passed to method. You can do this by creating initializer, or calling it on the beginning of your ruby script.

## Global configuration

If youre running it with Rails, create `config/initializers/trifle.rb` and configure the gem.

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Redis.new
  config.track_ranges = [:hour, :day]
  config.time_zone = 'Europe/Bratislava'
  config.beginning_of_week = :monday
  config.designator = Trifle::Stats::Designator::Linear.new(min: 0, max: 100, step: 10)
end
```

## Custom configuration

Custom configuration can be passed as a keyword argument to `Resource` objects and all module methods (`track`, `values`). This way you can pass different driver or ranges for different type of data youre storing - ie set different ranges or set expiration date on your data.

```ruby
configuration = Trifle::Stats::Configuration.new
configuration.driver = Trifle::Stats::Driver::Redis.new
configuration.track_ranges = [:day]
configuration.time_zone = 'GMT'
configuration.separator = '#'

# or use different driver
mongo_configuration = Trifle::Stats::Configuration.new
mongo_configuration.driver = Trifle::Stats::Driver::MongoDB.new
mongo_configuration.time_zone = 'Asia/Dubai'
```


You can then pass it into module methods.

```ruby
Trifle::Stats.track(key: 'event#checkout', at: Time.now, values: {count: 1}, config: configuration)

Trifle::Stats.track(key: 'event#checkout', at: Time.now, values: {count: 1}, config: mongo_configuration)
```
