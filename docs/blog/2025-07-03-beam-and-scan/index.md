---
title: 'Liveness management in Trifle::Stats'
date: '2025-07-03 21:55:25'
author: 'Jozef Vaclavik'
template: blog
---

# Liveness management in `Trifle::Stats`

Recently I've faced a scenario where I need to display only last value. I needed to display a liveness of a server with some metrics. I also need to know when the last ping of the server has been received to determine if its alive or no.

I don't need to keep `track` of historical/timeline visualization, nor keep `assert`ed last known values from yesterday or last month. I just need one latest value and timestamp when it was received.

First I thought of using `assert` with simple trakcing only yearly range. This would give me fairly simple tracking without creating too many records. I would loose `at` as a timestamp, but as values would be `set` instead of `inc`remented, I would keep integer representation of the timestamp inside of values. To be honest this felt bit too dirty.

So I went down and imagined how I could get it done in a simple way. Started from a top by defining two methods. Took an inspiration from sonar used on submarines and came down to `Trifle::Stats.beam` for sending ping and `Trifle::Stats.scan` for, well, scanning that ping.

Beam behaves as a simple `set` driver method with a twist of setting provided timestamp `at` directly on the records identifier instead of running it through `Nocturnal` to find the right range bucket. The nice thing on `set` is that I can now pass also string values rather than numerical only. Wohoo!

```ruby
Trifle::Stats.beam(key: 'server::galactoid-5bd58f7f44-c57jm', at: Time.now, values: {status: 'running', threads: 4, busy: 3, uptime: 583263, memory: 452752926})
=> [{2025-07-02 11:53:22 +0100=>{:status=>'running', :threads=>4, :busy=>3, :uptime => 583263, memory: 452752926}}]
```

No matter how many `beam`s you send, there will always be tracked only one record.

```ruby
Trifle::Stats.scan(key: 'server::galactoid-5bd58f7f44-c57jm')
=> {:at=>[2025-07-02 11:53:22 +0200], :values=>[{"status"=>"running", "threads"=>4, "busy"=>3, "uptime"=>583263, "memory"=>452752926}]}
```

Then using `scan` will lookup only for latest (just in case) value for provided `key` and return `at` with a timestamp of it.

And that was it. Happy beaming.