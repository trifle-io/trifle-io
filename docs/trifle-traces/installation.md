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

`Trifle::Traces` can be used independently of rails. Yay!

In comparison to other Trifle gems, this one does not include drivers for persisting data. During configuration you need to write add a callback method that handles persistance.
