---
title: 'Home'
svg: M8.25 21v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21m0 0h4.5V3.545M12.75 21h7.5V10.75M2.25 21h1.5m18 0h-18M2.25 9l4.5-1.636M18.75 3l-1.5.545m0 6.205l3 1m1.5.5l-1.5-.5M6.75 7.364V3h-3v18m3-13.636l10.5-3.819
---

# Welcome to Trifle Documentation

Opinionated [Swiss Army knife](https://en.wikipedia.org/wiki/Swiss_Army_knife) of little big tools.

These gems came from necessity of building better solutions to common problems. Tired of using _shitty_ analytics and reading through _shitty_ log output. These are small and simple. And that is OK. It is not one solution fits all type of things.

All gems from this collection are released under MIT license.

Made by galons of ☕️ and 🍺 by [JozefVaclavik](https://twitter.com/JozefVaclavik).

---

# `Trifle::Docs`

[![Gem Version](https://badge.fury.io/rb/trifle-docs.svg)](https://rubygems.org/gems/trifle-docs)
[![Ruby](https://github.com/trifle-io/trifle-docs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-docs)

Simple router for your static documentation. Like markdown, or textile, or whatever files.

It maps your docs folder structure into URLs and redners them within the simplest template possible.

It turns your `docs/example/snippet.md` file

```raw
---
title: Snippet
---

# Snippet

This is snippet.
```

And renders it as `example/snippet` with

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Trifle::Docs</title>
  </head>
  <body>
    <h1 id="snippet">Snippet</h1>

    <p>This is snippet.</p>
  </body>
</html>
```

Templates are completely in your control, you just use few provided variables.

More [here](/trifle-docs/).

---

# `Trifle::Logs`

[![Gem Version](https://badge.fury.io/rb/trifle-logs.svg)](https://rubygems.org/gems/trifle-logs)
[![Ruby](https://github.com/trifle-io/trifle-logs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-logs)

Simple log storage where you can dump your data. It allows you to search on top of your log files with `ripgrep` for fast regexp queries and utilises `head` and `tail` to paginate through a file.

It dumps your data

```ruby
Trifle::Logs.dump('test', 'This is test message')
Trifle::Logs.dump('test', 'Or another message')
Trifle::Logs.dump('test', 'That noone cares about')
```

And lets you search on top of it

```ruby
search = Trifle::Logs.searcher('test', pattern: 'test')
search.perform.data
[
  {
    "type"=>"match",
    "data"=>{
      "path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-17T08:33:04.843195 {\"scope\":{},\"content\":\"This is test message\"}\n"},
      "line_number"=>1,
      "absolute_offset"=>0,
      "submatches"=>[{"match"=>{"text"=>"test"}, "start"=>58, "end"=>62}]
    }
  }
]
```

More [here](/trifle-logs/).

---

# `Trifle::Stats`

[![Gem Version](https://badge.fury.io/rb/trifle-stats.svg)](https://rubygems.org/gems/trifle-stats)
[![Ruby](https://github.com/trifle-io/trifle-stats/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-stats)

Simple analytics backed by Redis, Postgres, MongoDB, Google Analytics, Segment, or whatever.

It gets you from having bunch of these occuring within few minutes

```ruby
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: { count: 1, duration: 2, lines: 241 })
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: { count: 1, duration: 1, lines: 56 })
Trifle::Stats.track(key: 'event::logs', at: Time.now, values: { count: 1, duration: 5, lines: 361 })
```

To being able to say what happened on 25th January 2021.

```ruby
Trifle::Stats.values(key: 'event::logs', from: Time.now, to: Time.now, range: :day)
=> {:at=>[2021-01-25 00:00:00 +0100], :values=>[{"count"=>3, "duration"=>8, "lines"=>658}]}
```

More [here](/trifle-stats/).

---

# `Trifle::Traces`

[![Gem Version](https://badge.fury.io/rb/trifle-traces.svg)](https://rubygems.org/gems/trifle-traces)
[![Ruby](https://github.com/trifle-io/trifle-traces/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-traces)

Simple log tracer that collects messages and values from your code and returns Hash (at least for now).

It saves you from reading through your standard logger

```ruby
Trifle::Traces.trace('This is important output')
now = Trifle::Traces.trace('And it\'s important to know it happened at') do
  Time.now
end
```

To being able to say what happened on 25th January 2021.

```ruby
[
  {at: 2021-01-25 00:00:00 +0100, message: 'This is important output', state: :success, head: false, meta: false}
  {at: 2021-01-25 00:00:00 +0100, message: 'And it\'s important to know it happened ', state: :success, head: false, meta: false}
  {at: 2021-01-25 00:00:00 +0100, message: '=> 2021-01-25 00:00:00 +0100', state: :success, head: false, meta: true}
]
```

More [here](/trifle-traces/).
