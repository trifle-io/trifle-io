---
title: Formatters
description: Learn how Trifle::Logs::Formatters manipulates output.
nav_order: 6
---

# Formatters

Formatters are used to format your data. You can use some of pre-defined formatters or define your own. There really isn't much to it.

## Timestamp Formatter

Beginning of each line is identified by a timestamp. How this timestamp gets formatted depends on a formatter passed into `config` as a `timestamp_formatter`.

Every timestamp formatter needs to implement `format(timestamp)` method and return a string representation in desired format.

## Content Formatter

This formatter defines how your content will be formatted. Anything that will follow the timestamp. How content will get formatted depends on a formatter passed into `config` as a `content_formatter`.

Every content formatter needs to implement `format(scope, message)` method and return a string representation in desired format.
