---
title: Raw Hardcode Mode
description: Learn how to integrate Trifle::Docs the hard way.
nav_order: 4
---

# Raw Hardcore Mode

You can skip the Sinatra app and Rails engine entirely and call `Trifle::Docs` directly. This is useful for custom frameworks or when you want full control over rendering.

## Configuration

```ruby
docs_config = Trifle::Docs::Configuration.new
docs_config.path = File.join(__dir__, 'docs')
docs_config.namespace = 'docs'
docs_config.register_harvester(Trifle::Docs::Harvester::Markdown)
docs_config.register_harvester(Trifle::Docs::Harvester::File)
```

You can create multiple configs if you want separate content roots:

```ruby
blog_config = Trifle::Docs::Configuration.new
blog_config.path = File.join(__dir__, 'blog')
blog_config.namespace = 'blog'
blog_config.register_harvester(Trifle::Docs::Harvester::Markdown)
blog_config.register_harvester(Trifle::Docs::Harvester::File)
```

## Rendering manually

```ruby
url = 'getting_started'
meta = Trifle::Docs.meta(url: url, config: docs_config)
content = Trifle::Docs.content(url: url, config: docs_config)
collection = Trifle::Docs.collection(url: url, config: docs_config)
sitemap = Trifle::Docs.sitemap(config: docs_config)
```

Use these values in your own templates or view renderer. If `meta['type'] == 'file'`, serve the file directly instead of rendering HTML.
