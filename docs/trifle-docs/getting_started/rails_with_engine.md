---
title: Rails with Engine
description: Learn how to integrate Trifle::Docs as a Rails Engine.
nav_order: 3
---

# Rails with Engine

If integrating `Trifle::Docs` with your Rails app through Sinatra is not good enough, you may take it one step further and integrate `Trifle::Docs` through an engine.

Integrating with Rails through Engine allows you to expand integration in two significant ways:
- you can use Rails templating to build up your templates.
- you can mount engine multiple times to render several pages (docs, blog, etc.)

## Routes

Integrating `Trifle::Docs::Engine` into your Rails application happens in your `config/routes.rb` file.

You're gonna have to write an initializer in `config/initializers/trifle.rb` that configures `Trifle::Docs`.

```ruby
Rails.application.routes.draw do
  Trifle::Docs::Engine.mount(self, namespace: 'docs') do |config|
    config.path = 'static/docs'
    config.layout = 'simple'
    config.register_harvester(Trifle::Docs::Harvester::Markdown)
    config.register_harvester(Trifle::Docs::Harvester::File)
  end
  Trifle::Docs::Engine.draw
end
```

There are two parts here. `mount` and `draw` happens independently as you can `mount` engine multiple times, but you can `draw` its routes only once. I dunno who made this, but it is what it is.


### `Trifle::Docs::Engine.mount(self, namespace: String)`

Allows you to mount `Trifle::Docs::Engine` into specific namespace and create configuration specific for this engine. Instead of providing path to `config.views`, you have to provide `config.layout` with a name of a layout you want to use.

### `Trifle::Docs::Engine.draw`

Loads `Trifle::Docs::Engine` routes into your main router app.

### Mounting multiple engines

You may wanna use `Trifle::Docs` to render several _parts_ of your app. In this case you need to `mount` and configure each _part_ separately.

```ruby
Rails.application.routes.draw do
  Trifle::Docs::Engine.mount(self, namespace: 'blog') do |config|
    config.path = 'files/blog'
    config.layout = 'simple'
    config.register_harvester(Trifle::Docs::Harvester::Markdown)
    config.register_harvester(Trifle::Docs::Harvester::File)
  end

  Trifle::Docs::Engine.mount(self, namespace: 'docs') do |config|
    config.path = 'files/docs'
    config.layout = 'simple'
    config.register_harvester(Trifle::Docs::Harvester::Markdown)
    config.register_harvester(Trifle::Docs::Harvester::File)
  end

  Trifle::Docs::Engine.draw
end
```

This way you will end up with `files/blog` being rendered as `/blog` and `files/docs` being rendered as `/docs`. Noice!

## Docs

You're gonna have to write some Markdown files. Thats totally in your area. Please reffer to `Harvester::Markdown` for additional details. Follow [folder structure](/trifle-docs/folder_structure) documentation.

## Templates

This is where things change a bit. Instead of writing `ERB` templates (`layout.erb` and `page.erb`), you can now write `app/views/layouts/trifle/docs/default.html.erb` and `app/views/trifle/docs/page/page.html.erb`. If you're using HAML, you may as well write `layout.html.haml` and `page.html.haml`.

The advantage is that these are now your regular templates where you can use helpers, partials, and all the goodies Rails gives you.

Rails will expect all templates to be under `trifle/docs` namespace. `Trifle::Docs::Engine` is using `Trifle::Docs::PageController` to render content, which means the specific templates used to render pages needs to be under `trifle/docs/page` folder.
