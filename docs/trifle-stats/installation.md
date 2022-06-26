---
title: Installation
nav_order: 1
---

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'trifle-stats'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install trifle-stats
```

## Dependencies

`Trifle::Stats` can be used independently of rails. Yay!

Different driver requries different client gem. If you want to use Redis, you will need `redis` gem included. `Trifle::Stats` does not bundle any of driver gems with it. Please read through drivers documentation for details.