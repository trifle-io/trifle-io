---
title: Serializers
description: Learn how to serialize blocks in Trifle::Traces.
nav_order: 8 
---

# Serializers

You may have noticed that `Trifle::Traces` allows you to include return values of a block in the traces. This is great for including deep low-level insigts into execution. Think of persisting calculated values or returned active record objects that you want to preserve in your trace for a reference.

Serializers allows you to define how you want to preserve this data. You can use one of pre-defined serializers or write your own. Serializer class needs to implement `sanitize` instance method that accepts `payload` as an argument and returns its sanitized version.

```ruby
class NumberSerializer
  def sanitize(payload)
    rand(1000)
  end
end
```

Here you have example of not-so-smart serializer. In practice predefined serializers are simple and you can see their details below. `Trifle::Traces` defaults to `Inspect` serializer.

## Inspect

Inspect Serializer calls `.inspect` on a `payload`. This is the most low-level serializer and is safest to use whenever you are not sure what type of content you are going to be serializing.

## String

String Serializer calls `.to_s` on a `payload`. In comparison to `Inspect`, this serializer handles couple cases differently.

## Json

Json Serializer calls `.to_json` on a `payload`. This serializer is best to use when you have good control over the data and would like to present language-independent content.
