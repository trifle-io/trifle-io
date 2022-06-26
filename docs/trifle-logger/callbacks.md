---
title: Callbacks
nav_order: 5
---

# Callbacks

`Trifle::Logger` does not persist any data. I considered using similar approach as drivers in `Trifle::Stats`, but I decided not to. While `Trifle::Stats` handles persisting and retrieving data in the most optimal way and acts as a single point of access, retrieving log entries and referencing them is a broad topic and can be better handled on user level.

And therefore several callbacks are used that allows user to handle persistance in best possible way.

## Liftoff

Whenever tracer is initialized, `liftoff` callback is executed. Return value from last `liftoff` callback is accessible as a `tracer.reference` in next callbacks.

## Bump

To provide updates during execution, `bump` callback is executed on new `trace` calls every `bump_every` seconds.

## Wrapup

Once you finish tracing, calling `Trifle::Logger.tracer.wrapup!` will trigger `wrapup` callback.

## Simple wrapup example

Sometimes you don't care about callbacks and all you want is to create a database record that will hold your tracer data.

```ruby
Trifle::Logger.configure do |config|
  config.on(:wrapup) do |tracer|
    next if tracer.ignore

    entry = Entry.create(
      key: tracer.key,
      data: tracer.data,
      state: tracer.state
    )
  end
end
```

## Complex example

Here is more complex example with utilizing all 3 callbacks.

```ruby
Trifle::Logger.configure do |config|
  config.bump_every = 5.seconds
  config.on(:liftoff) do |tracer|
    entry = Entry.create(
      key: tracer.key,
      data: tracer.data,
      state: tracer.state
    )
    entry.id
  end

  config.on(:bump) do |tracer|
    entry = Entry.find_by(id: tracer.reference)
    next if entry.nil?

    entry.update(
      data: tracer.data,
      state: tracer.state
    )
  end

  config.on(:wrapup) do |tracer|
    entry = Entry.find_by(id: tracer.reference)
    next if entry.nil?

    # Cleanup if ignoring
    if tracer.ignore
      entry.destroy
      next
    end

    entry.update(
      data: tracer.data,
      state: tracer.state
    )
  end
end
```
