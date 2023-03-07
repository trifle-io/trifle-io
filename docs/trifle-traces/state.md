---
title: State
description: Learn how to trace state of a log.
nav_order: 5
---

# State

Using `Trifle::Traces.trace('Test', state: :error)` is great way to indicate state of the line. This does not change state of a whole trace. To determine if the execution failed at some point, you would have to go through the each line and evaluate its state. There are better ways to achieve this. `Trifle::Traces` allows you to set state for the whole trace (ie: indicate failed execution).

Use of states is completely optional.

## Lifecycle

Below is a lifecycle of a trace.

### Running

When `tracer` has been initialized, the default state is `:running`. This way you can indicate that current execution is still being processed.

At the end of an execution, you may wanna change to one of these states:

### Error

Use `Trifle::Traces.fail!` to set state to `:error`.

### Warning

Use `Trifle::Traces.warn!` to set state to `:warning`.

### Success

Use `Trifle::Traces.success!` to set state to `:success`. You know, in case that everything goes according to plan.

## Ignore

In case that during execution you determine that it is not worth persisting the tracer, you can flag the trace with `Trifle::Traces.ignore!`. In `wrapup` callback you can then evaluate if trace should be ignored or no and act accordingly.

For example you are using `Trifle::Traces` to trace background job that talks to API. You don't care if everything goes according to plan, only about executions when API returns 502 (coz why not).

```ruby
Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(key: 'my_trace')
Trifle::Traces.trace('Testing state output')

begin
  client = RestClient.get('https://google.com/admin')
  Trifle::Traces.success!
rescue RestClient::Unauthorized, RestClient::Forbidden => err
  Trifle::Traces.trace("Uh oh, I'm unauthorized", error: true) { err.response }
  Trifle::Traces.fail!
rescue RestClient::ImATeapot
  # wut?
  Trifle::Traces.ignore!
end

unless Trifle::Traces.tracer.ignore
  if Trifle::Traces.success?
    # dump your tracer into your favourite storage
  else
    # use red line to call Mr. President coz world is about to end
  end
end
```
