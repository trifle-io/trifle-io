---
title: Callbacks
description: Learn how to use callbacks to persist your logs.
nav_order: 6
---

# Callbacks

`Trifle::Traces` does not persist anything by default. You decide where traces go by registering callbacks.

## Liftoff

Executed when a tracer is initialized. The **first** liftoff callback return value becomes `tracer.reference`.

## Bump

Executed every `bump_every` seconds while tracing. Useful for live updates.

## Wrapup

Executed when you call `tracer.wrapup`.

## Simple wrapup example

```ruby
Trifle::Traces.configure do |config|
  config.on(:wrapup) do |tracer|
    next if tracer.ignore

    Entry.create(
      key: tracer.key,
      data: tracer.data,
      state: tracer.state
    )
  end
end
```

## Full lifecycle example

```ruby
Trifle::Traces.configure do |config|
  config.bump_every = 5

  config.on(:liftoff) do |tracer|
    entry = Entry.create(key: tracer.key, data: tracer.data, state: tracer.state)
    entry.id
  end

  config.on(:bump) do |tracer|
    entry = Entry.find_by(id: tracer.reference)
    next if entry.nil?

    entry.update(data: tracer.data, state: tracer.state)
  end

  config.on(:wrapup) do |tracer|
    entry = Entry.find_by(id: tracer.reference)
    next if entry.nil?

    if tracer.ignore
      entry.destroy
      next
    end

    entry.update(data: tracer.data, state: tracer.state)
  end
end
```
