---
title: Performance
nav_order: 1
---

# Performance

One note about performance of the drivers. While these are small operations against any database, these drivers differ in approach they take.

`Redis` driver is performing single `inc`/`set` operation for each key/value pair for every specified period. That means to store hash with 10 key/value pairs, it will make 10 calls to database multiplied by tracked periods. It adds up quickly.

`Mongo` and `Postgres` on the other side supports single `inc`/`set` operation on multiple key/value pairs at a time. This allows it to make single call to database even if you are tracking 50 values for multiple periods. `Mongo` pushes it even further and executes all periods in a single query, while `Postgres` executes separate query for each period.

Keep that in mind when working with data. Each driver fits better for different usecase.

- `Redis` is best if the content you are tracking has simple structure and persistence is not an issue. Use it for simple stats you _could_ loose.
- `Postgres` is _pretty slow_ at writing stats, but really great at reading them. Use it for structured stats that you access often, but don't write too often.
- `Mongo` is kinda best of both worlds. Super fast for writing, but bit slower for reading.

## (Not so) Sicentific evaluation

Here is a summary of a performance test of each driver. You can check the code under `specs/performance` and run it on your own. Change some connection details in `specs/performance/drivers.rb` that creates configurations.

Then simply run `specs/performance/run COUNT JSON` where `COUNT` represents number of reads writes to be performed and `JSON` needs to be valid JSON structure to be tracked.

```sh
specs/performance/run 100 '{"a":1}'
```

Databases are dropped and re-created on each `run`.

And so on. Below is a comparison of tests running on Github Codespaces on 2CPU/4GB RAM instance running all databases as a linked docker containers (no special configuration).

### Most simple tracking

The simplest tracking you can do is to track 1 value. Lets see how drivers perform writing/reading these 100 and 1000 times.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.1054s         0.0243s
Trifle::Stats::Driver::Postgres         6.1116s         0.0291s
Trifle::Stats::Driver::Mongo            0.1443s         0.0894s
Trifle::Stats::Driver::Process          0.0085s         0.0063s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.7743s         0.207s
Trifle::Stats::Driver::Postgres         60.0427s        0.2758s
Trifle::Stats::Driver::Mongo            1.5056s         0.9033s
Trifle::Stats::Driver::Process          0.0884s         0.06s
```

It's easy to see that this is where Redis shines. You simply can't beat it.

### Bit more complex tracking

Now lets compare what happens if we track 5 values. Either stored on top level or nested.

First lets start with top level values. 

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":3,"d":4,"e":5}'
Testing 100x {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.3914s         0.0278s
Trifle::Stats::Driver::Postgres         5.9491s         0.0319s
Trifle::Stats::Driver::Mongo            0.152s          0.0909s
Trifle::Stats::Driver::Process          0.021s          0.007s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":3,"d":4,"e":5}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            3.209s          0.3205s
Trifle::Stats::Driver::Postgres         61.6816s        0.309s
Trifle::Stats::Driver::Mongo            1.7052s         0.9341s
Trifle::Stats::Driver::Process          0.1981s         0.09s
```

And next with nested values.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":{"d":3,"e":{"f":4,"g":5}}}'
Testing 100x {"a"=>1, "b"=>2, "c"=>{"d"=>3, "e"=>{"f"=>4, "g"=>5}}} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.3611s         0.0281s
Trifle::Stats::Driver::Postgres         6.0464s         0.0322s
Trifle::Stats::Driver::Mongo            0.1637s         0.0917s
Trifle::Stats::Driver::Process          0.0216s         0.0071s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":{"d":3,"e":{"f":4,"g":5}}}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>{"d"=>3, "e"=>{"f"=>4, "g"=>5}}} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            3.1609s         0.2669s
Trifle::Stats::Driver::Postgres         60.0148s        0.3058s
Trifle::Stats::Driver::Mongo            1.7122s         1.0425s
Trifle::Stats::Driver::Process          0.2121s         0.0727s
```

`Trifle::Stats` normalizes nested values to top level before storing them, so overall there is not much performance difference between these. Even then, you can see that `Postgres` driver is performing the worst when it comes to writing. Like hidiously worse. On the other side it keeps up with `Redis` when reading values.

Complex tracking is also where `Mongo` shines. It doesn't matter if you track 1, 5, or 100 values, mongo will perform (almost) lineary.

### Mongo and Postgres on large(r) set

Now lets compare `Mongo` and `Postgres` only. Just to get some sense of it's performance over increasing number of keys that are tracked.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         6.1127s         0.0419s
Trifle::Stats::Driver::Mongo            0.1472s         0.096s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         6.0452s         0.0321s
Trifle::Stats::Driver::Mongo            0.1472s         0.0898s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         61.3327s        0.2731s
Trifle::Stats::Driver::Mongo            1.5735s         0.8923s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         61.5754s        0.2748s
Trifle::Stats::Driver::Mongo            1.5316s         0.9703s
```

Now that we've seen some base numbers for 1 tracked value, lets increase it to 5.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         6.2368s         0.0327s
Trifle::Stats::Driver::Mongo            0.1565s         0.0914s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         6.4885s         0.032s
Trifle::Stats::Driver::Mongo            0.1679s         0.0993s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         61.0578s        0.2865s
Trifle::Stats::Driver::Mongo            1.5063s         0.9274s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         60.5477s        0.3481s
Trifle::Stats::Driver::Mongo            1.5693s         0.9617s
```

This doesn't look like much increase over 1 value. It's _pretty much_ same. What if we track a whole alphabet?

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         6.5403s         0.0404s
Trifle::Stats::Driver::Mongo            0.1815s         0.0915s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         6.5559s         0.0386s
Trifle::Stats::Driver::Mongo            0.1782s         0.0907s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         66.0111s        0.3898s
Trifle::Stats::Driver::Mongo            1.8594s         0.96s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Postgres         65.4363s        0.4827s
Trifle::Stats::Driver::Mongo            1.8078s         0.9655s
```

Alrite, there is a slight slow down in both `Mongo` and `Postgres`. Like 300ms/5s on 1000 runs. I'm gonna let you decide if this is good, bad or acceptable.