---
title: Rails with Sinatra
nav_order: 2
---

# Rails with Sinatra App

Integrating `Trifle::Docs` with Rails is where the good stuff comes in. If you wanna keep things simple, you may as well use build in Sinatra App to serve it.

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
  mount Trifle::Docs::App.new => '/docs'
  # ...
end
```

That will do it.

## Docs

You're gonna have to write some Markdown files. Thats totally in your area. Please reffer to Harvester::Markdown for additional details. Follow [folder structure](/trifle-docs/folder_structure) documentation.

## Templates

As a developer you're gonna need to write (at least) two `ERB` templates. One for the `layout.erb` and one for the `page.erb`. You get couple attributes available inside of these templates that you can use to build up menus, breadcrumbs, content and whatnot. Please refer to [templates/sinatra_app](/trifle-docs/templates/sinatra_app) documentation.