---
title: Walker
description: Learn how Walker iterates over your files.
nav_order: 1
---

# Walker

`Trifle::Docs::Harvester::Walker` that is responsible for iterating through every folder and file recursively for the path you've provided in your config.

It passes every file through a list of Harvesters to find the matching one. This matching works like a series of Sieves. If the file is not matched by the first harvesters sieve, it tries to be matched by the next one, and so on. Once matching harvester has been found, it creates a mapping (aka routing) between the URL and its `Conveyor` that handles rendering. More about that in [Conveyor](/trifle-docs/harvesters#conveyor) documentation.

This way you can mix up your files with different formats and register multiple Harvesters. For example Markdown, Textile, or anything else. The important part is that you need to be able to render this content to HTML.

If you're planning to render images or files in your documentation, you should register `Trifle::Docs::Harvestger::File` as a last Harvester. This is catch & serve as raw type of harvester.
