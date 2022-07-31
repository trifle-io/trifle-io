---
title: 'Home'
---

Opinionated [Swiss Army knife](https://en.wikipedia.org/wiki/Swiss_Army_knife) of little big tools.

These gems came from necessity of building better solutions to common problems. Tired of using _shitty_ analytics and reading through _shitty_ log output.

These are small and simple. And that is OK. It is not one solution fits all type of things.

All gems from this collection are released under MIT license. You can find details inside of each gem.

Made by galons of ☕️ and 🍺 by [JozefVaclavik](https://twitter.com/JozefVaclavik).

---

# `Trifle::Docs`

[![Gem Version](https://badge.fury.io/rb/trifle-docs.svg)](https://rubygems.org/gems/trifle-docs)
[![Ruby](https://github.com/trifle-io/trifle-docs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-docs)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-docs)

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

# `Trifle::Logger`

[![Gem Version](https://badge.fury.io/rb/trifle-logger.svg)](https://rubygems.org/gems/trifle-logger)
[![Ruby](https://github.com/trifle-io/trifle-logger/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-logger)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-logger)

Simple log tracer that collects messages and values from your code and returns Hash (at least for now).

It saves you from reading through your standard logger

```ruby
Trifle::Logger.trace('This is important output')
now = Trifle::Logger.trace('And it\'s important to know it happened at') do
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

More [here](/trifle-logger/).

---

# `Trifle::Stats`

[![Gem Version](https://badge.fury.io/rb/trifle-stats.svg)](https://rubygems.org/gems/trifle-stats)
[![Ruby](https://github.com/trifle-io/trifle-stats/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-stats)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-stats)

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
