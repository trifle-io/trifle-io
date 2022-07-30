---
title: Redis
nav_order: 2
---

# Redis

Redis driver uses `redis` client gem to talk to database. It uses `hincrby`, `hmset` and `hgetall` for interacting with database.

## Configuration

Simply pass in new instance of `Redis` client.

```ruby
require 'redis'

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Redis.new(
    Redis.new(url: 'redis://redis:6379/0')
  )
end
```

## Driver

You can either use your current redis client, or pass in instance of custom redis client

```ruby
irb(main):001:0> client = Redis.new(url: 'redis://redis:6379/0')
=> #<Redis client v4.3.1 for redis://redis:6379/0>
irb(main):002:0> driver = Trifle::Stats::Driver::Redis.new(client)
=> #<Trifle::Stats::Driver::Redis:0x0000555f91cf6a98 @client=#<Redis client v4.3.1 for redis://redis:6379/0>, @prefix="trfl", @separator="::">
```

## Interaction

Once you create instance of a driver, you can use it to `set`, `inc` or `get` your data.

```ruby
irb(main):003:0> driver.get(keys: [['test', 'now']])
=> [{}]

irb(main):004:0> driver.inc(keys: [['test', 'now']], count: 1, success: 1, error: 0)
=> {"count"=>1, "success"=>1, "error"=>0}
irb(main):005:0> driver.get(keys: [['test', 'now']])
=> {"count"=>1, "success"=>1, "error"=>0}

irb(main):006:0> driver.inc(keys: [['test', 'now']], count: 1, success: 0, error: 1, account: { count: 1 })
=> {"count"=>1, "success"=>0, "error"=>1, "account.count"=>1}
irb(main):007:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>2, "success"=>1, "error"=>1, "account"=>{"count"=>1}}]
```

## Performance

`inc`, `set` operations are executed for each key/pair value separately. This may lead to degraded performance on large data set.
