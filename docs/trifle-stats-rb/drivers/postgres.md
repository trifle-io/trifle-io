---
title: Postgres
description: Learn in depth about Postgres driver implementation.
nav_order: 3
---

# Postgres

Postgres driver uses `pg` client gem to talk to database. It uses `INSERT` with `ON CONFLICT` resolution and regular `SELECT` to interact with database.

## Configuration

You can configure driver directly using `pg` gem.

```ruby
require 'pg'

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Postgres.new(
    PG.connect('postgresql://postgres:password@postgres:5432/stats?sslmode=require')
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

## Setup

Postgres driver requires `trifle_stats` table to be present. You can override `table_name` when creating an instance of a driver.

You can create table and index on your own, using below rails migration or simply call `setup!` class method that does this for you. It creates a table and adds an unique index on a `key` column.

Use this Rails migration to create `trifle_stats` (or name it your own).

```ruby
create_table :trifle_stats, id: false do |t|
  t.string :key, null: false, primary_key: true
  t.jsonb :data, null: false, default: {}
end
```

Below is a setup and configuration for a custom database and a table name.

```ruby
Trifle::Stats::Driver::Postgres.setup!(
  PG.connect('postgresql://postgres:password@postgres:5432/stats'),
  table_name: 'my_stats'
)

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Postgres.new(
    PG.connect('postgresql://postgres:password@postgres:5432/stats'),
    table_name: 'my_stats'
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

Once you create an instance of a driver, you can use it to `set`, `inc` or `get` your data.

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

`inc` and `set` operations are executed for each key/pair value in a single query. Queries for each key in `keys` is executed in a single transaction. It also queries data in a single query for each key in `keys`.