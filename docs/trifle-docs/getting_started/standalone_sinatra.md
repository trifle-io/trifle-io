---
title: Standalone Sinatra
description: Learn how to integrate Trifle::Docs as a standalone Sinatra application.
nav_order: 1
---

# Standalone Sinatra App

Use this approach when you want a standalone docs site (no Rails required).

## App bootstrap

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

## Templates

Create `templates/layout.erb` and `templates/page.erb`. Add `templates/search.erb` if you want a search page. See [Templates](/trifle-docs/templates).

## Content

Write Markdown files in `docs/`. See [Folder Structure](/trifle-docs/folder_structure) and [Markdown Harvester](/trifle-docs/harvesters/markdown).
