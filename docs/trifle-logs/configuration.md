---
title: Configuration
description: Learn how to configure Trifle::Logs for your Ruby application.
nav_order: 2
---

# Configuration

You don’t need Rails, but you do need to configure `Trifle::Logs` before using it.

:::signature Trifle::Logs.configure
config | Trifle::Logs::Configuration | required | Global configuration object yielded to the block.
returns | Trifle::Logs::Configuration | required | The configured global instance.
:::

## Core settings

- `driver` — instance of a driver class (currently `Trifle::Logs::Driver::File`).
- `timestamp_formatter` — formats the timestamp for each log line.
- `content_formatter` — formats the payload and scope for each log line.

If a method call doesn’t receive a custom `config:`, the global configuration is used.

## Example configuration

```ruby
Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Driver::File.new(
    path: '/var/logs/trifle',
    suffix: '%Y/%m/%d',
    read_size: 200
  )
  config.timestamp_formatter = Trifle::Logs::Formatter::Timestamp.new
  config.content_formatter = Trifle::Logs::Formatter::Content::Json.new
end
```

:::callout note "About read_size"
`read_size` controls how many lines are returned per page when searching. Default is `100`.
:::

## Switching formatters

:::tabs
@tab Text
```ruby
config.content_formatter = Trifle::Logs::Formatter::Content::Text.new
```

@tab JSON
```ruby
config.content_formatter = Trifle::Logs::Formatter::Content::Json.new
```
:::

Learn more in [Formatters](/trifle-logs/formatters) and [Drivers](/trifle-logs/drivers).
