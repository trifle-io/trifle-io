---
title: File
description: Learn how File harvester serves your files.
nav_order: 10
---

# File Harvester

`File` harvester is best for serving static files. If you plan to serve any images, videos or other files directly, File harvester is what you are looking for. It will serve you well even if you are simply including images inside of your markdown files.

Files still come up as a part of `sitemap` as they are part of your folder tree. If you're integrating with Rails, you can always serve static files from your `public` folder to avoid use of `File` harvester.

The gist of `File` harvester is to matching any file. That's why it's important to register `File` harvester as last. It's catch-all type of harvester.

As `content` it serves files content directly. Both Rails controller and Sinatra router has condition for `type: 'file'` to serve it as a file instead of rendering it as a part of template.
