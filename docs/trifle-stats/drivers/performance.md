---
title: Performance
nav_order: 1
---

# Performance

One note about performance of the drivers. While these are small operations against any database, these drivers differ in approach they take.

`Redis` driver is performing single `inc`/`set` operation for each key/value pair for every specified period. That means to store hash with 10 key/value pairs, it will make 10 calls to database multiplied by tracked periods. It adds up quickly.

`Mongo`, `Postgres` and `Sqlite` on the other side supports single `inc`/`set` operation on multiple key/value pairs at a time. This allows it to make single call to database even if you are tracking 50 values for multiple periods. `Mongo` executes all periods as a bulk action, while `Postgres` an `Sqlite` executes all periods as a single transaction. This makese them behave somewhat similar.

> `Sqlite` has hard-limit of maximum 23 keys it can track. For anything over that it raises `parser stack overflow (SQLite3::SQLException)`.

Keep that in mind when working with data. Each driver fits better for different usecase.

- `Redis` is best if the content you are tracking has simple structure and persistence is not an issue. Use it for simple stats you _could_ loose.
- `Postgres` is _somewhat slower_ at writing stats, but really great at reading them. Use it for structured stats that you access often, but don't write too often.
- `Mongo` is best for writing large data sets. Super fast for writing no matter how many stats you track, but bit slower for reading when compared to postgres.
- `Sqlite` is kinda living in it's own world. It holds up next the the rest of the drivers, while being bit slower, but still fast when reading. It's the only one that doesn't need running process, so kinda great for embeded _stuff_.

## (Not so) Sicentific evaluation

Here is a summary of a performance test of each driver. You can check the code under `specs/performance` and run it on your own. Change some connection details in `specs/performance/drivers.rb` that creates configurations.

Then simply run `specs/performance/run COUNT JSON` where `COUNT` represents number of reads and writes to be performed and `JSON` needs to be valid JSON structure being tracked.

```sh
specs/performance/run 100 '{"a":1}'
```

Databases are dropped and re-created on each `run`.

Below is a comparison of tests running on AWS EC2 `t2.medium` instance running all databases as a linked docker containers (no special configuration).

### Most simple tracking

The simplest tracking you can do is to track 1 value. Lets see how drivers perform writing/reading these 100 and 1000 times.

```sh
root@3b5545595714:~/trifle-stats/spec/performance# ./run 100 '{"a":1}'
Testing 100x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.1234s         0.0268s
Trifle::Stats::Driver::Postgres         0.2557s         0.0325s
Trifle::Stats::Driver::Mongo            0.1964s         0.11s
Trifle::Stats::Driver::Process          0.0134s         0.0097s
Trifle::Stats::Driver::Sqlite           0.4358s         0.0215s
root@3b5545595714:~/trifle-stats/spec/performance# ./run 1000 '{"a":1}'
Testing 1000x {"a"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            1.0422s         0.2596s
Trifle::Stats::Driver::Postgres         2.4905s         0.311s
Trifle::Stats::Driver::Mongo            1.9621s         1.0517s
Trifle::Stats::Driver::Process          0.1227s         0.0909s
Trifle::Stats::Driver::Sqlite           4.4692s         0.1867s
```

It's easy to see that this is where Redis shines. You simply can't beat it.

### Bit more complex tracking

Now lets compare what happens if we track 5 values. Either stored on top level or nested.

First lets start with top level values. 

```sh
root@3b5545595714:~/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":3,"d":4,"e":5}'
Testing 100x {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.4891s         0.0332s
Trifle::Stats::Driver::Postgres         0.3005s         0.0364s
Trifle::Stats::Driver::Mongo            0.208s          0.1087s
Trifle::Stats::Driver::Process          0.0274s         0.0102s
Trifle::Stats::Driver::Sqlite           0.4468s         0.0196s
root@3b5545595714:~/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":3,"d":4,"e":5}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            4.1344s         0.3248s
Trifle::Stats::Driver::Postgres         3.059s          0.3193s
Trifle::Stats::Driver::Mongo            2.0267s         1.0471s
Trifle::Stats::Driver::Process          0.2534s         0.0982s
Trifle::Stats::Driver::Sqlite           4.4097s         0.2078s
```

And next with nested values.

```sh
root@3b5545595714:~/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":{"d":3,"e":{"f":4,"g":5}}}'
Testing 100x {"a"=>1, "b"=>2, "c"=>{"d"=>3, "e"=>{"f"=>4, "g"=>5}}} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            0.4797s         0.0347s
Trifle::Stats::Driver::Postgres         0.3153s         0.0355s
Trifle::Stats::Driver::Mongo            0.2127s         0.1055s
Trifle::Stats::Driver::Process          0.029s          0.0106s
Trifle::Stats::Driver::Sqlite           0.4594s         0.02s
root@3b5545595714:~/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":{"d":3,"e":{"f":4,"g":5}}}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>{"d"=>3, "e"=>{"f"=>4, "g"=>5}}} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            4.192s          0.3268s
Trifle::Stats::Driver::Postgres         3.062s          0.3358s
Trifle::Stats::Driver::Mongo            2.0755s         1.0516s
Trifle::Stats::Driver::Process          0.2852s         0.1064s
Trifle::Stats::Driver::Sqlite           4.3669s         0.193s
```

`Trifle::Stats` normalizes nested values to top level before storing them, so overall there is not much performance difference between these. `Mongo` is performing the best, while `Postgres` and `Sqlite` are doing bit worse on writes, but still rocking those reads.

### Some really _large_ tracking

Lets see what happens when we increase the number of keys to 23.

```sh
root@3b5545595714:~/trifle-stats/spec/performance# ./run 100 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1}'
Testing 100x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            1.9144s         0.0637s
Trifle::Stats::Driver::Postgres         0.6995s         0.0428s
Trifle::Stats::Driver::Mongo            0.2399s         0.1069s
Trifle::Stats::Driver::Process          0.0886s         0.017s
Trifle::Stats::Driver::Sqlite           0.6593s         0.0225s
root@3b5545595714:~/trifle-stats/spec/performance# ./run 1000 '{"a":1,"b":2,"c":1,"d":2,"e":1,"f":2,"g":1,"h":2,"i":1,"j":2,"k":1,"l":2,"m":1,"n":2,"o":1,"p":2,"q":1,"r":2,"s":1,"t":2,"u":1,"v":2,"w":1}'
Testing 1000x {"a"=>1, "b"=>2, "c"=>1, "d"=>2, "e"=>1, "f"=>2, "g"=>1, "h"=>2, "i"=>1, "j"=>2, "k"=>1, "l"=>2, "m"=>1, "n"=>2, "o"=>1, "p"=>2, "q"=>1, "r"=>2, "s"=>1, "t"=>2, "u"=>1, "v"=>2, "w"=>1} increments
DRIVER                                  WRITE           READ
Trifle::Stats::Driver::Redis            17.8836s        0.5667s
Trifle::Stats::Driver::Postgres         6.8143s         0.4292s
Trifle::Stats::Driver::Mongo            2.3764s         1.0874s
Trifle::Stats::Driver::Process          0.863s          0.1703s
Trifle::Stats::Driver::Sqlite           6.3205s         0.2097s
```

Here you can really see how `Redis` crumbles under the volume and `Mongo` shines instead. It doesn't matter if you track 1, 5, or 100 values, `Mongo` will perform (almost) the same. `Postgres` and `Sqlite` slow down a bit more in comparison to `Mongo`.