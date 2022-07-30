---
title: Performance
nav_order: 1
---

# Performance

One note about performance of the drivers. While these are small operations against any database, these drivers differ in approach they take.

`Redis` and `Postgres` drivers are performing single inc/set operation for each key/value pair for every specified period. That means to store hash with 10 key/value pairs, it will make 10 calls to database multiplied by tracked periods. It adds up quickly.

`Mongo` on the other side supports single inc/set operation on multiple key/value pairs at a time. This allows it to make single call to database even if you are tracking 50 values for multiple periods.

Keep that in mind when working with data. If content you are tracking has simple structure, it will be just fine with `Redis` or `Postgres` driver. `Redis` is better at writing, but not as persistent as `Postgres`. `Postgres` is terrible at writing stats, but really great at reading them. If your content is structured and tracks lots of values, you will do better using `Mongo` driver.

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
Trifle Stats
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.103s          0.0236s
Trifle::Stats::Driver::Postgres         4.7279s         0.0319s
Trifle::Stats::Driver::Mongo            0.1498s         0.0897s
Trifle::Stats::Driver::Process          0.0086s         0.0062s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.81s           0.2441s
Trifle::Stats::Driver::Postgres         43.4355s        0.328s
Trifle::Stats::Driver::Mongo            1.4794s         0.9187s
Trifle::Stats::Driver::Process          0.1263s         0.0605s
```

It's easy to see that this is where Redis shines. You simply can't beat it.

### Bit more complex tracking

Now lets compare what happens if we track 5 values. Either stored on top level or nested.

First lets start with top level values. 

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":3,"d":4,"e":5}'
Testing 100x {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.3569s         0.0291s
Trifle::Stats::Driver::Postgres         22.3555s        0.0408s
Trifle::Stats::Driver::Mongo            0.1516s         0.1041s
Trifle::Stats::Driver::Process          0.0194s         0.0066s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":3,"d":4,"e":5}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            3.1916s         0.2554s
Trifle::Stats::Driver::Postgres         223.627s        0.3125s
Trifle::Stats::Driver::Mongo            1.7419s         0.9251s
Trifle::Stats::Driver::Process          0.2524s         0.0774s
```

And next with nested values.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":{"d":3,"e":{"f":4,"g":5}}}'
Testing 100x {"a"=>1, "b"=>2, "c"=>{"d"=>3, "e"=>{"f"=>4, "g"=>5}}} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.3816s         0.0428s
Trifle::Stats::Driver::Postgres         22.6353s        0.0355s
Trifle::Stats::Driver::Mongo            0.1541s         0.0886s
Trifle::Stats::Driver::Process          0.0206s         0.0071s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":{"d":3,"e":{"f":4,"g":5}}}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>{"d"=>3, "e"=>{"f"=>4, "g"=>5}}} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            3.0322s         0.2633s
Trifle::Stats::Driver::Postgres         228.4836s       0.316s
Trifle::Stats::Driver::Mongo            1.5254s         0.8802s
Trifle::Stats::Driver::Process          0.2112s         0.0713s
```

`Trifle::Stats` normalizes nested values to top level before storing them, so overall there is not much performance difference between these. Even then, you can see that `Postgres` driver is performing the worst when it comes to writing. Like hidiously worse. On the other side it keeps up with `Redis` when reading values.

Complex tracking is also where `Mongo` shines. It doesn't matter if you track 1, 5, or 100 values, mongo will perform (almost) lineary.

### Mongo on large(r) set

Now lets compare `Mongo` only. Just to get some sense of it's performance over increasing number of keys that are tracked.

The first run is on a cold database.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.3255s         0.1319s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.1805s         0.0942s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.1738s         0.1177s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            1.6192s         1.1184s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            1.6068s         1.0099s
```

Now that we've seen some base numbers for 1 tracked value, lets increase it to 5.

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.1729s         0.1027s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.1753s         0.1027s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            1.8558s         1.0397s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            1.7479s         0.9489s
```

This doesn't look like much increase over 1 value. It's _pretty much_ same. What if we track a whole alphabet?

```sh
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.2022s         0.1046s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.2439s         0.1035s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            0.2194s         0.0957s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            2.0934s         0.9797s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            2.0544s         0.9652s
root@89857c648edb:/workspaces/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1,"x":2,"y":1,"z":2}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1, "x"=>2, "y"=>1, "z"=>2} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Mongo            2.037s          1.0925s
```

Alrite, there is a slight slow down. Like 300ms on 1000 runs. I'm gonna let you decide if this is good, bad or acceptable.