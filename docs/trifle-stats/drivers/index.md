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

## Performance

One note about performance of the drivers. While these are small operations against any database, these drivers differ in approach they take.

`Redis` and `Postgres` drivers are performing single inc/set operation for each key/value pair for every specified period. That means to store hash with 10 key/value pairs, it will make 10 calls to database multiplied by tracked periods. It adds up quickly.

`Mongo` on the other side supports single inc/set operation on multiple key/value pairs at a time. This allows it to make single call to database even if you are tracking 50 values for multiple periods.

Keep that in mind when working with data. If content you are tracking has simple structure, it will be just fine with `Redis` or `Postgres` driver. If your content is structured and tracks lots of values, you will do better using `Mongo` driver.

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
