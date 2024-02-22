---
title: Usage
description: Learn how to use Trifle.Stats DSL.
nav_order: 4
---

# Usage

`Trifle.Stats` comes with a couple class level functions that are shorthands for operations. They do it's thing to understand what type of operation are you trying to perform. If you pass in `at` parameter, it will know you need timeline operations, etc. There are two main function `track` and `values`. As you guessed, `track` tracks and `values` values. Duh.

`Trifle.Stats` offers most rudimental operations to build up your metrics. If you need to calculate an average value, you need to make sure to track value as well as counter. Later you can devide value by counter to calculate the average.

For example if you track your values with

```elixir
Trifle.Stats.track('event::logs', DateTime.utc_now(), %{count: 1, duration: 2, lines: 241})
[
  %Mongo.BulkWriteResult{
    acknowledged: true,
    matched_count: 0,
    modified_count: 0,
    inserted_count: 0,
    deleted_count: 0,
    upserted_count: 2,
    inserted_ids: [],
    upserted_ids: [#BSON.ObjectId<64965cdfab39049bf0498a11>,
     #BSON.ObjectId<64965cdfab39049bf0498a12>],
    errors: []
  },
  %Mongo.BulkWriteResult{
    acknowledged: true,
    matched_count: 1,
    modified_count: 1,
    inserted_count: 0,
    deleted_count: 0,
    upserted_count: 1,
    inserted_ids: [],
    upserted_ids: [#BSON.ObjectId<64965cdfab39049bf0498a14>],
    errors: []
  },
  ...
]
```

Then you can retrieve their metrics with

```elixir
Trifle.Stats.values('event::logs', DateTime.utc_now(), DateTime.utc_now(), :day)
%{
  at: [#DateTime<2023-06-24 00:00:00+02:00 CEST Europe/Bratislava>],
  values: [%{"count" => 9, "duration" => 92}]
}
```

While `track` runs increments to build up your metrics, there is also `assert` that sets values and `assort` that categorizes values.

## Ranges

Ranges are the sensitivity of data when retrieving values. Available ranges are `:minute`, `:hour`, `:day`, `:week`, `:month`, `:quarter`, `:year`.

<sub><sup>Honestly, thats it. Now instead of building your own analytics, go do something useful. You can buy me coffee later. K, thx, bye!</sup></sub>
