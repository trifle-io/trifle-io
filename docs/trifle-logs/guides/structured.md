---
title: Structured Payloads
description: Store JSON payloads and search them later.
nav_order: 1
---

# Structured Payloads

Use the JSON content formatter to keep payloads machine-readable.

## Configure JSON output

```ruby
Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Driver::File.new(path: '/var/logs/trifle')
  config.timestamp_formatter = Trifle::Logs::Formatter::Timestamp.new
  config.content_formatter = Trifle::Logs::Formatter::Content::Json.new
end
```

## Store structured data

```ruby
Trifle::Logs.dump('billing', { event: 'invoice_charged', id: 42 }, scope: { request_id: 'req-1' })
```

## Search by attribute

Because everything is serialized as JSON, simple string search still works:

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'invoice_charged')
result = searcher.perform
```

If you want richer filtering, parse the JSON payload from each line inside your UI.
