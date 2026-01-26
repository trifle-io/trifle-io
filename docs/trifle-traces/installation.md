---
title: Installation
description: Learn how to install Trifle::Traces in your Ruby application.
nav_order: 1
---

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'trifle-traces'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install trifle-traces
```

## Dependencies

`Trifle::Traces` is framework-agnostic. Rails, Sidekiq, and Rack integrations are optional.

To persist traces you must implement callbacks (see [Callbacks](/trifle-traces/callbacks)).
