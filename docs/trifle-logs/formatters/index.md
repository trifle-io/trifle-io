---
title: Formatters
description: Learn how Trifle::Logs::Formatters manipulate output.
nav_order: 6
---

# Formatters

Formatters control how each log line is rendered.

## Timestamp formatter

A timestamp formatter must implement:

```ruby
def format(timestamp)
  "..."
end
```

## Content formatter

A content formatter must implement:

```ruby
def format(scope, message)
  "..."
end
```

## Custom formatter example

```ruby
class SimpleJsonFormatter
  def format(scope, message)
    { scope: scope, message: message, version: 1 }.to_json
  end
end

Trifle::Logs.configure do |config|
  config.content_formatter = SimpleJsonFormatter.new
end
```

See the built-in implementations:
- [Timestamp](/trifle-logs/formatters/timestamp)
- [Text](/trifle-logs/formatters/text)
- [Json](/trifle-logs/formatters/json)
