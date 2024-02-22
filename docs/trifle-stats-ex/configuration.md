---
title: Configuration
description: Learn how to configure Trifle.Stats for your Elixir application.
nav_order: 2
---

# Configuration

You don't need to use it with Phoenix, but you still need to run `Trifle.Stats.Configuration.configure`.

Configuration allows you to specify:

- `driver` - backend driver used to store and retrieve data.
- `track_ranges` - list of timeline ranges you would like to track. Value must be list of symbols, defaults to `[:minute, :hour, :day, :week, :month, :quarter, :year]`.
- `separator` - keys can get serialized in backend, separator is used to join these values. Value must be string, defaults to `::`.
- `time_zone` - `Tzdata` zone to properly generate range for timeline values. Value must be valid TZ string identifier, otherwise it defaults and fallbacks to `'GMT'`.
- `time_zone_database` - Time Zone Database used for time zones. Duh.
- `beginning_of_week` - first day of week. Value must be string, defaults to `:monday`.

Package fallbacks to global configuration if custom configuration is not passed to method. You can do this by adding it into appropriate `config` file in Phoenix, or calling it on the beginning of your elixir script.

## Global configuration

TBA

## Custom configuration

Custom configuration can be passed as an argument to main `Trifle.Stats` class methods (`track`, `values`, etc). This way you can pass different driver or ranges for different type of data youre storing - ie set different ranges or set expiration date on your data.

```elixir
{:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/trifle")
driver = Trifle.Stats.Driver.Mongo.new(connection)
configuration = Trifle.Stats.Configuration.configure(
  driver,
  [:hour, :day, :month, :year],
  "::",
  "Europe/Bratislava",
  Tzdata.TimeZoneDatabase,
  :monday
)
```

Default `configure` function requires only `driver` to be present. The rest uses defaults. You can set these defaults values by using setter methods.

```elixir
{:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/trifle")
driver = Trifle.Stats.Driver.Mongo.new(connection)
configuration = Trifle.Stats.Configuration.configure(driver)

configuration = configuration
|> set_time_zone("Asia/Dubai")
|> set_begining_of_week(:sunday)
```

You can then pass it into class methods.

```elixir
Trifle.Stats.track('event#checkout', DateTime.utc_now(), {count: 1}, configuration)
```
