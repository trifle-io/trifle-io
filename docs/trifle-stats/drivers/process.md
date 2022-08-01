---
title: Process
nav_order: 6
---

# Process

Because sometimes you just wanna throw some stats in the current process.

This is simple global `Hash` variable on a process. Grows over time. No expiration. Use with caution.

## Configuration

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Process.new
end
```

## Setup

No setup necessary.

## Driver

This is simple driver that stores data within itself. No configuration is necessary. You can initialize one driver and share it throughout your app, or let each thread has its own driver.

```ruby
irb(main):001:0> driver = Trifle::Stats::Driver::Process.new
=> #<Trifle::Stats::Driver::Process:0x00007fb6e30ba080 @data={}, @separator="::">
```

## Interaction

Once you create instance of a driver, you can use it to `set`, `inc` or `get` your data.

```ruby
irb(main):002:0> driver.get(keys: [['test', 'now']])
=> [{}]

irb(main):003:0> driver.inc(keys: [['test', 'now']], count: 1, success: 1, error: 0)
=> {"count"=>1, "success"=>1, "error"=>0}
irb(main):004:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>1, "success"=>1, "error"=>0}]

irb(main):005:0> driver.inc(keys: [['test', 'now']], count: 1, success: 0, error: 1, account: { count: 1 })
=> {"count"=>1, "success"=>0, "error"=>1, "account.count"=>1}
irb(main):006:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>2, "success"=>1, "error"=>1, "account"=>{"count"=>1}}]
```

## Performance

You can see data being stored on the driver object itself. Keep that on mind if you are storing lots of data in memory.

```ruby
irb(main):007:0> driver
=> #<Trifle::Stats::Driver::Process:0x000055e4b5b6cac0 @data={"test::now"=>{"count"=>2, "success"=>1, "error"=>1, "account.count"=>1}}, @separator="::">
```
