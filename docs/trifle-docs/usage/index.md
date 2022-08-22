---
title: Usage
nav_order: 4
---

# Usage

`Trifle::Docs` comes with a couple module level methods that are shorthands for operations.

Each of these methods accepts optional custom configuration. If no configuration has been passed in, it defaults to global configuration.

## `.sitemap(config: nil)`

Returns a full tree structure of your folders. Each item includes metadata for a specific file. You can use this to generate menus or one of those sitemaps that noone uses.

Example sitemap for Trifle documentation including only **blog** and **_meta**. To cut down too much content it uses `slice` to cut down unnecessary sitemap branches and include only `blog` branch.

```ruby
irb(main):002:0> Trifle::Docs.sitemap.slice('blog', '_meta')
=> {"blog"=>{"2022-07-introduction"=>{"_meta"=>{"title"=>"Introduction to Trifle Blog", "date"=>"2022-07-12 18:16:31", "author"=>"Jozef Vaclavik", "template"=>"blog", "url"=>"/blog/2022-07-introduction", "breadcrumbs"=>["blog", "2022-07-introduction"]}}, "_meta"=>{"title"=>"Blog", "nav_order"=>1, "template"=>"blogs", "url"=>"/blog", "breadcrumbs"=>["blog"]}}, "_meta"=>{"title"=>"Home", "url"=>"/", "breadcrumbs"=>[]}}
```

- `_meta` - holds the _metadata_ about each part of tree.

## `.content(url: String, config: nil)`

Returns a HTML content of the file that can be used in a template.

Example content for first blog post you can find here.

```ruby
irb(main):003:0> Trifle::Docs.content(url: 'blog/2022-07-introduction')
=> "<h1 id=\"welcome-to-trifle-blog\">Welcome to Trifle Blog</h1>\n\n<p>On this place you will find announcements worth announcing and other interesting <em>things</em> that occured. For example major versions, milestones and improvements. I would not hold my breath for regular updates. These are after all super-simple plugins.</p>\n\n<p>Anyways; welcome and come again!</p>\n"
```

## `.meta(url: String, config: nil)`

Returns a metadata of the file. This may include `title`, `template`, `nav_order` or others.

Example metadata for first blog post you can find here.

```ruby
irb(main):004:0> Trifle::Docs.meta(url: 'blog/2022-07-introduction')
=> {"title"=>"Introduction to Trifle Blog", "date"=>"2022-07-12 18:16:31", "author"=>"Jozef Vaclavik", "template"=>"blog", "url"=>"/blog/2022-07-introduction", "breadcrumbs"=>["blog", "2022-07-introduction"], "toc"=>"<ul>\n<li>\n<a href=\"#welcome-to-trifle-blog\">Welcome to Trifle Blog</a>\n</li>\n</ul>\n"}
```

## `.collection(url: String, config: nil)`

Returns a single branch of a sitemap tree for specific `url`. This can be useful when redering list of nested items. For example blog posts. Instead of navigating through `.sitemap` to specific branch, you can use `.collection` with `url` to get the list.

Example of collection of blog posts under `blog` url.

```ruby
irb(main):005:0> Trifle::Docs.collection(url: 'blog')
=> {"2022-07-introduction"=>{"_meta"=>{"title"=>"Introduction to Trifle Blog", "date"=>"2022-07-12 18:16:31", "author"=>"Jozef Vaclavik", "template"=>"blog", "url"=>"/blog/2022-07-introduction", "breadcrumbs"=>["blog", "2022-07-introduction"]}}, "_meta"=>{"title"=>"Blog", "nav_order"=>1, "template"=>"blogs", "url"=>"/blog", "breadcrumbs"=>["blog"]}}
```

- `_meta` - holds the _metadata_ about each part of tree.

---
Thats really all there is. You can use these methods directly and integrate it in views, or you can use build in Sinatra app.