---
title: Tags and Artifacts
description: Learn how to tag and add attachments to tracer.
nav_order: 9
---

# Tags

Tags are simple strings stored on the tracer. Use them for indexing and cross-referencing.

```ruby
Trifle::Traces.tag("invoice:42")
Trifle::Traces.tag('billing')
```

## Using tags in callbacks

```ruby
config.on(:wrapup) do |tracer|
  Entry.create(
    key: tracer.key,
    tags: tracer.tags,
    data: tracer.data
  )
end
```

# Artifacts

Artifacts are file paths you want to attach to a trace. Each call adds a line with `type: :media` and records the file path in `tracer.artifacts`.

```ruby
file = '/tmp/screenshot.png'
Trifle::Traces.artifact(File.basename(file), file)
```

## Persist artifacts

```ruby
config.on(:wrapup) do |tracer|
  next if tracer.ignore

  tracer.artifacts.each do |artifact|
    dest = File.join(Rails.root, 'public', 'artifacts', tracer.key)
    FileUtils.mkdir_p(dest)
    FileUtils.mv(artifact, dest)
  end
end
```
