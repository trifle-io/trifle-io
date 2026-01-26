---
title: Sidekiq
description: Learn how to integrate Trifle::Traces into Sidekiq jobs.
nav_order: 1
---

# Sidekiq

`Trifle::Traces::Middleware::Sidekiq` wraps jobs using Sidekiq server middleware.

## Configuration

A tracer is only created when the job payload includes `tracer_key`.

```ruby
class DeleteItemIfOld
  include Sidekiq::Worker
  sidekiq_options tracer_key: 'jobs/item/delete_if_old'

  def perform(item_id)
    Trifle::Traces.tag("item:#{item_id}")
    Trifle::Traces.trace('Checking item', head: true)

    if item.too_old?
      Trifle::Traces.trace('Deleting...') { item.destroy! }
    else
      Trifle::Traces.ignore!
    end
  end

  def item
    @item ||= Item.find(item_id)
  end
end
```

Inside callbacks you can access:

- `tracer.key` → the `tracer_key` value
- `tracer.meta` → job args (e.g., `[item_id]`)
