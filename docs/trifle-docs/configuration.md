---
title: Configuration
nav_order: 2
---

# Configuration

You don't need to use it with Rails, but you still need to run `Trifle::Stats.configure`.

Configuration allows you to specify:
- `path` - path to a folder where your static files are located.
- `templates` - path to a template used for rendering.
- `register_harvester(HARVESTER_KLASS)` - register a Harvester class used for serving files.

Gem fallbacks to global configuration if custom configuration is not passed to method. You can do this by creating initializer, or calling it on the beginning of your ruby script.

## Global configuration

If youre running it with Rails, create `config/initializers/trifle.rb` and configure the gem.

```ruby
Trifle::Docs.configure do |config|
  config.path = File.join(Rails.root, 'docs')
  config.templates = File.join(Rails.root, 'app', 'views', 'trifle', 'docs')
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
end
```

You cannot register harvester once you call `harvester` on a configuration. It's gonna raise an exception. You've been warned.

## Custom configuration

Maybe you need to serve files from different locations rendered with different templates (documentation, blog, etc). In this case you can create multiple custom configurations. Use this configuration in the module methos (`content`, `meta`, etc).

```ruby
configuration = Trifle::Docs::Configuration.new
configuration.path = File.join(Rails.root, 'docs')
configuration.templates = File.join(Rails.root, 'app', 'views', 'trifle', 'docs')
configuration.register_harvester(Trifle::Docs::Harvester::Markdown)
configuration.register_harvester(Trifle::Docs::Harvester::File)

# and to serve blog
blog_configuration.path = File.join(Rails.root, 'blog')
blog_configuration.templates = File.join(Rails.root, 'app', 'views', 'trifle', 'blog')
blog_configuration.register_harvester(Trifle::Docs::Harvester::Markdown)
blog_configuration.register_harvester(Trifle::Docs::Harvester::File)
```

You can then pass it into module methods.

```ruby
Trifle::Docs.content(url: 'guides/installation', config: configuration)
Trifle::Docs.content(url: 'blog/2022-06-26_welcome_to_our_blog', config: blog_configuration)
```
