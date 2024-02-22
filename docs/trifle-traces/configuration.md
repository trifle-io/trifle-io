---
title: Configuration
description: Learn how to configure Trifle::Traces for your Ruby application.
nav_order: 2
---

# Configuration

You don't need to use it with Rails, but you still need to run `Trifle::Traces.configure`.

## Global configuration

If you're running it with Rails, create `config/initializers/trifle.rb` and configure the gem.

Middleware automatically creates an instance of a tracer for you. To do that automatically, you need to provide `tracer_class` in your configuration. It defaults to `Trifle::Traces::Tracer::Hash`, but you can override it with your own custom tracer. You may want to configure custom `serializer_class` that handles block return values serialization. You can use one of pre-defined [serializer](/trifle-traces/serializers) classes or define your own. It defaults to `Trifle::Traces::Serializer::Inspect` serializer.

```ruby
Trifle::Traces.configure do |config|
  config.tracer_class = Trifle::Traces::Tracer::Hash
  config.serializer_class = Trifle::Traces::Serializer::Json
end
```

To persist your trace, you need to implement callback(s). Please read more about [Callbacks](/trifle-traces/callbacks).

## Custom configuration

Sometimes you may wanna run tracer outside of a middleware. When doing that, setting up `tracer_class` is not useful. Instead custom configuration can be passed as a keyword argument to any `Tracer` directly. This configuration will be then used during persistance callbacks.

```ruby
config = Trifle::Traces::Configuration.new
config.on(:wrapup) do |tracer|
  entry = MyModel.find_by(id: tracer.reference)
  next if entry.nil?

  entry.update(
    tracer_data: tracer.data,
    state: tracer.state
  )
end
```

Then you can create an instance of your `Tracer` with custom configuration.

```ruby
entry = MyModel.create
tracer = Trifle::Traces::Tracer::Hash.new(key: 'my_key', reference: entry.id, config: config)

tracer.trace('My message')
tracer.wrapup
```

While you don't need to use callbacks to update your record/entry, I would encourage you to do so. With callbacks you can get live updates with minimal configuration.
