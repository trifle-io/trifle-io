---
title: File
description: Learn how File driver accesses files.
nav_order: 1
---

# File Driver

`Trifle::Logs::Driver::File` stores log lines on disk and uses `rg` + `sed` for fast searching.

## Configuration

- `path` — base folder for logs (required)
- `suffix` — time-based filename suffix (`strftime`), defaults to `'%Y/%m/%d'`
- `read_size` — lines per search page, defaults to `100`

```ruby
driver = Trifle::Logs::Driver::File.new(
  path: '/var/logs/trifle',
  suffix: '%Y/%m/%d',
  read_size: 200
)
```

### Time-based rotation

`File` driver chooses a filename based on the current timestamp. Examples:

```ruby
# monthly log
Trifle::Logs::Driver::File.new(path: '/var/logs/trifle', suffix: '%Y/%m')
# => /var/logs/trifle/<namespace>/2026/01.log

# hourly log
Trifle::Logs::Driver::File.new(path: '/var/logs/trifle', suffix: '%Y/%m/%d_%H')
# => /var/logs/trifle/<namespace>/2026/01/26_14.log
```

## Dumping logs

```ruby
driver.dump('This is a test message', namespace: 'billing')
```

## Searching logs

```ruby
result = driver.search(namespace: 'billing', pattern: 'Charged')
```

### Paging manually

```ruby
result = driver.search(namespace: 'billing', pattern: 'Charged')
next_page = driver.search(
  namespace: 'billing',
  pattern: 'Charged',
  file_loc: result.max_loc,
  direction: :next
)
```

:::callout note "Result shape"
`Result#data` returns matched lines only. `Result#meta` contains the ripgrep summary stats.
:::
