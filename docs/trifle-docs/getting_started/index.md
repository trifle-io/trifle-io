---
title: Getting Started
description: Learn how to start using Trifle::Docs.
nav_order: 3
---

# Getting Started

`Trifle::Docs` maps a folder of static files to URLs and renders them through your templates. Your job is to:

1. Create a folder structure (`docs/`, `blog/`, etc.).
2. Add frontmatter (`title`, `nav_order`, `template`, ...).
3. Choose how you want to serve the content.

## Pick an integration style

- [Standalone Sinatra App](/trifle-docs/getting_started/standalone_sinatra) — quickest path for a single docs site.
- [Rails with Sinatra](/trifle-docs/getting_started/rails_with_sinatra) — mount the Sinatra app inside Rails.
- [Rails with Engine](/trifle-docs/getting_started/rails_with_engine) — Rails-native templates and multiple mounts.
- [Raw Hardcore Mode](/trifle-docs/getting_started/raw_with_hardcore) — call the APIs directly and render yourself.

## Minimal folder structure

```
docs/
├── index.md
├── getting-started/
│   ├── index.md
│   └── installation.md
└── api/
    ├── index.md
    └── reference.md
```

## Next steps

- Learn how folder structures become URLs: [Folder Structure](/trifle-docs/folder_structure)
- Set up templates: [Templates](/trifle-docs/templates)
- Explore harvesters: [Harvesters](/trifle-docs/harvesters)
