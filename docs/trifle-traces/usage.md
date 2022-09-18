---
title: Usage
description: Learn how to use Trifle::Traces DSL.
nav_order: 3
---

# Usage

`Trifle::Traces` comes with a couple module level methods that are shorthands for operations.

## `tracer = Tracer`

To start tracking you must initialize Tracer first. There are two tracers included, Hash and Null. They store data in structure as their name says so. Duh.

```ruby
Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(key: 'my_trace', meta: {count: 1})
```

Tracer is stored on `Thread.current`. Be aware when multithreading.

## `trace(String, head: Bool, state: String, &block)`

Once you initialize Tracer, manually or through middleware, you can start tracing your code.

### Simple

The easiest way to use tracer is to replace all your `puts` or `Rails.logger.info` outputs with `Trifle::Traces.trace` method. This will do what you would expect, store the text with a timestamp.

```ruby
Trifle::Traces.trace('This is sample log message')
Trifle::Traces.trace("This is interpolated time #{Time.now} message")
```

### Head

Sometimes you need to mark a line of a new section in your log. Use `head: true` attribute to mark the line.

```ruby
Trifle::Traces.trace('Initializing connection', head: true)
params = { a: 1 }
Trifle::Traces.trace("Passing params: #{params}")
Rest::Client.post('https://example.com', params)
Trifle::Traces.trace('Done')
```

### State

Other times you may wanna point out that something caused an error. Pass `state: :error` argument to `trace` method. You can pass any state you like and then use this to enhance visualisation in your UI. I mean, make the text red when its error.

```ruby
Trifle::Traces.trace('Connection failed', state: :error)
```

### Block

You can see how the above example of using params looks, well, bad. For this you can use `Trifle::Traces.trace` with block and assing result of a block to a variable. Tracer will automatically include result of a block in your logs. Result is evaluated through `Object.inspect` method.

```ruby
params = Trifle::Traces.trace('Passing params') do
  { a: 1 }
end
```

# Example

Here is an example of manual tracing in your ruby code. Callback just prints the lines.

```ruby
Trifle::Traces.configure do |config|
  config.on(:wrapup) do |tracer|
    tracer.data.each do |line|
      puts line
    end
  end
end
```

You can read more about persisting and callbacks in, well, [Callbacks](/trifle-traces/callbacks.html) doc.

Then using examples from above you can get combined out

```ruby
Trifle::Traces.tracer.wrapup
{:at=>1612686322, :message=>"Trifle::Trace has been initialized for sample", :state=>:success, :head=>false, :meta=>false}
{:at=>1612686343, :message=>"This is sample log message", :state=>:success, :head=>false, :meta=>false}
{:at=>1612686347, :message=>"This is interpolated time 2021-02-07 09:25:47 +0100 message", :state=>:success, :head=>false, :meta=>false}
{:at=>1612686351, :message=>"Initializing connection", :state=>:success, :head=>true, :meta=>false}
{:at=>1612686359, :message=>"Passing params", :state=>:success, :head=>false, :meta=>false}
{:at=>1612686359, :message=>"=> {:a=>1}", :state=>:success, :head=>false, :meta=>true}
{:at=>1612686363, :message=>"Done", :state=>:success, :head=>false, :meta=>false}
{:at=>1612686441, :message=>"Connection failed", :state=>:error, :head=>false, :meta=>false}
=> nil
```
