---
title: Templates
nav_order: 7
---

# Templates

Templates are simple. Trust me. Even if it doesn't look like that in a first place.

There are two ways to integrate `Trifle::Docs` and therefore there are two ways to manage templates.

## Sinatra

If you're writing a sinatra app, you will have to point configuration to your template folder. This folder will expect `layout.erb` and `page.erb`. For example if you specify `config.views = File.join(__dir__, 'templates')`, it will expect `./templates/layout.erb` layout file as well as `./templates/page.erb` template file. If you change template in metadata, you will need to create page-like file for it. For example if you specify in pages metadata `template: blog`, it will expect `./templates/blog.erb` template file.

## Rails

If you're writing a rails app, you will have to create templates the _Rails Way_. That means place `app/views/layouts/trifle/docs/layout.html.erb` and page templates in `app/views/trifle/docs/page/page.html.erb`.

You can mount `Trifle::Docs` into your app multiple times, and therefore you can specify `layout` on a configuration that points to specific file within `app/views/layouts/trifle/docs/` folder. For example if you specify `config.layout = 'client'`, it will expect `app/views/layouts/trifle/docs/client.html.erb` layout file.

In the same way you can specify template in metadata and it will expect its page-like file under `app/views/trifle/docs/page/` folder. For example if you specify in pages metadata `template: blog`, it will expect `app/views/trifle/docs/page/blog.html.erb` template file.

## Variables

Both layout and template files are these variables accessible:

- `sitemap`: complete sitemap (tree of metadatas) of the folder. This is useful when building sidebar navigation or digging details for breadcrumbs.
- `url`: URL string. Thats it.
- `meta`: metadata of page for specific `url`. Includes `title` and everything else you place in pages metadata.
- `content`: content of page for specific `url`. HTML content ready to be rendered.
- `collection`: sub-sitemap of pages under specific `url`. Useful if you're planning to display list of projects, or blog posts or simply additional details about nested documents.
