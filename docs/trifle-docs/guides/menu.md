---
title: Render Menu
description: Learn how to display a navigation from sitemap.
nav_order: 1
---

# Render Menu

The simplest way to build navigation is to use `sitemap`, which is available as a template variable.

## Add ordering in frontmatter

```markdown
---
title: Getting Started
nav_order: 1
---
```

## Basic menu (single level)

```erb
<ul>
  <% sitemap.sort_by { |(_, node)| node.dig('_meta', 'nav_order') || 999 }.each do |key, node| %>
    <% next if key == '_meta' || node.dig('_meta', 'type') == 'file' %>
    <li>
      <a href="<%= node.dig('_meta', 'url') %>"><%= node.dig('_meta', 'title') %></a>
    </li>
  <% end %>
</ul>
```

## Nested menu (recursive)

```erb
<%# app/views/trifle/docs/_nav.erb %>
<% def render_nav(tree) %>
  <ul>
    <% tree.sort_by { |(_, node)| node.dig('_meta', 'nav_order') || 999 }.each do |key, node| %>
      <% next if key == '_meta' || node.dig('_meta', 'type') == 'file' %>
      <li>
        <a href="<%= node.dig('_meta', 'url') %>"><%= node.dig('_meta', 'title') %></a>
        <% if node.keys.any? { |child| child != '_meta' } %>
          <%= render_nav(node) %>
        <% end %>
      </li>
    <% end %>
  </ul>
<% end %>

<%= render_nav(sitemap) %>
```

Keep `_meta` and file nodes out of the menu so navigation stays clean.
