---
title: Folder Structure
nav_order: 4
---

# Folder Structure

There is no magic. It's almost like WYSIWYG type of things. Except, it's with folders and files.

All folders and files within the folder are its children. That's it. There are no visibility flags, it doesn't set any order of items. You can do all this by providing `meta` attributes for each file and then handling it in UI based on these meta values.

For example if you wanna sort elements in the menu, set `nav_order` meta on each file with appropriate number, and then in your template you can do something like:

```ruby
...
<ul>
  <% sitemap.sort_by {|(key, option)| option.dig('_meta', 'nav_order') || 0 }.each do |(key, option)| %>
    <li><%= option.dig('_meta', 'title') %></li>
  <% end %>
</ul>
```

Voila. That was it.

## Walker

`Trifle::Docs::Harvester::Walker` that is responsible for iterating through every folder and file recursively for the path you've provided in your config.

It passes every file through a list of Harvesters to find the matching one. This matching works like a series of Sieves. If the file is not matched by the first harvesters sieve, it tries to be matched by the next one, and so on. Once matching harvester is found, it creates a mapping between the URL and its `Conveyor` that handles rendering. More about that in [Conveyor](/trifle-docs/harvesters#conveyor) documentation.

This way you can mix up your files with different formats and register multiple Harvesters. For example Markdown, Textile, or anything else. The important part is that you need to be able to render this content to HTML.

If you're planning to render images or files in your documentation, you should register `Trifle::Docs::Harvestger::File` as a last Harvester. This is catch & serve as raw type of harvester.

## Index

Index routes has always been different type of animals. And in this case its bit more complicated. You can either define file matching the specific url, or you can define a folder matching the specific url that includes `index.*` file.

For example for url `/docs/sample` you can define both `/docs/sample.md` and `/docs/sample/idnex.md` files. Whichever gets processed last will be the one that gets served.

If you're writing your own Harvester, it is good to note that url sanitization is in responsibility of a Sieve. It's a good idea to clear `/index.*` from the file name to get to desired url.