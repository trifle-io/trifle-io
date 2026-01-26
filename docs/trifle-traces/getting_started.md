---
title: Getting Started
description: Learn how to start using Trifle::Traces.
nav_order: 3
---

# Getting Started

`Trifle::Traces` collects trace lines and (optionally) persists them via callbacks.

## 1) Configure callbacks

```ruby
Trifle::Traces.configure do |config|
  config.on(:wrapup) do |tracer|
    next if tracer.ignore

    Entry.create(
      key: tracer.key,
      meta: tracer.meta,
      data: tracer.data,
      state: tracer.state
    )
  end
end
```

## 2) Create a tracer and trace code

```ruby
Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(
  key: 'jobs/invoice_charge',
  meta: { job_id: 42 }
)

Trifle::Traces.trace('Charging invoice', head: true)
result = Trifle::Traces.trace('Calling gateway') do
  { status: 'ok', took_ms: 123 }
end

Trifle::Traces.tracer.wrapup
```

## 3) Inspect trace data

Each trace line is a hash with these keys: `:at`, `:message`, `:state`, `:type`, `:level`.

```ruby
keys = Trifle::Traces.tracer.data.map { |line| line.keys }.uniq
```

## Next steps

- [Usage](/trifle-traces/usage)
- [Callbacks](/trifle-traces/callbacks)
- [State](/trifle-traces/state)
- [Tags and Artifacts](/trifle-traces/tags_and_artifacts)
