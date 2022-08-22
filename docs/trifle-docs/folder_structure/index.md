---
title: Folder Structure
description: Learn how to structure your documents for Trifle::Docs.
nav_order: 5
---

# Folder Structure

There is no magic. It's almost like WYSIWYG type of things. Except, it's with folders and files.

All folders and files within the folder are its children. That's it. There are no visibility flags, it doesn't set any order of items. You can do all this by providing `meta` attributes for each file and then handling it in UI based on these meta values.

## Index

Index routes has always been different type of animals. And in this case its bit more complicated. You can either define file matching the specific url, or you can define a folder matching the specific url that includes `index.*` file.

For example for url `/docs/sample` you can define both `/docs/sample.md` and `/docs/sample/idnex.md` files. Whichever gets processed last will be the one that gets served.

If you're writing your own Harvester, it is good to note that url sanitization is in responsibility of a Sieve. It's a good idea to clear `/index.*` from the file name to get to desired url.