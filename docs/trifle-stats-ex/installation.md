---
title: Installation
description: Learn how to install Trifle.Stats in your Elixir application.
nav_order: 1
---

# Installation

Add `trifle_stats` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:trifle_stats, "~> 1.1"}
  ]
end
```

Then run:

```sh
$ mix deps.get
```

## Dependencies

`Trifle.Stats` can be used without Phoenix.

Driver dependencies are included in the package:
- `mongodb_driver`
- `postgrex`
- `redix`
- `exqlite`

If you only use the Process driver, you don’t need any external services running.
