---
title: Templates
description: Learn how to write templates and pages.
nav_order: 7
---

# Templates

Templates are intentionally simple. You provide a layout and one or more page templates, and Trifle::Docs renders your content into them.

## Template locations

:::tabs
@tab Sinatra App
If you use `Trifle::Docs::App`, set `config.views` to a folder that contains:

- `layout.erb`
- `page.erb`
- `search.erb` (optional, for `/search`)

Example structure:

```
templates/
├── layout.erb
├── page.erb
└── search.erb
```

@tab Rails Engine
With the Rails engine, use Rails view conventions:

- `app/views/layouts/trifle/docs/<layout>.html.erb`
- `app/views/trifle/docs/page/page.html.erb`
- `app/views/trifle/docs/page/search.html.erb`

Example structure:

```
app/views/
├── layouts/trifle/docs/docs.html.erb
└── trifle/docs/page/
    ├── page.html.erb
    └── search.html.erb
```
:::

## Template variables

Both the layout and page templates receive the same locals:

- `sitemap` — full sitemap tree.
- `collection` — subtree for the current URL.
- `content` — rendered HTML for the current page.
- `meta` — frontmatter + generated metadata (title, url, breadcrumbs, toc, updated_at).
- `url` — current URL path.

## Example templates

:::tabs
@tab Sinatra layout.erb
```erb
<!DOCTYPE html>
<html lang="en">
  <head>
    <title><%= meta.dig('title') || 'Docs' %></title>
  </head>
  <body>
    <aside>
      <%= erb :_nav, locals: { sitemap: sitemap } %>
    </aside>
    <main>
      <%= yield %>
    </main>
  </body>
</html>
```

@tab Sinatra page.erb
```erb
<article>
  <h1><%= meta.dig('title') %></h1>
  <%= content %>
</article>
```

@tab Rails page.html.erb
```erb
<article>
  <h1><%= meta.dig('title') %></h1>
  <%= content %>
</article>
```
:::

You can add more templates by setting `template:` in frontmatter, for example `template: blog`. Trifle::Docs will then render `blog.erb` (Sinatra) or `trifle/docs/page/blog.html.erb` (Rails).
