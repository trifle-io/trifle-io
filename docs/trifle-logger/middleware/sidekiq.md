---
title: Sidekiq
nav_order: 1
---

# Sidekiq

`Trifle::Logger::Middleware::Sidekiq` uses Sidekiq [server middleware](https://github.com/mperham/sidekiq/wiki/Middleware#server-middleware). This way execution of a sidekiq job is wrapped in `Trifle::Logger` middleware and automatically traced.

## Configuration

The only required attribute is `logger_key`. Jobs arguments are automatically set as a `meta` on a `tracer`. If `logger_key` is missing, `tracer` will not be initialized and therefore execution will not be traced.

```ruby
class DeleteItemIfOld
  include Sidekiq::Worker
  sidekiq_options logger_key: 'test/sidekiq/item/delete_if_old'

  def perform(item_id)
    @item_id = item_id
    Trifle::Logger.tag("item:#{item_id}")
    Trifle::Logger.trace('Check this out', head: true)
    if item.too_old?
      Trifle::Logger.trace('Item is too old.')
      Trifle::Logger.trace('Deleting...') { item.destroy! }
    else
      Trifle::Logger.ignore!
    end
  end

  def item
    @item ||= Item.find(@item_id)
  end
end
```

Inside of an callback you will be able to access `tracer.key` with value `'test/sidekiq/item/delete_if_old` and `tracer.meta` with value `[123]`.
