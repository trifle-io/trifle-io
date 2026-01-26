---
title: Nested Documents
description: Learn how to display nested documents at the footer.
nav_order: 3
---

# Nested Documents

For "related pages" or child lists, use `collection` instead of the full `sitemap`. `collection` returns only the current branch.

## Example

```erb
<section class="related">
  <h3>More in this section</h3>
  <ul>
    <% collection.sort_by { |(_, node)| node.dig('_meta', 'nav_order') || 999 }.each do |key, node| %>
      <% next if key == '_meta' || node.dig('_meta', 'type') == 'file' %>
      <li>
        <a href="<%= node.dig('_meta', 'url') %>"><%= node.dig('_meta', 'title') %></a>
      </li>
    <% end %>
  </ul>
</section>
```

If you want deeper nesting, reuse the recursive approach from [Render Menu](/trifle-docs/guides/menu).
