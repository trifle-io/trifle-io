---
title: Next & Previous Documents
description: Learn how to display next and previous neighbouring documents.
nav_order: 4
---

# Next & Previous Documents

You can derive previous/next links from `collection`. Sort it, find the current item, and pick neighbors.

## Example helper

```ruby
# app/helpers/docs_helper.rb
module DocsHelper
  def docs_neighbors(collection, current_url)
    items = collection
      .reject { |key, node| key == '_meta' || node.dig('_meta', 'type') == 'file' }
      .values
      .sort_by { |node| node.dig('_meta', 'nav_order') || 999 }

    index = items.index { |node| node.dig('_meta', 'url') == current_url }
    return [nil, nil] if index.nil?

    prev = index.positive? ? items[index - 1] : nil
    nxt = items[index + 1]
    [prev, nxt]
  end
end
```

## Template usage

```erb
<% prev, nxt = docs_neighbors(collection, meta.dig('url')) %>
<nav class="doc-neighbors">
  <% if prev %>
    <a class="prev" href="<%= prev.dig('_meta', 'url') %>">
      ← <%= prev.dig('_meta', 'title') %>
    </a>
  <% end %>
  <% if nxt %>
    <a class="next" href="<%= nxt.dig('_meta', 'url') %>">
      <%= nxt.dig('_meta', 'title') %> →
    </a>
  <% end %>
</nav>
```

Adjust ordering as needed (e.g., use dates for blogs instead of `nav_order`).
