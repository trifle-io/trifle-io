---
title: Raw Hardcode Mode
nav_order: 4
---

# Raw Hardcore Mode

At the end of the day, you don't need to use `Trifle::Docs::App` Sinatra App or `Trifle::Docs::Engine` Rails Engine to integrate with `Trifle::Docs`. You can take it one step further and do it all by yourself. After all, `app` and `engine` are really simple and all they do is parse `url` to use `Trifle::Docs` methods.

## Configuration

TODO

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
