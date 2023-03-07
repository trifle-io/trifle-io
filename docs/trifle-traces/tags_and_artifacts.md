---
title: Tags and Artifacts
description: Learn how to tag and add attachments to tracer.
nav_order: 8
---

# Tags

Simple array where you can add reference to related objects. Then use this in callbacks to reference logger from these objects. Or whatever you decide to do.

```ruby
Trifle::Traces.tag("Item:#{item.id}")
Trifle::Traces.tag('test')
```

# Artifacts

Another simple array that holds list of filenames that you may wanna persist in your callbacks. Or don't, it's up to you!

```ruby
# somewhere in your code
def screenshot
  file = recorder.screenshot!
  Trifle::Traces.artifact(file.split('/').last, file)
end

# later in callback
config.on(:wrapup) do |tracer|
  entry = Entry.find_by(id: tracer.reference)
  next if entry.nil?

  # Upload artifacts
  tracer.artifacts.each do |artifact|
    path = "#{Rails.root}/public/artifacts/#{entry.namespace}/#{entry.id}"
    FileUtils.mkdir_p(path)
    FileUtils.mv(artifact, path)
  rescue StandardError => e
    next
  end

  # Delete artifacts
  FileUtils.rm(tracer.artifacts)
end
```
