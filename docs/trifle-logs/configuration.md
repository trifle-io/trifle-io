---
title: Configuration
description: Learn how to configure Trifle::Logs for your Ruby application.
nav_order: 2
---

# Configuration

You don't need to use it with Rails, but you still need to run `Trifle::Logs.configure`.

Configuration allows you to specify:

- `driver` - instance of a driver class that manipulates your log files.
- `timestamp_formatter` - instance of a formatter class responsible for generating string from timestamp.
- `content_formatter` - instance of a formatter class responsible for generating string from content.

Gem fallbacks to global configuration if custom configuration is not passed to method. You can do this by creating initializer, or calling it on the beginning of your ruby script.

## Global configuration

```ruby
Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Driver::File.new(path: '/path/to/my/logs/folder', suffix: '%Y/%m/%d', read_size: 1000)
  config.timestamp_formatter = Trifle::Logs::Formatter::Timestamp.new
  config.content_formatter = Trifle::Logs::Formatter::Content::Json.new
end
```

Formatters are necessary for `Trifle::Logs` to know how to format your output. You can read more about them in [formatters](/trifle-logs/formatters) section.

Driver is an instance that allows `Trifle::Logs` to manipulate files. Currently only `File` driver is supported. In theory you can extend it by providing your own driver. You can read more about them in [drivers](/trifle-logs/drivers) section.
