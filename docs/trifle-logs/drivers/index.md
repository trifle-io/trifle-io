---
title: Drivers
description: Learn how Trifle::Logs::Drivers manipulate files.
nav_order: 5
---

# Drivers

Drivers are responsible for writing and searching logs. A driver must implement:

## `dump(message, namespace:)`
- `message` — formatted string to write
- `namespace` — log namespace (folder)

## `search(namespace:, pattern:, file_loc: nil, direction: nil)`
- `namespace` — log namespace
- `pattern` — regex pattern (string); pass `nil` to match all lines
- `file_loc` — paging marker (e.g., `"/path/file.log#120"`)
- `direction` — `:prev` or `:next`

`search` returns a `Trifle::Logs::Result`.

### Paging example

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged')
page1 = searcher.perform
page2 = searcher.next
page0 = searcher.prev
```

Only the File driver ships with the gem today. See [File Driver](/trifle-logs/drivers/file).
