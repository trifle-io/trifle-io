---
title: Render Menu
description: Learn how to display a navigation from sitemap.
nav_order: 1
---

# Render Menu

Easiest way to render navigation is to use `sitemap`. You can use it directly as `Trifle::Docs.sitemap` or as a template variable `sitemap` that is available in both Sinatra and Rails integration.

Hashes does not preserve order of items and even if they would, they would be sorted alphabetically as they would be presented within the folder. For this purpose its best to use a key/value stored in meta and use it to sort your menu options based on that.

The decision how to name the key is completely up to you. You can use simple `nav_order` and set it in meta on each file with appropriate number.

```markdown
---
title: Test
nav_order: 1
---

# Test

This is testing page
```

And for another page simply increment the value.

```markdown
---
title: Another Test
nav_order: 2
---

# Another test

This is another testing page
```

Then in your template you can pick the sitempa and sort each item of it by `nav_order`. The only chevat is that `sitemap` includes `_meta` for current page and you _should_ account for that in your rendering.

```ruby
...
<h1><%= sitemap.dig('_meta', 'title') %></h1> <!-- display title for main page -->
<ul>
  <% sitemap.sort_by {|(key, option)| option.dig('_meta', 'nav_order') || 0 }.each do |(key, option)| %>
    <% next if key == '_meta' %>
    <li><%= option.dig('_meta', 'title') %></li>
  <% end %>
</ul>
```

Voila. That was it.

