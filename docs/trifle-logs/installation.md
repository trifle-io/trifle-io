---
title: Installation
description: Learn how to install Trifle::Logs in your Ruby application.
nav_order: 1
---

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'trifle-logs'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install trifle-logs
```

## Dependencies

`Trifle::Logs` shells out to a few standard CLI tools:

- `rg` (ripgrep) — used to parse log files and return JSON output
- `sed` — used to slice file ranges efficiently
- `wc` — used to count lines for paging

Make sure they’re available on your PATH:

```sh
command -v rg
command -v sed
command -v wc
```

`Trifle::Logs` works independently of Rails and can be used in any Ruby app.
