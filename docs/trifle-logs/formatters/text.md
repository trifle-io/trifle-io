---
title: Text
description: Learn how Text formatter renders scope and content.
nav_order: 2
---

# Text Formatter

`Trifle::Logs::Formatter::Content::Text` serializes scope into `key:value` pairs joined by `;`, then appends the message.

## Example

```ruby
formatter = Trifle::Logs::Formatter::Content::Text.new
formatter.format({ request_id: 'req-1', user_id: 7 }, 'Charged invoice #42')
# => "request_id:req-1;user_id:7 Charged invoice #42"
```
