---
title: Rails with Engine
nav_order: 3
---

# Rails with Engine

If integrating `Trifle::Docs` with your Rails app through Sinatra is not good enough, you may take it one step further and integrate `Trifle::Docs` through an engine. This would allow you to use regular Rails templating to build up your templates.

## Initializer

You're gonna have to write an initializer in `config/initializers/trifle.rb` that configures `Trifle::Docs`.

```ruby
Trifle::Docs.configure do |config|
  config.path = File.join(Rails.root, 'docs')
  config.templates = File.join(Rails.root, 'app', 'views', 'trifle', 'docs')
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
end
```

And you're gonna have to mount the sinatra app in your `config/routes.rb`.

```ruby
MyRailsApp::Application.routes.draw do
  # ...
  mount Trifle::Docs::Engine, at: '/docs'
  # ...
end
```

That will do it.

## Docs

You're gonna have to write some Markdown files. Thats totally in your area. Please reffer to Harvester::Markdown for additional details. Follow [folder structure](/trifle-docs/folder_structure) documentation.

## Templates

This is where things change a bit. Instead of writing `ERB` templates (`layout.erb` and `page.erb`), you can now write `layout.html.erb` and `page.html.erb` in template location specified in configuration. If you're using HAML, you may as well write `layout.html.haml` and `page.html.haml`. The advantage is that these are now your regular templates where you can use helpers, partials, and all the goodies Rails gives you.