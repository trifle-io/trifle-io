---
title: Nested Documents
description: Learn how to display nested documents at the footer.
nav_order: 3
---

# Nested Documents

Displaying nested documents is very similar to rendering menu. While in Menu you are recommended to use `sitemap`, for nested documents its best to use `collection` that includes only the current part of a sitemap tree.

As you're again dealing with sitemap tree, you need to account for `_meta` of current page. Additionally, you may wanna exclude any files (images, videos, etc) as well.

```erb
<ul>
  <% collection.sort_by {|(key, option)| option.dig('_meta', 'nav_order') || 0 }.each do |key, item| %>
    <% next if key == '_meta' || item.dig('_meta', 'type') == 'file' %>
    <li><a href="<%= item.dig('_meta', 'url') %>"><%= item.dig('_meta', 'title') %></a></li>
  <% end %>
</ul>
```

Style them as you need them.
