---
title: Folder Structure
description: Learn how to structure your documents for Trifle::Docs.
nav_order: 5
---

# Folder Structure

Trifle::Docs is file-system driven: folders become URL segments, files become pages.

## Example mapping

```
docs/
├── index.md           -> /
├── guides/
│   ├── index.md       -> /guides
│   └── install.md     -> /guides/install
└── assets/
    └── logo.png       -> /assets/logo.png
```

## Index files

You can represent a URL with either:
- `path/to/page.md`
- `path/to/page/index.md`

Both map to the same URL. If both exist, whichever file is processed last wins. To avoid surprises, prefer `index.md` inside folders and avoid duplicate URLs.

## Ordering and visibility

Trifle::Docs does **not** impose ordering. Use frontmatter like `nav_order` or `hidden` and sort or filter inside your templates.
