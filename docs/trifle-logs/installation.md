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

`Trifle::Logs` can be used independently of rails.

### Ripgrep

`Trifle::Logs` depends on `head` and `tail` ***nix** commands. It uses `ripgrep` to parse logs and return json-like output. Please follow [`ripgreps installation instruction`](https://github.com/BurntSushi/ripgrep#installation).
