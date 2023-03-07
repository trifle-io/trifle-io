---
title: DropBot
description: Learn how DropBot keeps track of background jobs.
nav_order: 1
---

# DropBot and Background Jobs

*Link*: [dropbot.sh](https://dropbot.sh) 

At DropBot we use `Trifle::Traces` to keep track of executions of many different background jobs. Our application performs millions of background jobs each day. Some of these are internal and others are synchronization jobs.

One side of our business is price calculation of a product. In its core, this is an long equation that takes multiple input variables and produces a result that holds a calculated value.

One of our core principles has been to ensure we have visibility into our system. Running the calculation job and storing _just_ the result does not qualify as visibility. We wanted to avoid having bunch of `puts` or `logger` statements and then trying to sort out whats happening in log aggregation service like DataDog. While they are great at what they are doing, it's even better to simply collect these by yourself.

We use `Trifle::Traces` to add notes, results and debugging statements during the execution of a job. We started quite simple. At first we simply stored the execution traces in a MongoDB. This went well at first. Unfortunately later we added more types of tracing and it started having troubles once we introduced logs with large payloads. For performance reasons, we moved these payloads to S3 and now we use MongoDB only to store references and metadata about executions for easy navigation and lookup.

![list](dropbot/list.png)

The above page is a combination of `Trifle::Traces` and `Trifle::Stats` that gives us visibility into execution of Calculate Job. The real value of `Trifle::Traces` comes once you view the execution trace.

To be able to generate a whole trace, we had to _annotate_ our code with lots of `.trace` statements. At first it felt like forced change, but as we got used to it, we started structuring our code and really took advantage of block statements.

```ruby
def main_product
  @main_product ||= Trifle::Traces.trace('Fetching Main product') do
    Commodity::Product::Detail.find_by(
      store_id: main_store_id, store_uid: main_store_uid, zipcode:
    )
  end
end
```

This allowed us to have shorter single-purposed methods that use variable caching and still trace it during execution.

![calculation](dropbot/calculation.png)

`Trifle::Traces` gave us ability to follow the execution and see exactly what happened and how the final state or number has been calculated. And in the world of debugging, that's priceless.
