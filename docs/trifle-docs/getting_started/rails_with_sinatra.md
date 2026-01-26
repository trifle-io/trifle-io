---
title: Rails with Sinatra
description: Learn how to integrate Trifle::Docs Sinatra app into your Rails application.
nav_order: 2
---

# Rails with Sinatra App

Use the bundled Sinatra app when you want to keep integration lightweight but still serve docs inside a Rails app.

## 1) Configure

Create an initializer at `config/initializers/trifle_docs.rb`:

```ruby
Trifle::Docs.configure do |config|
  config.path = Rails.root.join('docs')
  config.views = Rails.root.join('app', 'views', 'trifle', 'docs')
  config.namespace = 'docs'
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
end
```

## 2) Mount the app

```ruby
Rails.application.routes.draw do
  mount Trifle::Docs::App.new => '/docs'
end
```

## 3) Templates

Add `layout.erb`, `page.erb`, and optionally `search.erb` under `app/views/trifle/docs/`. See [Templates](/trifle-docs/templates) for examples.

## 4) Content

Write Markdown files under `docs/` (or whatever `config.path` points to). See [Folder Structure](/trifle-docs/folder_structure) and [Markdown Harvester](/trifle-docs/harvesters/markdown).
