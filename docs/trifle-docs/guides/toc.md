---
title: Table of Content
description: Learn how to display Table of Content section.
nav_order: 2
---

# Table of Content

Markdown pages automatically generate a Table of Contents (`meta['toc']`). Render it wherever you want.

```erb
<% if meta['toc'] %>
  <nav id="on-this-page">
    <h2>On this page</h2>
    <%= meta['toc'] %>
  </nav>
<% end %>
```

Use CSS to style nested lists under `#on-this-page`.
