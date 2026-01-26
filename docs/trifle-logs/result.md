---
title: Result
description: Learn how Result holds data from Searcher.
nav_order: 7
---

# Result

`Trifle::Logs::Result` is returned by `searcher.perform`, `searcher.prev`, and `searcher.next`.

## Key methods

- `min_loc` — location marker for previous page
- `max_loc` — location marker for next page
- `meta` — summary stats from ripgrep
- `data` — array of matching entries (JSON from `rg --json`), excluding summary rows

## Example: extracting matched lines

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged')
result = searcher.perform

lines = result.data.map { |entry| entry.dig('data', 'lines', 'text') }
```

## Example: match count

```ruby
matches = result.meta.dig('data', 'stats', 'matches')
```
