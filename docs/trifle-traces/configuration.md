---
title: Configuration
description: Learn how to configure Trifle::Traces for your Ruby application.
nav_order: 2
---

# Configuration

You can set a global configuration or build a configuration object for a specific tracer.

## Global configuration

```ruby
Trifle::Traces.configure do |config|
  config.tracer_class = Trifle::Traces::Tracer::Hash
  config.serializer_class = Trifle::Traces::Serializer::Json
  config.bump_every = 10

  config.on(:wrapup) do |tracer|
    Entry.create(key: tracer.key, data: tracer.data, state: tracer.state)
  end
end
```

### Available settings

- `tracer_class` — class used by middleware to instantiate tracers (default: `Trifle::Traces::Tracer::Hash`).
- `serializer_class` — how block return values are serialized (default: `Trifle::Traces::Serializer::Inspect`).
- `bump_every` — seconds between `:bump` callbacks (default: `15`).
- `on(:liftoff|:bump|:wrapup)` — register callbacks.

## Per-tracer configuration

If you want isolated behavior, pass a configuration object directly to a tracer.

```ruby
config = Trifle::Traces::Configuration.new
config.on(:wrapup) do |tracer|
  Entry.find(tracer.reference)&.update(data: tracer.data, state: tracer.state)
end

tracer = Trifle::Traces::Tracer::Hash.new(
  key: 'jobs/invoice_charge',
  reference: 42,
  config: config
)
```

## Serializer choice

See [Serializers](/trifle-traces/serializers) for built-in options and custom serializers.
