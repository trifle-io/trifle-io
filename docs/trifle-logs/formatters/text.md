---
title: Text
description: Learn how Text formatter renders scope and content.
nav_order: 2
---

# Text Formatter

Sometimes you just wanna keep things simple and avoid doing JSON or other serialization.

## Format

Build in `Trifle::Logs::Formatter::Content::Text` formatter takes `scope` and serializes it by joining key/values with `:` and then all combinations with `;`. Then it adds an extra space and adds `message`.
