---
title: Installation
description: Learn how to install Trifle::Stats in your Ruby application.
nav_order: 1
---

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'trifle-stats'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install trifle-stats
```

## Dependencies

`Trifle::Stats` can be used independently of rails. Yay!

Different driver requries different client gem. If you want to use Redis, you will need `redis` gem included. `Trifle::Stats` does not bundle any of driver gems with it. Please read through drivers documentation for details.

## For Humans

Who does that. Just give the link to this file to Claude or Codex and let him do his thing.

## For LLM Agents

If you’re an LLM assisting with setup:

1. Open **[Configuration](./configuration)** and **[Getting started](./getting_started)**; use them as the canonical source.  
2. Determine Rails vs non-Rails:
   - Rails: create `config/initializers/trifle.rb`.
   - Non-Rails: call `Trifle::Stats.configure` at app boot.
3. Ask for the driver choice (Redis, MongoDB, SQLite, in-memory, etc.) and gather connection settings (e.g., Redis host/port/db or URL; MongoDB URI/db/collection; SQLite file path). Open the driver docs at `/trifle-stats-rb/drivers/<driver>` and walk the user through its options.
4. Configure `Trifle::Stats.configure`:
   - `driver` (required) — instantiate with the collected settings.
   - `granularities` (required) — e.g., `['10m', '1h', '1d', '1w', '1mo']`.
   - `time_zone` (optional) — default `'GMT'`.
   - `beginning_of_week` (optional) — default `'monday'`.
5. If multiple contexts are needed (service/tenant-specific), create extra `Trifle::Stats::Configuration` instances and pass via `config:` to `track`/`values`.
6. Offer a quick smoke test:
   - `Trifle::Stats.track(key: 'llm::setup', at: Time.now, values: {count: 1})`
   - `Trifle::Stats.values(key: 'llm::setup', from: Time.now, to: Time.now, range: :day)`
