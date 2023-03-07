---
title: DropBot
description: Learn how DropBot samples API logs.
nav_order: 1
---

# DropBot and API logs

*Link*: [dropbot.sh](https://dropbot.sh) 

At DropBot we use `Trifle::Logs` to gather a sample of 3rd party API logs. We collect request and response and store it in logs. Then search on top of it in case of debugging or simply gathering enough samples for test stubbing.

## Collection

At DropBot we're leveraging [`LegderSync`](https://www.ledgersync.dev) to build plugins that talk to 3rd party API. When building these integrations, we need to consider testing them. Having a good enough sample of requests and their responses helps us to find just the right request/response combination that we need for testing the usecase. We then build stubs for our rspec tests.

To collect the sample we use `Faraday` middleware that automatically dumps the whole faraday object into logs.

```ruby
class LogRequests < ::Faraday::Middleware
  def on_complete(env)
    namespace = URI.parse(env.url).host.gsub('.', '_')
    return unless Redis.current.get("trifle_logs_for_#{namespace}_enabled")
    
    Trifle::Logs.dump(namespace, env.to_hash)
  end
end
```

We then include this middleware in specific gems we want to track. What it does is to parse current URL and retrieve host from it. It replaces _dot_ with _underscore_ as that will be more friendly later when passing namespace into rails routes. You may have also noticed that we have a flag in redis that enables/disables logging. Sometimes, especially on high volume logs, you may want to avoid storing everything. In our case we don't need each request/response, smaller sample is enough.

## Browsing

Now that we collect API sample, we've added couple views around searcher to list logs for specific namespace. With links to load previous and next pages. Sprinkling littlebit of Turbo on top of it makes it append new lines as pages are loaded.

In this specific showcase we're collecting requests and responses against BrightData Proxy API that we integrate with. You can see filtering log lines that include `kostas` string. 

![logs](dropbot/dropbot_logs.png)

## Conclusion

At dropbot our requirement was to store _some_ logs on a shared drive and browse through it. Adding `Trifle::Logs` allows us to keep everything within our infrastructure and still get the benefit of searching on top of them. Building the views and controller adds more complexity while integrating, but at the end it allowed us to tailor the UI to our specific need.
