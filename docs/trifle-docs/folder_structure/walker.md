---
title: Walker
description: Learn how Walker iterates over your files.
nav_order: 1
---

# Walker

`Trifle::Docs::Harvester::Walker` crawls your `config.path`, finds files, and hands each file to your registered harvesters in order.

### Key behaviors

- Every file is tested against each harvester's `Sieve`.
- The first matching harvester wins.
- The resulting `Conveyor` is stored in the router.

That means **ordering matters**. Always register `Trifle::Docs::Harvester::File` last because it matches everything.

## Example

```ruby
Trifle::Docs.configure do |config|
  config.path = Rails.root.join('docs')
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
end
```

Markdown files will be rendered; everything else falls back to the File harvester.
