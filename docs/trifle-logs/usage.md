---
title: Usage
description: Learn how to use Trifle::Logs DSL.
nav_order: 4
---

# Usage

`Trifle::Logs` comes with a couple module level methods that are shorthands for operations.

Each of these methods accepts optional custom configuration. If no configuration has been passed in, it defaults to global configuration.

## `dump(namespace, payload, **options)`
- `namespace` - string identifier of the log path.
- `payload` - object you are planning to store. This object needs to respond to formatters serialization method. Ie `.to_s` or `.to_json`.
- `options` - hash of optional arguments:
    - `scope` - hash of identifier that will be serialized into log line and can be easily used for filtering.
    - `config` - optional configuration instance of `Trifle::Logs::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Returns a message that has been preserved.

```ruby
Trifle::Logs.dump('test', 'This is a test message that I would like to dump somewhere')
```

## `searcher(namespace, **options)`
- `namespace` - string identifier of the log path.
- `options` - hash of optional arguments:
  - `pattern` - regexp pattern used for filtering.
  - `min_loc` - minimal location identifier used as a reference when searching previous page.
  - `max_loc` - maximal location identifier used as a reference when searching next page.
  - `config` - optional configuration instance of `Trifle::Logs::Configuration`. It defaults to global configuration, otherwise uses passed in configuration.

Returns a `Result` object encapsulating search result.

```ruby
result = Trifle::Logs.searcher('test', pattern: 'test')
```
