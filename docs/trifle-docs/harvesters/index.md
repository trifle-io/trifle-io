---
title: Harvesters
nav_order: 6
---

# Harvesters

It's the class that harvests your file! You can use pre-defined harvesters, or define one of your own. There isn't that much into it.

The order of registered harvesters matters. As the `Trifle::Docs::Harvester::Walker` iterates through files, it then iterates through registered harvesters and tries find matching one through a sieve.

Every harvester needs to define two classes.

## Sieve

Purpose of a `Sieve` is to catch matching files and generate mapping URL for the file.

This class needs to implement two methods:

- `match?` - returns `true` if the file can be processed by the harvester.
- `to_url` - returns URL mapping for a router.

You also have couple instance methods available:

- `path` - returns folder for the current file.

## Conveyor

Purpose of a `Conveyor` is to retrieve data from the file. This should have form of HTML, but is not restricted to it.

This class needs to implement at least two methods:

- `content` - returns content that can be rendered (HTML) or served (file).
- `meta` - returns hash describing the content.

You also have couple instance methods available:

- `file` - returns path to the file.
- `data` - returns string content of the file.
- `url` - returns current URL for the file.
- `namespace` - returns namespace if specified in configuration.

## Example

You can get a better look at Markdown Harvester implementation, but for the purpose of illustration, lets write a simple TXT Harvester. To get some 90s nostalgia.

```ruby
module Txt
  class Sieve
    def match?
      file.end_with?('.txt')
    end

    def to_url
      file.gsub(%r{^#{path}/}, '')
          .gsub(%r{/?index\.txt}, '')
          .gsub(/\.txt/, '')
    end
  end

  class Conveyor
    def content
      @content ||= data
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

Alrite, as you can see, the `Sieve` matches any `.txt` file. The `to_url` method cleans up any `index.txt` and removes `.txt` extension to generate URL. `Conveyor` is even simpler. It _just_ passes content of a file as a `content` and prepares some _basic_ metadata for the templates.