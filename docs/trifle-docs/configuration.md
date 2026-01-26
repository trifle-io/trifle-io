---
title: Configuration
description: Learn how to configure Trifle::Docs for your Ruby application.
nav_order: 2
---

# Configuration

`Trifle::Docs` needs a configuration object so it knows where your files live and how to render them. You can configure it globally or pass a configuration instance into each call.

:::signature Trifle::Docs.configure
config | Trifle::Docs::Configuration | required | Global configuration object yielded to the block.
returns | Trifle::Docs::Configuration | required | The configured global instance.
:::

## Core settings

- `path` - absolute path to your documentation folder. **Required**.
- `views` - absolute path to your template folder (Sinatra app only).
- `layout` - layout name used by the Rails engine (`app/views/layouts/trifle/docs/<layout>.html.erb`).
- `namespace` - optional URL prefix used when building `meta['url']` values.
- `cache` - cache rendered content and metadata. Defaults to `true`.
- `register_harvester` - register a harvester (Markdown, File, or custom).

:::callout warn "Register harvesters before first read"
`Configuration#harvester` is created lazily. If you call `Trifle::Docs.sitemap` / `content` before registering harvesters, those harvesters won't be included. Configure once, then use.
:::

## Global configuration

:::tabs
@tab Sinatra / Global
```ruby
Trifle::Docs.configure do |config|
  config.path = Rails.root.join('docs')
  config.views = Rails.root.join('app', 'views', 'trifle', 'docs')
  config.namespace = 'docs'
  config.cache = Rails.env.production?
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
end
```

@tab Rails Engine
```ruby
Rails.application.routes.draw do
  Trifle::Docs::Engine.mount(self, namespace: 'docs') do |config|
    config.path = Rails.root.join('docs')
    config.layout = 'docs'
    config.register_harvester(Trifle::Docs::Harvester::Markdown)
    config.register_harvester(Trifle::Docs::Harvester::File)
  end

  Trifle::Docs::Engine.draw
end
```
:::

## Per-call configuration

You can build a configuration object directly and pass it into any API call.

```ruby
config = Trifle::Docs::Configuration.new
config.path = File.join(__dir__, 'docs')
config.register_harvester(Trifle::Docs::Harvester::Markdown)
config.register_harvester(Trifle::Docs::Harvester::File)

Trifle::Docs.content(url: 'getting_started', config: config)
```

If you pass a configuration explicitly, it overrides the global one for that call.
