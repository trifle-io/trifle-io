---
title: Usage
description: Learn how to use Trifle::Docs DSL.
nav_order: 4
---

# Usage

`Trifle::Docs` exposes module-level methods that wrap the internal operations. Each method accepts an optional `config:` argument; if omitted, the global configuration is used.

## `sitemap(config: nil)`

:::signature Trifle::Docs.sitemap
config | Trifle::Docs::Configuration | optional | Override the global configuration.
returns | Hash | required | Full sitemap tree including `_meta` nodes.
:::

Use this to render navigation or build search indexes.

```ruby
Trifle::Docs.sitemap
# => {
#   "guides" => { "_meta" => { "title" => "Guides" }, ... },
#   "blog" => { "_meta" => { "title" => "Blog" }, ... },
#   "_meta" => { "title" => "Home" }
# }
```

## `collection(url:, config: nil)`

:::signature Trifle::Docs.collection
url | String | required | Path without leading slash (e.g., `"blog"`).
config | Trifle::Docs::Configuration | optional | Override the global configuration.
returns | Hash | required | One branch of the sitemap for the given URL.
:::

```ruby
Trifle::Docs.collection(url: 'blog')
# => { "2025-01-update" => { "_meta" => { ... } }, "_meta" => { ... } }
```

## `content(url:, config: nil)`

:::signature Trifle::Docs.content
url | String | required | Path without leading slash (e.g., `"guides/install"`).
config | Trifle::Docs::Configuration | optional | Override the global configuration.
returns | String | required | Rendered HTML content.
:::

```ruby
Trifle::Docs.content(url: 'blog/2025-01-update')
# => "<h1 id=\"...\">...</h1>..."
```

## `raw_content(url:, config: nil)`

:::signature Trifle::Docs.raw_content
url | String | required | Path without leading slash (e.g., `"guides/install"`).
config | Trifle::Docs::Configuration | optional | Override the global configuration.
returns | String | required | Raw markdown without frontmatter.
:::

```ruby
Trifle::Docs.raw_content(url: 'blog/2025-01-update')
# => "# Hello\n\nThis is raw markdown..."
```

## `meta(url:, config: nil)`

:::signature Trifle::Docs.meta
url | String | required | Path without leading slash.
config | Trifle::Docs::Configuration | optional | Override the global configuration.
returns | Hash | required | Frontmatter merged with generated metadata.
:::

Metadata always includes:
- `url` (prefixed with `namespace` when set)
- `breadcrumbs` (array of path segments)
- `toc` (HTML list of headings)
- `updated_at` (file mtime)

```ruby
Trifle::Docs.meta(url: 'blog/2025-01-update')
# => {
#   "title" => "January Update",
#   "tags" => ["release"],
#   "url" => "/blog/2025-01-update",
#   "breadcrumbs" => ["blog", "2025-01-update"],
#   "toc" => "<ul>...",
#   "updated_at" => #<Time ...>
# }
```

## `search(query:, scope: nil, config: nil)`

:::signature Trifle::Docs.search
query | String | required | Search query string.
scope | String | optional | Optional URL prefix to limit search (e.g., `"blog"`).
config | Trifle::Docs::Configuration | optional | Override the global configuration.
returns | Array<Hash> | required | Search results ordered by score.
:::

Search only runs against harvesters that expose content (Markdown). File harvesters are ignored.

```ruby
Trifle::Docs.search(query: 'traces')
# => [
#   { url: "trifle-traces/getting_started", title: "Getting Started", excerpt: "...", tags: [], score: 42 },
#   ...
# ]
```
