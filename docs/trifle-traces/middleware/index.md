---
title: Middleware
description: Learn how to integrate Trifle::Traces into your application automatically.
nav_order: 6
---

# Middleware

While you don't need to include middleware, it gives you automatic tracing and callbacks on every rack call or sidekiq execution. You don't need to initialize tracer every time you want to trace something. Middleware does it automatically for you based on a key/meta you set.

You can read more about each middleware configuration in its own section.

## Example

All middlewares implement _fairly standard way to wrap execution_ in a block. Think of it as:

1. Yo, lets create new tracer coz we're about to start.
2. Lets yield this _thing_.
3. Dang it! We just crashed!
4. Alrite, thats all folks.

```ruby
def traced(&block)
  Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(key: trace_key)
  yield block
rescue => e
  Trifle::Traces.tracer.trace("Exception: #{e}", state: :error)
  Trifle::Traces.tracer.fail!
  raise e
ensure
  Trifle::Traces.tracer.wrapup
end
```
