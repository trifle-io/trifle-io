---
title: Rails with Engine
description: Learn how to integrate Trifle::Docs as a Rails Engine.
nav_order: 3
---

# Rails with Engine

Use the Rails engine when you want full Rails templates, helpers, and the ability to mount multiple documentation spaces (docs + blog, etc.).

## Routes

Add the engine mounts inside `config/routes.rb` and call `draw` once:

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

:::signature Trifle::Docs::Engine.mount
router | ActionDispatch::Routing::Mapper | required |  | The Rails router instance (usually `self` inside `routes.draw`).
namespace | String | required |  | URL prefix (e.g., `docs`, `blog`).
returns | void | required |  | Mounts the engine with a per-namespace configuration.
:::

:::signature Trifle::Docs::Engine.draw
returns | void | required |  | Adds the engine routes once (root/search/*url).
:::

## Mounting multiple namespaces

```ruby
Rails.application.routes.draw do
  Trifle::Docs::Engine.mount(self, namespace: 'blog') do |config|
    config.path = Rails.root.join('blog')
    config.layout = 'docs'
    config.register_harvester(Trifle::Docs::Harvester::Markdown)
    config.register_harvester(Trifle::Docs::Harvester::File)
  end

  Trifle::Docs::Engine.mount(self, namespace: 'docs') do |config|
    config.path = Rails.root.join('docs')
    config.layout = 'docs'
    config.register_harvester(Trifle::Docs::Harvester::Markdown)
    config.register_harvester(Trifle::Docs::Harvester::File)
  end

  Trifle::Docs::Engine.draw
end
```

This mounts `/blog` and `/docs` separately, each with its own folder and templates.

## Templates

Create templates under the `trifle/docs` namespace:

- `app/views/layouts/trifle/docs/docs.html.erb`
- `app/views/trifle/docs/page/page.html.erb`
- `app/views/trifle/docs/page/search.html.erb` (optional)

See [Templates](/trifle-docs/templates) for sample files.

## Content

Write Markdown files under the configured folder and include frontmatter for titles, nav ordering, and custom templates. See [Harvesters](/trifle-docs/harvesters/markdown) for metadata details.
