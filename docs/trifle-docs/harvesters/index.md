---
title: Harvesters
description: Learn about Harvesters and their purpose in routing and rendering.
nav_order: 6
---

# Harvesters

Harvesters decide **what files match** and **how to render them**. You can use the built-in Markdown and File harvesters, or define your own.

The order you register harvesters matters. The walker tries them in order and picks the first one whose `Sieve#match?` returns `true`.

## Sieve

A `Sieve` selects files and maps them to URLs.

Required methods:
- `match?` — return `true` when the file should be handled by this harvester.
- `to_url` — return the URL path for the file.

Helpful attributes:
- `path` — root folder from configuration.
- `file` — full path to the file.

## Conveyor

A `Conveyor` loads file content and metadata.

Required methods:
- `content` — return rendered content (usually HTML).
- `meta` — return a metadata hash.

Helpful attributes:
- `file` — full path to the file.
- `data` — raw file contents.
- `url` — URL path for this file.
- `namespace` — optional prefix.
- `cache` — whether caching is enabled.

## Example: TXT harvester

```ruby
module Txt
  class Sieve < Trifle::Docs::Harvester::Sieve
    def match?
      file.end_with?('.txt')
    end

    def to_url
      file.gsub(%r{^#{path}/}, '')
          .gsub(%r{/?index\.txt}, '')
          .gsub(/\.txt/, '')
    end
  end

  class Conveyor < Trifle::Docs::Harvester::Conveyor
    def content
      @content = nil unless cache
      @content ||= "<pre>#{data}</pre>"
    end

    def meta
      {
        'title' => url.split('/').last.capitalize,
        'url' => "/#{[namespace, url].compact.join('/')}",
        'breadcrumbs' => url.split('/'),
        'updated_at' => ::File.stat(file).mtime
      }
    end
  end
end
```

:::callout warn "Register File harvester last"
`Trifle::Docs::Harvester::File` matches **any** file. Register it last so more specific harvesters (Markdown, TXT, etc.) get first dibs.
:::
