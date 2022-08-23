---
title: 'Running performance test for Trifle::Stats on your own'
date: '2022-08-23 12:32:51'
author: 'Jozef Vaclavik'
template: blog
---

# Base performance

It's easy to get excited when seeing performance comparison provided by someone. Numbers looks exiting, solid, valid, and what not. But what does it mean? How does it apply to your usecase?

`Trifle::Stats` includes section about drivers [performance](../trifle-stats/drivers/performance). It includes build in script for running test through multiple drivers and priting summary of that. This test has two short-comings:

1. Data is _static_ and doesnt change between writes.
2. Data gets updated for single timestamp and reading it always return one record no matter the desired range.

This simply means that this is simulated and not real-life scenario. There is nothing wrong with that as long as you are aware of it and accept the limitations. Both of these can be addressed in future iteration, but for now it is what it is.

# Run it on your own

Trusting numbers someone presents to you requires some level of trust. Right now, you may have none. It's allright, no hard feelings. Best I can do is to give you a chance to run these tests on your own and let you decide if its worth it.

You can run these performance tests in one of two ways:

1. Use your own databases and you get more accurate results for your environment.
2. Use dockerized databases and you get somewhat accurate results for your environment.

While the first option requires more configuration, the second option works out of the box. You don't need to run tests against dockerized databases, but in that case you need to configure appropriate credentials in `specs/performance/drivers.rb` as they default to dockerized environment. You dont even need to run tests against all databases either. If you care only about postgres and redis, leave those two enabled.

## Environment setup

Lets start with setting up local environment. Official performance comparison was ran on AWS EC2 `t2.medium` instance, but today I'm gonna run this on MacStudio with M1 Max.

We're gonna need a `Dockerfile` which will create a local environment where we will run the tests and `docker-compose.yml` where we link it to multiple databases.

### Dockerfile

You can use any image of your own, or use my pre-defined image. Any ruby 3+ will do. Make sure your image has all dependencies installed so you can easily install `pg` and `sqlite` gems. If you want to avoid hustle, simply use my environment image.

```dockerfile
FROM trifle/environment:latest
```

This image comes with all the driver dependencies and ruby 3.0 installed.

### Docker-compose

Now lets set up docker-compose.yml file and link databases to our environment Dockerimage.

```yaml
version: "3.7"
services:
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: password
  redis:
    image: redis:latest
  mongo:
    image: mongo:latest
  app:
    command: /bin/sh -c "while sleep 1000; do :; done"
    build:
      dockerfile: Dockerfile
    depends_on:
      - postgres
      - redis
      - mongo
    environment:
      PGHOST: postgres
      PGUSER: postgres
      REDIS_HOST: redis
      REDIS_URL: redis://redis:6379
```

As you can see, there isnt much to it. Just a little `command` hack to keep container running for a while once it starts.

### Launch it up!

Once you have both `Dockerfile` and `docker-compose.yml` ready, its time to spin up the containers and connect to it.

```sh
docker compose up
```

And then in another shell execute `bash` or `zsh` to existing app container.

```sh
docker compose exec app zsh
```

And now you're in.

### Clone Trifle::Stats repository

One more thing before we dive deep into testing. You've got to clone the repository once you are inside of the container.

```sh
cd ~
git clone https://github.com/trifle-io/trifle-stats.git
```

Now get inside of the performance folder and install dependencies.

```sh
cd trifle-stats/spec/performance
bundle install
```

And now you're all set up.

## Configuration

Alrite, but before we really dive in, lets talk a bit about configuration details.

If you inspect `driver.rb` file, you will notice two important parts. Lots of `*_config` methods that prepare database and returns `Trifle::Stats::Configuration` instances. And `configurations` method that provides list of configurations for testing.

If you need to modify connection details or credentials for a specific driver, edit appropriate `*_config` method with your details. Existing values are set for above docker compose configuration.

If you don't care about testing _some_ drivers, simply remove them from the array that `configurations` method returns.

## Testing

Now its time to run some tests! There is a `run` ruby script that iterates through above mentioned `configurations` and writes and reads specified number of times JSON that you pass in. It uses ruby `benchmark` to wrap around reads and writes to count the realtime usage. Here is it's current implementation.

```ruby
#!/usr/bin/env ruby

require 'bundler/setup'
require 'trifle/stats'
require 'json'
require_relative 'drivers'
require 'benchmark'

count = ARGV[0].to_i
data = JSON.parse(ARGV[1])

puts "Testing #{count}x #{data} increments"
results = Performance::Drivers.new.configurations.map do |config|
  now = Time.now
  write = Benchmark.realtime do
    count.times do
      Trifle::Stats.track(key: 'perf_simple', values: data, at: now, config: config)
    end
  end

  read = Benchmark.realtime do
    count.times do
      Trifle::Stats.values(key: 'perf_simple', from: now, to: now, range: :hour, config: config)
    end
  end

  {name: config.driver.class.to_s, write: write.round(4), read: read.round(4)}
end

puts "DRIVER\t\t\t\t\tWRITE\t\tREAD"
results.each do |result|
  puts "#{result[:name]}\t\t#{result[:write]}s\t\t#{result[:read]}s"
end
```

As you can see, this is very _simple_ single-threaded testing.

### 100x for a single value

Lets go and `./run 100 '{"a":1}'` to see whats gonna happen. Once I run it multiple times, all runs show quite similar output.

```sh
Testing 100x {"a"=>1} increments
DRIVER									WRITE			READ
Trifle::Stats::Driver::Redis			0.0776s			0.0121s
Trifle::Stats::Driver::Postgres			0.0677s			0.0094s
Trifle::Stats::Driver::Mongo			0.0632s			0.04s
Trifle::Stats::Driver::Process			0.0038s			0.0027s
Trifle::Stats::Driver::Sqlite			0.1003s			0.005s
```

This looks somewhat different then when official stats. I'm gonna paste them below for the comparison.

```sh
DRIVER									WRITE			READ
Trifle::Stats::Driver::Redis			0.1234s			0.0268s
Trifle::Stats::Driver::Postgres			0.2557s			0.0325s
Trifle::Stats::Driver::Mongo			0.1964s			0.11s
Trifle::Stats::Driver::Process			0.0134s			0.0097s
Trifle::Stats::Driver::Sqlite			0.4358s			0.0215s
```

From here, you're free to run whatever payloads fits your usecase and as many times as you desire. I would suggest to run each test multiple times and average the final numbers to get _most appropriate_ result.

## Conclusion

You can see that docker on M1 (even that its running through virtualization) flies next to same test on EC2 instance. Almost each driver performs at least 2x better, while `postgres` blows almost 4x improvement.

To some extent, comparing docker on M1 and EC2 is like comparing apples to oranges. I know it's not the same. I simply hope that you get the point of running the test in your own conditions. That way you will get _more_ accurate results. So make sure to run these on configuration that _somewhat_ matches your desired environment. Please don't run these in `production` environment unless you know exactly what you're doing.