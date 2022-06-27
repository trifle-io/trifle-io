---
title: Trifle::Logger
nav_order: 2
---

# Trifle::Logger

[![Gem Version](https://badge.fury.io/rb/trifle-logger.svg)](https://rubygems.org/gems/trifle-logger)
[![Ruby](https://github.com/trifle-io/trifle-logger/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-logger)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-logger)

Simple logger that collects log messages and return values from blocks. And on top of that you can persist in database/storage of your choice.

`Trifle::Logger` is a _way too_ simple timeline logger that helps you track custom outputs. Ideal for any code from blackbox category (aka background-job-that-talks-to-API-and-works-every-time-when-you-run-it-manually-but-never-when-in-production type of jobs).

## Why?

If you need to track certain execution of a code and log some output, you're pretty much stuck with `Rails::Logger`. That adds bunch of output like timestamp, level and you can even extend it with some additional attributes. Unfortunately that is like using `puts` in 2022.

`Trifle::Logger` helps you to add visibility into parts of your application you never thought you needed (until you did, but then it was too late. Right?). It allows you to use tracer around your code, store text, return values, states and even artifacts all with few simple commands. It does not persist any data, but allows you to choose the storing method that fits your needs the most, all through a series of callbacks.

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
      Trifle::Logger.trace('Sending request') do
        RestClient.post('http://example.com/something', body)
      end
    end

    def body
      Trifle::Logger.trace('Building body') do
        { code: something.code, count: 100 }
      end
    end

    def something
      @something ||= Trifle::Logger.trace('Looking up record in DB') do
        Something.find(@some_id)
      end
    end
  end
end
```
