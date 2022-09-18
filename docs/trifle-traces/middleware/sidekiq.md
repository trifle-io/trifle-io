---
title: Sidekiq
description: Learn how to integrate Trifle::Traces into Sidekiq jobs.
nav_order: 1
---

# Sidekiq

`Trifle::Traces::Middleware::Sidekiq` uses Sidekiq [server middleware](https://github.com/mperham/sidekiq/wiki/Middleware#server-middleware). This way execution of a sidekiq job is wrapped in `Trifle::Traces` middleware and automatically traced.

## Configuration

The only required attribute is `tracer_key`. Jobs arguments are automatically set as a `meta` on a `tracer`. If `tracer_key` is missing, `tracer` will not be initialized and therefore execution will not be traced.

```ruby
class DeleteItemIfOld
  include Sidekiq::Worker
  sidekiq_options tracer_key: 'test/sidekiq/item/delete_if_old'

  def perform(item_id)
    @item_id = item_id
    Trifle::Traces.tag("item:#{item_id}")
    Trifle::Traces.trace('Check this out', head: true)
    if item.too_old?
      Trifle::Traces.trace('Item is too old.')
      Trifle::Traces.trace('Deleting...') { item.destroy! }
    else
      Trifle::Traces.ignore!
    end
  end

  def item
    @item ||= Item.find(@item_id)
  end
end
```

Inside of an callback you will be able to access `tracer.key` with value `'test/sidekiq/item/delete_if_old` and `tracer.meta` with value `[123]`.
