---
title: Markdown
description: Learn how Markdown harvester renders your files.
nav_order: 1
---

# Markdown Harvester

Underneeth `Markdown` harvester uses `redcarpet` to render markdown files. It matches only `*.md` files.

`Markdown` harvester is bit opinionated. It includes `rouge` plugin for syntax highlighting and sets few configuration defaults. `fenced_code_blocks: true`, `disable_indented_code_blocks: true` and `footnotes: true`.

## Metadata parsing

Jekyll sets a convention of using `YAML` configuration at a top of your markdown file. This way you can pass some extra context that can be used in your templates.

`Markdown` harvester only requires `title` key to be present. Other key/values are completely under your control.

If you're working on sorting your documentation, you may wanna pass in `nav_order` or something similar and than use it in your views to sort documents based on this value.

If you're working on a blog, you may wanna sort your documents based on timestamp. Or you may wanna add `tags`, `category` or `author` and render these in the templates.

It provides these keys/values inside of metadata:

- `url` - current URL.
- `breadcrumbs` - URL split into segments.
- `toc` - Table of Content HTML code.
- `updated_at` - files modification timestamp.
