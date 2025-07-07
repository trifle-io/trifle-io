---
title: Mongo
description: Learn in depth about Mongo driver implementation.
nav_order: 4
---

# Mongo

Mongo driver uses `mongo` client gem to talk to database. It uses `bulk_write` and `find` operations for interacting with database.

## Configuration

To be able to use `Trifle::Stats::Driver::Mongo` requires few arguments to be configured correctly.

### `driver`

First required argument is a `driver`. You can configure driver directly using `mongo` gem;

```ruby
require 'mongo'

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Mongo.new(
    Mongo::Client.new('mongodb://mongo:27017/stats')
  )
end
```

Or if you are using `mongoid`, you can reuse its client setup.

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Mongo.new(
    Mongoid.client(:default)
  )
end
```

### `collection_name: 'trifle_stats' (String)`

You can specify collection name used to store `Trifle::Stats` data in MongoDB. You can pass `collection_name: 'my_stats'` keyword argument.

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Mongo.new(
    Mongo::Client.new('mongodb://mongo:27017/stats'),
    collection_name: 'my_stats'
  )
end
```

### `joined_identfier: true (Bool)`

Mongo driver supports `key` as a joined value of `key`, `range` and `at` but also supports these attributes separately. You can specify it via optional `joined_identifier: false` keyword argument. It defaults to joined configuration as it performs better. Separating these into its attributes opens you to access data directly and use other tools to visualize the content.

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Mongo.new(
    Mongo::Client.new('mongodb://mongo:27017/stats'),
    joined_identifier: false
  )
end
```

### `expire_after: nil (Integer)`

As MongoDB supports expiring indexes, it is possible to pass a `expire_after: 60` keyword argument that will set `expire_at` attribute on each upserted document 60 seconds after `at` timestamp. As of now the expiration is basic - a simple number of seconds from the tracked timestamp.

Here are some usecases where it comes handy:

- Using `beam` and `scan` where beamed metrics automatically expire after 15 seconds. `expire_after: 15`
- Tracking only past 60 minutes of a performance metrics and discarding automatically everything that is older than that. `expire_after: 60 * 60`

```ruby
Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Mongo.new(
    Mongo::Client.new('mongodb://mongo:27017/stats'),
    expire_after: 60
  )
end
```

## Setup

Mongo driver requires `trifle_stats` collection to be present. You can override `collection_name` when creating an instance of a driver. If you wish to modify joined identifier you need to pass the same argument in setup as well. For joined identifiers it creates index only for `key` and for separated identifiers it creates combined index for `key`, `range` and `at`. The downside of having keys separately is slightly (~5%-10%) slower performance due to combined index. Keep that in mind.

You can create collection and index on your own or simply call `setup!` class method that does this for you. It creates a collection and adds an unique index on a `key` attribute.

Below is a setup and configuration for a custom database and a collection name.

```ruby
client = Mongo::Client.new('mongodb://mongo:27017/stats')
Trifle::Stats::Driver::Mongo.setup!(
  Mongo::Client.new('mongodb://mongo:27017/stats'),
  collection_name: 'my_stats',
  joined_identifiers: false
)

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Mongo.new(
    Mongo::Client.new('mongodb://mongo:27017/stats'),
    collection_name: 'my_stats',
    joined_identifiers: false
  )
end
```

## Driver

You can either use your default Mongoid client, or pass in instance of custom Mongo client.

```ruby
irb(main):001:0> client = Mongo::Client.new('mongodb://mongo:27017/stats')
=> #<Mongo::Client:0x2080 cluster=#<Cluster topology=Single[mongo:27017] servers=[#<Server address=mongo:27017 STANDALONE pool=#<ConnectionPool size=0 (0-5) used=0 avail=0 pending=0>>]>>
irb(main):002:0> driver = Trifle::Stats::Driver::Mongo.new(client)
=> #<Trifle::Stats::Driver::Mongo:0x000055949646adb8 @client=#<Mongo::Client:0x2080 cluster=#<Cluster topology=Single[mongo:27017] servers=[#<Server address=mongo:27017 STANDALONE pool=#<ConnectionPool size=0 (0-5) used=0 avail=0 pending=0>>]>>, @collection_name="trifle_stats", @separator=...
```

## Interaction

Once you create instance of a driver, you can use it to `set`, `inc` or `get` your data.

```ruby
irb(main):003:0> driver.get(keys: [['test', 'now']])
=> [{}]

irb(main):004:0> driver.inc(keys: [['test', 'now']], count: 1, success: 1, error: 0)
=> #<Mongo::BulkWrite::Result:0x00005573a9148d28 @results={"n_modified"=>0, "n_upserted"=>1, "n_matched"=>0, "n"=>1, "upserted_ids"=>[BSON::ObjectId('62aabc4dca4d709bbea3719f')]}>
irb(main):005:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>1, "error"=>0, "success"=>1}]

irb(main):006:0> driver.inc(keys: [['test', 'now']], count: 1, success: 0, error: 1, account: { count: 1 })
=> #<Mongo::BulkWrite::Result:0x00005573a8dcde78 @results={"n_modified"=>1, "n_upserted"=>0, "n_matched"=>1, "n"=>1, "upserted_ids"=>[]}>
irb(main):007:0> driver.get(keys: [['test', 'now']])
=> [{"count"=>2, "error"=>1, "success"=>1, "account"=>{"count"=>1}}]
```

## Performance

All good here! `set` and `inc` are executed in one query and each key in `keys` is executed as a one bulk write operation. `get` fetches all keys in a single query.