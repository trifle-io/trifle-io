---
title: Configuration
description: Learn how to configure Trifle::Docs for your Ruby application.
nav_order: 2
---

# Configuration

You don't need to use it with Rails, but you still need to run `Trifle::Logs.configure`.

Configuration allows you to specify:

- `path` - path to a folder where your static files are located.
- `views` - path to a views folder used for rendering (Sinatra App).
- `template` - name of a rails template (Rails Engine).
- `register_harvester(HARVESTER_KLASS)` - register a Harvester class used for serving files.
- `cache` - boolean to enable or disable content cache. Defaults to `true`.

Gem fallbacks to global configuration if custom configuration is not passed to method. You can do this by creating initializer, or calling it on the beginning of your ruby script.

Unfortunately there are three ways to configure `Trifle::Docs`. And that depends on the way you plan to use it. Please refer to [getting started](getting_started) documentation for configuration for your usecase.

## Global configuration

```ruby
Trifle::Docs.configure do |config|
  config.path = File.join(Rails.root, 'docs')
  config.templates = File.join(Rails.root, 'app', 'views', 'trifle', 'docs')
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
  config.cache = Rails.env.production?
end
```

You cannot register harvester once you call `harvester` on a configuration. It's gonna raise an exception. You've been warned.
