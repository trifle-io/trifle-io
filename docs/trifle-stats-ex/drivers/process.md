---
title: Process
description: Learn how to use the in-memory Process driver.
nav_order: 2
---

# Process Driver

The Process driver stores everything in-memory using a GenServer. It is ideal for tests and local development.

## Example

```elixir
{:ok, pid} = Trifle.Stats.Driver.Process.start_link()
driver = Trifle.Stats.Driver.Process.new(pid)

config = Trifle.Stats.Configuration.configure(driver)
Trifle.Stats.track("event::logs", DateTime.utc_now(), %{count: 1}, config)
```

## Notes

- Data is lost when the process stops.
- Useful for demos, tests, and prototyping.
