---
title: Usage
nav_order: 3
---

# Usage

`Trifle::Docs` comes with a couple module level methods that are shorthands for operations.

Each of these methods accepts optional custom configuration. If no configuration has been passed in, it defaults to global configuration.

## `.sitemap(config: nil)`

Returns a full tree structure of your folders. Each item includes metadata for a specific file. You can use this to generate menus or one of those sitemaps that noone uses.

## `.content(url: String, config: nil)`

Returns a HTML content of the file that can be used in a template.

## `.meta(url: String, config: nil)`

Returns a metadata of the file. This may include `title`, `template`, `nav_order` or others.

## `.collection(url: String, config: nil)`

It's a specific branch of a sitemap tree for specific `url`. This can be useful when redering list of blog articles. Instead of navigating through `.sitemap` to specific branch, you can use `.collection` to get the list.

---
Thats really all there is. You can use these methods directly and integrate it in views, or you can use build in Sinatra app.