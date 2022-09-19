---
title: Standalone Sinatra
description: Learn how to integrate Trifle::Docs as a standalone Sinatra application.
nav_order: 1
---

# Standalone Sinatra App

Using `Trifle::Docs` as a standalone Sinatra app works great. This website you're reading is running as standalone Sinatra app.

Now, to be fair, this kinda defeats the purpose of using `Trifle::Docs` over Static Site Generator. Coz, after all, you're not really integrating the documentation anywhere. On the other side, maybe you just prefer `Trifle::Docs` simplicity and templating over SSG like Jekyll or Hugo. Who knows. Who am I to judge.

## Sinatra App

You're gonna have to write a simple Sinatra App first.

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'trifle/docs'
require 'puma'

Trifle::Docs.configure do |config|
  config.path = File.join(__dir__, 'docs')
  config.views = File.join(__dir__, 'templates')
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
end

Trifle::Docs::App.run!
```

That was it. It's super simple. Just single `Trifle::Docs.configure` block and then run `Trifle::Docs::App.run!`. Yea, `Trifle::Docs` come with sinatra app bundled in.

## Docs

You're gonna have to write some Markdown files. Thats totally in your area. Please reffer to `Harvester::Markdown` for additional details. Follow [folder structure](/trifle-docs/folder_structure) documentation.

## Templates

As a developer you're gonna need to write (at least) two `ERB` templates. One for the `layout.erb` and one for the `page.erb`. You get couple attributes available inside of these templates that you can use to build up menus, breadcrumbs, content and whatnot. Please refer to [templates/sinatra_app](/trifle-docs/templates/sinatra_app) documentation.
