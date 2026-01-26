---
title: Timestamp
description: Learn how Timestamp formats time of log entry. 
nav_order: 1
---

# Timestamp Formatter

`Trifle::Logs::Formatter::Timestamp` formats timestamps using `strftime('%Y-%m-%dT%H:%M:%S.%6N')`.

## Example

```ruby
formatter = Trifle::Logs::Formatter::Timestamp.new
formatter.format(Time.utc(2025, 1, 2, 3, 4, 5.123456))
# => "2025-01-02T03:04:05.123456"
```
