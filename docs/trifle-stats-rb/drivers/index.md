---
title: Drivers
description: Learn how driver wraps around regular ruby drivers.
nav_order: 5
---

# Driver

Driver is a wrapper class that persists and retrieves values from backend. It needs to implement:

- `inc(keys:, **values)` method increment values for keys
- `set(keys:, **values)` method set values for keys
- `ping(key:, **values)` method that sets values for key and updates timestamp
- `get(keys:)` method to retrieve values for keys
- `scan(key:)` method that looks up for last ping received for a key

The keys array to build identifiers for objects that needs to modify or retrieve values for. Driver then decides on the optimal way to implement these actions.

## Feature Parity

Not all databases support same functionality. While it is important to keep these as close as possible, some features are not reasonable to achieve in some databases. Here is matrix of these drivers.

| Driver   | collection_name | joined_identifiers | expire_after |
|----------|-----------------|--------------------|--------------|
| Postgres | YES             | YES                | NO           |


| Column 1      | Column 2      |
| ------------- | ------------- |
| Cell 1, Row 1 | Cell 2, Row 1 |
| Cell 1, Row 2 | Cell 1, Row 2 |


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
