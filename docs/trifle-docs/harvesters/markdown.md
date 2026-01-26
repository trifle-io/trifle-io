---
title: Markdown
description: Learn how Markdown harvester renders your files.
nav_order: 1
---

# Markdown Harvester

The Markdown harvester uses `redcarpet` to render `.md` files and `rouge` for syntax highlighting.

Enabled options:
- `fenced_code_blocks: true`
- `disable_indented_code_blocks: true`
- `footnotes: true`
- `tables: true`

## Frontmatter

Frontmatter is YAML between `---` markers at the top of the file. Trifle::Docs merges it with generated metadata.

```markdown
---
title: Getting Started
nav_order: 1
tags:
  - onboarding
  - setup
template: page
---

# Getting Started

Welcome to the docs!
```

Generated metadata includes:
- `url` — current URL (prefixed with `namespace` if configured)
- `breadcrumbs` — URL split into segments
- `toc` — HTML table of contents generated from headings
- `updated_at` — file modification time

## Raw content

You can retrieve markdown without frontmatter via `Trifle::Docs.raw_content`:

```ruby
Trifle::Docs.raw_content(url: 'getting_started')
# => "# Getting Started\n\nWelcome to the docs!"
```
