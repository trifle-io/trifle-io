---
title: Usage
description: Learn how to use Trifle::Traces DSL.
nav_order: 4
---

# Usage

`Trifle::Traces` exposes module-level helpers that delegate to the current tracer stored in `Thread.current`.

## 1) Create a tracer

```ruby
Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(
  key: 'jobs/invoice_charge',
  meta: { job_id: 42 }
)
```

:::callout note "Thread-local storage"
`Trifle::Traces.tracer` lives in `Thread.current`, so each thread must set its own tracer.
:::

## 2) Trace lines

### Simple line

```ruby
Trifle::Traces.trace('Started processing')
```

### Head line

Use `head: true` to mark a header line (`type: :head`).

```ruby
Trifle::Traces.trace('Charging invoice', head: true)
```

### Line with custom state

```ruby
Trifle::Traces.trace('Gateway timeout', state: :error)
```

### Trace a block

When you pass a block, Trifle::Traces records the block result on its own line.

```ruby
response = Trifle::Traces.trace('Calling gateway') do
  { status: 'ok', took_ms: 123 }
end
```

## 3) Tags and artifacts

```ruby
Trifle::Traces.tag('invoice:42')
Trifle::Traces.artifact('screenshot.png', '/tmp/screenshot.png')
```

## 4) Finish the trace

```ruby
Trifle::Traces.tracer.wrapup
```

## Example output shape

Each line in `tracer.data` looks like:

```ruby
{
  at: 1700000000,
  message: "Charging invoice",
  state: :success,
  type: :text,
  level: 0
}
```
