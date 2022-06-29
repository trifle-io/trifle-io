---
title: Raw Hardcode Mode
nav_order: 4
---

## Raw configuration

Maybe you need to serve files from different locations rendered with different templates (documentation, blog, etc). In this case you want to go hardcore and use `Trifle::Docs` directky, you can create multiple custom configurations. Use this configuration in the module methos (`content`, `meta`, etc).

```ruby
configuration = Trifle::Docs::Configuration.new
configuration.path = File.join(Rails.root, 'docs')
configuration.template = 'default'
configuration.register_harvester(Trifle::Docs::Harvester::Markdown)
configuration.register_harvester(Trifle::Docs::Harvester::File)

# and to serve blog
blog_configuration = Trifle::Docs::Configuration.new
blog_configuration.path = File.join(Rails.root, 'blog')
blog_configuration.template = 'blog'
blog_configuration.register_harvester(Trifle::Docs::Harvester::Markdown)
blog_configuration.register_harvester(Trifle::Docs::Harvester::File)
```

You can then pass it into module methods.

```ruby
Trifle::Docs.content(url: 'guides/installation', config: configuration)
Trifle::Docs.content(url: 'blog/2022-06-26_welcome_to_our_blog', config: blog_configuration)
```
