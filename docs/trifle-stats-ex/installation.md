---
title: Installation
description: Learn how to install Trifle.Stats in your Elixir application.
nav_order: 1
---

# Installation

`Trifle.Stats` can be installed by adding `trifle_stats` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [{:trifle_stats, "~> 0.1.0"}]
end
```

And then execute:

```sh
$ mix deps.get
```

## Dependencies

`Trifle.Stats` can be used independently of phoenix. Yay!

Different driver requries different client package. If you want to use Redis, you will need `redis` package included. `Trifle.Stats` does not bundle any of driver packages with it. Please read through drivers documentation for details.
