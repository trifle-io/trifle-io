---
title: File
description: Learn how File harvester serves your files.
nav_order: 10
---

# File Harvester

The File harvester serves static assets (images, PDFs, downloads). It matches **any** file, so register it **last**.

## Metadata

File entries are still included in the sitemap and collection trees, but their metadata includes `type: "file"` and `path` so your renderer can serve them directly.

```ruby
meta = Trifle::Docs.meta(url: 'assets/logo.png')
# => { "type" => "file", "path" => "/.../docs/assets/logo.png", ... }
```

If `meta['type'] == 'file'`, serve the file directly instead of rendering HTML.
