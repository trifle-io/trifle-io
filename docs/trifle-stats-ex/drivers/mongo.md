---
title: Mongo
description: Learn in depth about Mongo driver implementation.
nav_order: 4
---

# Mongo

Mongo driver uses `mongodb_driver` client package to talk to database. It uses `UnorderedBulk` and `find` operations for interacting with database.

## Configuration

You can configure driver directly using `mongodb_driver` package.

```elixir
{:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/stats")
driver = Trifle.Stats.Driver.Mongo.new(connection)

config = Trifle.Stats.Configuration.configure(driver, ...)
```

## Setup

Mongo driver requires `trifle_stats` collection to be present. You can override `collection_name` when creating an instance of a driver and pass your own as a second argument.

You can create collection and index on your own or simply call `setup!` function that does this for you. It creates a collection and adds an unique index on a `key` attribute.

Below is a setup and configuration for a custom database and a collection name.

```elixir
{:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/stats")
Trifle.Stats.Driver.Mongo.setup(connection, 'my_stats')

driver = Trifle.Stats.Driver.Mongo.new(connection, 'my_stats')
```


## Driver

Here is an actual example from `iex` how to create a driver.

```elixir
iex(1)> {:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/stats")
{:ok, #PID<0.850.0>}
iex(2)> driver = Trifle.Stats.Driver.Mongo.new(connection)
%Trifle.Stats.Driver.Mongo{
  connection: #PID<0.850.0>,
  collection_name: "trifle_stats",
  separator: "::",
  write_concern: 1
}
```

### Optional configuration

You can pass `collection_name`, `separator` as well as `write_concern` as following arguments. Separator is used to join values in a list into single identifiable key. Modifying write concern may speed up your stats as you may wanna skip write confirmation for heavy load apps.

```elixir
iex(1)> {:ok, connection} = Mongo.start_link(url: "mongodb://mongo:27017/stats")
{:ok, #PID<0.879.0>}
iex(2)> driver = Trifle.Stats.Driver.Mongo.new(connection, "test_stats", "--", write_concern: 0)
%Trifle.Stats.Driver.Mongo{
  connection: #PID<0.879.0>,
  collection_name: "test_stats",
  separator: "--",
  write_concern: [write_concern: 0]
}
```

## Interaction

Once you create instance of a driver, you can use it to `set`, `inc` or `get` your data.

```elixir
iex(3)> Trifle.Stats.Driver.Mongo.get([['test', 'now']], driver)
[%{}]

iex(4)> Trifle.Stats.Driver.Mongo.inc([['test', 'now']], %{"count" => 1, "success" => 1, "error" => 0}, driver)
%Mongo.BulkWriteResult{
  acknowledged: true,
  matched_count: 0,
  modified_count: 0,
  inserted_count: 0,
  deleted_count: 0,
  upserted_count: 1,
  inserted_ids: [],
  upserted_ids: [#BSON.ObjectId<64964ec5ab39049bf04982d1>],
  errors: []
}

iex(5)> Trifle.Stats.Driver.Mongo.inc([['test', 'now']], %{"count" => 1, "success" => 0, "error" => 1, "account" => %{ "count" => 1 }}, driver)
%Mongo.BulkWriteResult{
  acknowledged: true,
  matched_count: 1,
  modified_count: 1,
  inserted_count: 0,
  deleted_count: 0,
  upserted_count: 0,
  inserted_ids: [],
  upserted_ids: [],
  errors: []
}

iex(6)> Trifle.Stats.Driver.Mongo.get([['test', 'now']], driver)
[%{"account" => %{"count" => 1}, "count" => 2, "error" => 1, "success" => 1}]
```

## Performance

All good here! `set` and `inc` are executed in one query and each key in `keys` is executed as a one bulk write operation. `get` fetches all keys in a single query.
