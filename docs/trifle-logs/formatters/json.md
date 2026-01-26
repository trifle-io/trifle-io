---
title: Json
description: Learn how Json formatter renders scope and output.
nav_order: 3
---

# Json Formatter

`Trifle::Logs::Formatter::Content::Json` stores the scope and message as JSON.

## Example

```ruby
require 'json'

formatter = Trifle::Logs::Formatter::Content::Json.new
json = formatter.format({ request_id: 'req-1' }, 'Charged invoice #42')
JSON.parse(json)
# => { "scope" => { "request_id" => "req-1" }, "message" => "Charged invoice #42" }
```
