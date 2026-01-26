---
title: State
description: Learn how to trace state of a log.
nav_order: 5
---

# State

Each trace line can have its own `state`, and the tracer itself has a **global** state.

## Line state

```ruby
Trifle::Traces.trace('Gateway timeout', state: :error)
```

## Trace state

Use these helpers to set the overall trace state:

- `Trifle::Traces.fail!` → sets tracer state to `:error`
- `Trifle::Traces.warn!` → sets tracer state to `:warning`
- `Trifle::Traces.tracer.success!` → sets tracer state to `:success`

```ruby
Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(key: 'jobs/invoice_charge')
Trifle::Traces.trace('Started')
Trifle::Traces.fail!
Trifle::Traces.tracer.wrapup
```

## Ignore

If a trace isn’t worth persisting, mark it as ignored.

```ruby
Trifle::Traces.ignore!
```

In your `:wrapup` callback you can drop ignored traces:

```ruby
config.on(:wrapup) do |tracer|
  next if tracer.ignore
  # persist tracer
end
```
