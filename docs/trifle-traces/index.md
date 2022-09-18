---
title: Trifle::Traces
nav_order: 4
svg: M7.864 4.243A7.5 7.5 0 0119.5 10.5c0 2.92-.556 5.709-1.568 8.268M5.742 6.364A7.465 7.465 0 004.5 10.5a7.464 7.464 0 01-1.15 3.993m1.989 3.559A11.209 11.209 0 008.25 10.5a3.75 3.75 0 117.5 0c0 .527-.021 1.049-.064 1.565M12 10.5a14.94 14.94 0 01-3.6 9.75m6.633-4.596a18.666 18.666 0 01-2.485 5.33
---

# Trifle::Traces

[![Gem Version](https://badge.fury.io/rb/trifle-traces.svg)](https://rubygems.org/gems/trifle-traces)
[![Ruby](https://github.com/trifle-io/trifle-traces/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-traces)

Simple tracer that collects log messages and return values from blocks. And on top of that you can persist in database/storage of your choice.

`Trifle::Traces` is a _way too_ simple timeline tracer that helps you track custom outputs. Ideal for any code from blackbox category (aka background-job-that-talks-to-API-and-works-every-time-when-you-run-it-manually-but-never-when-in-production type of jobs).

## Why?

If you need to track certain execution of a code and log some output, you're pretty much stuck with `Rails::Logger`. That adds bunch of output like timestamp, level and you can even extend it with some additional attributes. Unfortunately that is like using `puts` in 2022.

`Trifle::Traces` helps you to add visibility into parts of your application you never thought you needed (until you did, but then it was too late. Right?). It allows you to use tracer around your code, store text, return values, states and even artifacts all with few simple commands. It does not persist any data, but allows you to choose the storing method that fits your needs the most, all through a series of callbacks.

## Before
You've probably seen code like:

```ruby
require 'rest-client'

module Cron
  class SubmitSomethingWorker
    include Sidekiq::Worker

    def perform(some_id)
      Rails.logger.info "Start processing"
      something = Something.find(some_id)
      Rails.logger.info "Found record in DB"
      body = { code: something.code, count: 100 }
      Rails.logger.info "Sending payload: #{body}"

      RestClient.post('http://example.com/something', body)
      Rails.logger.info "Done?"
    end
  end
end
```

With output like:

```
Start processing
Found record in DB
Sending payload: {code: nil, count: 100}
```

And wondering what went wrong.

## After
Why not rather:

```ruby
require 'rest-client'

module Cron
  class SubmitSomethingWorker
    include Sidekiq::Worker

    def perform(some_id)
      @some_id = some_id
      Trifle::Traces.trace('Sending request') do
        RestClient.post('http://example.com/something', body)
      end
    end

    def body
      Trifle::Traces.trace('Building body') do
        { code: something.code, count: 100 }
      end
    end

    def something
      @something ||= Trifle::Traces.trace('Looking up record in DB') do
        Something.find(@some_id)
      end
    end
  end
end
```
