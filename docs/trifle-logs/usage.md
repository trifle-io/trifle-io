---
title: Usage
description: Learn how to use Trifle::Logs DSL.
nav_order: 4
---

# Usage

`Trifle::Logs` exposes two module-level helpers: `dump` and `searcher`.

## `dump(namespace, payload, scope: {}, config: nil)`

:::signature Trifle::Logs.dump
namespace | String | required |  | Identifier for the log namespace (folder name).
payload | Object | required |  | Data to store (string, hash, etc.).
scope | Hash | optional | `{}` | Key-value pairs included in the formatted log line.
config | Trifle::Logs::Configuration | optional | `nil` | Override global configuration.
returns | String | required |  | The formatted log line that was stored.
:::

```ruby
Trifle::Logs.dump('billing', 'Charged invoice #42')
Trifle::Logs.dump('billing', 'Charge failed', scope: { request_id: 'req-1', user_id: 7 })
```

## `searcher(namespace, pattern: nil, min_loc: nil, max_loc: nil, config: nil)`

:::signature Trifle::Logs.searcher
namespace | String | required |  | Namespace to search.
pattern | String | optional | `nil` | Regex pattern (string) for ripgrep.
min_loc | String | optional | `nil` | Location marker for previous page (`"/path/file.log#100"`).
max_loc | String | optional | `nil` | Location marker for next page (`"/path/file.log#200"`).
config | Trifle::Logs::Configuration | optional | `nil` | Override global configuration.
returns | Trifle::Logs::Operations::Searcher | required |  | Searcher instance with `perform`, `prev`, `next`.
:::

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged')
result = searcher.perform

# Page backward/forward
prev_page = searcher.prev
next_page = searcher.next
```

## Result helpers

Searcher returns a `Trifle::Logs::Result` instance.

```ruby
result.meta     # summary stats
result.data     # array of matched lines (excluding summary)
result.min_loc  # min location for prev
result.max_loc  # max location for next
```

See [Result](/trifle-logs/result) for details.
