---
title: Getting Started
description: Learn how to start using Trifle::Logs.
nav_order: 3
---

# Getting Started

## 1) Install and configure

```ruby
Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Driver::File.new(
    path: '/var/logs/trifle',
    suffix: '%Y/%m/%d',
    read_size: 200
  )
  config.timestamp_formatter = Trifle::Logs::Formatter::Timestamp.new
  config.content_formatter = Trifle::Logs::Formatter::Content::Text.new
end
```

This configuration writes logs under `/var/logs/trifle/<namespace>/YYYY/MM/DD.log` and reads 200 lines per search page.

:::callout note "Default read_size"
If you omit `read_size`, the File driver defaults to `100` lines per page.
:::

## 2) Dump logs

Use `Trifle::Logs.dump(namespace, payload, scope: {})` to store a log line.

```ruby
Trifle::Logs.dump('billing', 'Charged invoice #42')
Trifle::Logs.dump('billing', 'Charge failed', scope: { request_id: 'req-1', user_id: 7 })
```

### Example: structured JSON payloads

```ruby
Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Driver::File.new(path: '/var/logs/trifle')
  config.timestamp_formatter = Trifle::Logs::Formatter::Timestamp.new
  config.content_formatter = Trifle::Logs::Formatter::Content::Json.new
end

Trifle::Logs.dump('billing', { event: 'invoice_charged', id: 42 }, scope: { request_id: 'req-1' })
```

## 3) Search logs

Create a searcher and call `perform`:

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged')
result = searcher.perform
```

`result.data` returns the **match entries** and `result.meta` returns stats from ripgrep.

```ruby
lines = result.data.map { |line| line.dig('data', 'lines', 'text') }
```

## 4) Navigate pages

Use `prev` and `next` to move through pages. The searcher tracks `min_loc` and `max_loc` for you.

```ruby
result = searcher.perform
prev_page = searcher.prev
next_page = searcher.next
```

If you need manual paging, you can pass `min_loc` and `max_loc` yourself:

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged', min_loc: '/path/to/file.log#50')
searcher.prev
```

## Next steps

- [Usage](/trifle-logs/usage)
- [Result object](/trifle-logs/result)
- [File driver](/trifle-logs/drivers/file)
