---
title: Postgres
nav_order: 2
---

# Postgres

Postgres driver uses `pg` client gem to talk to database. It uses `INSERT` with `ONCONFLICT` resolution and regular `SELECT` for interacting with database.

## Configuration

You can configure driver directly using `pg` gem;

```ruby
require 'pg'

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Postgres.new(
    PG.connect('postgresql://user:pass@postgres:5432/stats?sslmode=require)
  )
end
```

Or if you are using `rails` with `pg`, you can reuse `ActiveRecord` connection.

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Postgres.new(
    ActiveRecord::Base.connection.instance_variable_get('@connection')
  )
end
```

## Driver

You can either use your current pg connection, or pass in instance of custom pg connection.

```ruby
irb(main):001:0> client = PG::Connection.new
=> <PG::Connection:0x00007ff109a6d1f8>
irb(main):002:0> driver = Trifle::Stats::Driver::Postgres.new(client)
=> #<Trifle::Stats::Driver::Postgres:0x00007ff109c88028 @client=#<PG::Connection:0x00007ff109a6d1f8>, @table_name="trifle_stats", @separator="::">
```

## Interaction

Once you create instance of a driver, you can use it to `set`, `inc` or `get` your data.

```ruby
irb(main):003:0> driver.get(keys: [['test', 'now']])
=> [{}]

irb(main):004:0> driver.inc(keys: [['test', 'now']], count: 1, success: 1, error: 0)
=> {"count"=>1, "success"=>1, "error"=>0}
irb(main):005:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>1, "error"=>0, "success"=>1}]

irb(main):006:0> driver.inc(keys: [['test', 'now']], count: 1, success: 0, error: 1, account: { count: 1 })
=> {"count"=>1, "success"=>0, "error"=>1, "account.count"=>1}
irb(main):007:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>2, "error"=>1, "success"=>1, "account"=>{"count"=>1}}]
```

## Performance

`inc` and `set` operations are executed for each key/pair value separately. This may lead to degraded performance on large data set.

## Schema

Postgres driver requires `trifle_stats` table to be present. You can create it with following migration or use any other alternative way to create the table by yourself. Primary key column is a `string` column `key` and `data` needs to be `jsonb` format. Don't forget default value.

```ruby
create_table :trifle_stats, id: false do |t|
  t.string :key, null: false, primary_key: true
  t.jsonb :data, null: false, default: {}
end
```