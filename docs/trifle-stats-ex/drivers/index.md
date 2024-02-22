---
title: Drivers
description: Learn how driver wraps around regular ruby drivers.
nav_order: 5
---

# Driver

Driver is a wrapper class that persists and retrieves values from backend. It needs to implement:

- `inc(keys=List, values=Map)` method increment values for keys
- `set(keys=List, values=Map)` method set values for keys
- `get(keys=List)` method to retrieve values for keys

The keys list is used to build identifiers for objects that needs to modify or retrieve values for. Driver then decides on the optimal way to implement these actions.

## Packer Class

Some databases cannot store nested maps/values. Or they cannot perform increment on nested values that does not exist. For this reason you can use Packer class that helps you convert values to dot notation.

```elixir
iex(1)> values = %{ a: 1, b: %{ c: 22, d: 33 } }
%{a: 1, b: %{c: 22, d: 33}}

iex(2)> packed = Trifle.Stats.Packer.pack(values)
%{"a" => 1, "b.c" => 22, "b.d" => 33}

iex(3)> Trifle.Stats.Packer.unpack(packed)
%{"a" => 1, "b" => %{"c" => 22, "d" => 33}}
```
