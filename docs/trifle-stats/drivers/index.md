---
title: Drivers
nav_order: 4
---

# Driver

Driver is a wrapper class that persists and retrieves values from backend. It needs to implement:

- `inc(keys:, **values)` method increment values for keys
- `set(keys:, **values)` method set values for keys
- `get(keys:)` method to retrieve values for keys

The keys array to build identifiers for objects that needs to modify or retrieve values for. Driver then decides on the optimal way to implement these actions.

## Packer Mixin

Some databases cannot store nested hashes/values. Or they cannot perform increment on nested values that does not exist. For this reason you can use Packer mixin that helps you convert values to dot notation.

```ruby
class Sample
  include Trifle::Stats::Mixins::Packer
end

values = { a: 1, b: { c: 22, d: 33 } }
=> {:a=>1, :b=>{:c=>22, :d=>33}}

packed = Sample.pack(hash: values)
=> {"a"=>1, "b.c"=>22, "b.d"=>33}

Sample.unpack(hash: packed)
=> {"a"=>1, "b"=>{"c"=>22, "d"=>33}}
```
