---
title: Getting Started
description: Learn how to start using Trifle::Logs.
nav_order: 3
---

# Getting Started

Start by adding `Trifle::Logs` into your `Gemfile` as `gem 'trifle-logs'` and then run `bundle install`.

Once you're done with that, create a global configuration. If you are doing this as a part of a Rails App, add an initializer `config/initializers/trifle.rb`; otherwise place the configuration __somewhere_ in your ruby code that gets called once your app gets launched.

```ruby
Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Drivers::File.new(path: '/var/logs/trifle', suffix: '%Y/%m/%d', read_lines: 10)
  config.timestamp_formatter = Trifle::Logs::Formatters::Timestamp.new
  config.content_formatter = Trifle::Logs::Formatters::Content::Text.new
end
```

This configuration creates a driver that will upload logs into `/var/logs/trifle` with appropriate namespace and create a log for each day nested under month and year. While searching logs, it will perform search per every 10 lines. We're gonna use default Timestamp formatter and simple Text log output.

I'm gonna go ahead and point out the obvious that you should not search only 10 lines at a time. The right number will depend on your usecase. Keep on mind that by default (aka without search pattern), `Trifle::Logs` returns all lines from the page. Returning 1000 short lines is gonna take much faster then returning 1000 very long lines. `Trifle::Logs::Drivers::File` defaults to 1000 lines.

## Storing content

Throught your codebase, you need to call `Trifle::Logs.dump` wherever you want to persist some content in the logs. You can try it from console.

Your content is your content and for the sake of example I'm gonna use `Faker` to generate some cool text couple times and then we will store it in `business` namespace.

```ruby
require 'faker'

100.times do
  Trifle::Logs.dump('business', "Using #{Faker::Company.bs} for #{Faker::Company.catch_phrase}")
end
```

Now if you will go ahead and inspect file located in `/var/logs/trifle/business/2022/09/19.log` you should see 100 lines that looks like the sample below. This sample prints last 10 lines of the file. The actual path to the file will depend on your current date. For me it is 19th September 2022.

```text
2022-09-19T16:47:36.678765  Using reinvent 24/365 methodologies for Decentralized context-sensitive help-desk
2022-09-19T16:47:36.678856  Using syndicate open-source applications for Profound hybrid attitude
2022-09-19T16:47:36.678900  Using reinvent vertical vortals for Reactive exuding instruction set
2022-09-19T16:47:36.678946  Using enhance sexy supply-chains for Up-sized bandwidth-monitored leverage
2022-09-19T16:47:36.678990  Using engineer innovative technologies for Reduced national flexibility
2022-09-19T16:47:36.679036  Using embrace transparent partnerships for Business-focused coherent implementation
2022-09-19T16:47:36.679083  Using orchestrate distributed models for Sharable background challenge
2022-09-19T16:47:36.679130  Using target cutting-edge bandwidth for Right-sized client-driven moratorium
2022-09-19T16:47:36.679175  Using benchmark bleeding-edge architectures for Implemented homogeneous access
2022-09-19T16:47:36.679219  Using architect granular relationships for Reverse-engineered scalable process improvement
2022-09-19T16:47:36.679264  Using generate real-time schemas for User-centric scalable application
```

## Searching for content

Now that you have data, it's time to search for some. Let's create an searcher object and call `perform` on it.

```ruby
irb(main):008:0> op = Trifle::Logs.searcher('business', pattern: nil)
=> #<Trifle::Logs::Operations::Searcher:0x00000001047f3208 @config=nil, @max_loc=nil, @min_loc=nil, @namespace="business", @pattern=nil>
irb(main):009:0> op.perform
=>
#<Trifle::Logs::Result:0x00000001047b3b08
 @lines=
  [{"type"=>"begin", "data"=>{"path"=>{"text"=>"<stdin>"}}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.678765  Using reinvent 24/365 methodologies for Decentralized context-sensitive help-desk\n"},
      "line_number"=>1,
      "absolute_offset"=>0,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.678765  Using reinvent 24/365 methodologies for Decentralized context-sensitive help-desk"}, "start"=>0, "end"=>109}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.678856  Using syndicate open-source applications for Profound hybrid attitude\n"},
      "line_number"=>2,
      "absolute_offset"=>110,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.678856  Using syndicate open-source applications for Profound hybrid attitude"}, "start"=>0, "end"=>97}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.678900  Using reinvent vertical vortals for Reactive exuding instruction set\n"},
      "line_number"=>3,
      "absolute_offset"=>208,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.678900  Using reinvent vertical vortals for Reactive exuding instruction set"}, "start"=>0, "end"=>96}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.678946  Using enhance sexy supply-chains for Up-sized bandwidth-monitored leverage\n"},
      "line_number"=>4,
      "absolute_offset"=>305,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.678946  Using enhance sexy supply-chains for Up-sized bandwidth-monitored leverage"}, "start"=>0, "end"=>102}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.678990  Using engineer innovative technologies for Reduced national flexibility\n"},
      "line_number"=>5,
      "absolute_offset"=>408,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.678990  Using engineer innovative technologies for Reduced national flexibility"}, "start"=>0, "end"=>99}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679036  Using embrace transparent partnerships for Business-focused coherent implementation\n"},
      "line_number"=>6,
      "absolute_offset"=>508,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.679036  Using embrace transparent partnerships for Business-focused coherent implementation"}, "start"=>0, "end"=>111}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679083  Using orchestrate distributed models for Sharable background challenge\n"},
      "line_number"=>7,
      "absolute_offset"=>620,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.679083  Using orchestrate distributed models for Sharable background challenge"}, "start"=>0, "end"=>98}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679130  Using target cutting-edge bandwidth for Right-sized client-driven moratorium\n"},
      "line_number"=>8,
      "absolute_offset"=>719,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.679130  Using target cutting-edge bandwidth for Right-sized client-driven moratorium"}, "start"=>0, "end"=>104}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679175  Using benchmark bleeding-edge architectures for Implemented homogeneous access\n"},
      "line_number"=>9,
      "absolute_offset"=>824,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.679175  Using benchmark bleeding-edge architectures for Implemented homogeneous access"}, "start"=>0, "end"=>106}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679219  Using architect granular relationships for Reverse-engineered scalable process improvement\n"},
      "line_number"=>10,
      "absolute_offset"=>931,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.679219  Using architect granular relationships for Reverse-engineered scalable process improvement"}, "start"=>0, "end"=>118}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679264  Using generate real-time schemas for User-centric scalable application\n"},
      "line_number"=>11,
      "absolute_offset"=>1050,
      "submatches"=>[{"match"=>{"text"=>"2022-09-19T16:47:36.679264  Using generate real-time schemas for User-centric scalable application"}, "start"=>0, "end"=>98}]}},
   {"type"=>"end",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "binary_offset"=>nil,
      "stats"=>{"elapsed"=>{"secs"=>0, "nanos"=>49041, "human"=>"0.000049s"}, "searches"=>1, "searches_with_match"=>1, "bytes_searched"=>1149, "bytes_printed"=>4183, "matched_lines"=>11, "matches"=>11}}},
   {"data"=>
     {"elapsed_total"=>{"human"=>"0.001005s", "nanos"=>1005083, "secs"=>0},
      "stats"=>{"bytes_printed"=>4183, "bytes_searched"=>1149, "elapsed"=>{"human"=>"0.000049s", "nanos"=>49041, "secs"=>0}, "matched_lines"=>11, "matches"=>11, "searches"=>1, "searches_with_match"=>1}},
    "type"=>"summary"}],
 @max_loc="/var/logs/trifle/business/2022/09/19.log#100",
 @min_loc="/var/logs/trifle/business/2022/09/19.log#90">
 ```

Now you can see that these are same last 10 (`read_size`) of the log as listed above. This time lets actually provide some search pattern. You're gonna get different results as your auto-generated output is gonna be unique.

```ruby
irb(main):025:0> op = Trifle::Logs.searcher('business', pattern: 'ship')
=> #<Trifle::Logs::Operations::Searcher:0x000000010464d4a8 @config=nil, @max_loc=nil, @min_loc=nil, @namespace="business", @pattern="ship">
irb(main):026:0> op.perform
=>
#<Trifle::Logs::Result:0x00000001047e22c8
 @lines=
  [{"type"=>"begin", "data"=>{"path"=>{"text"=>"<stdin>"}}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679036  Using embrace transparent partnerships for Business-focused coherent implementation\n"},
      "line_number"=>6,
      "absolute_offset"=>508,
      "submatches"=>[{"match"=>{"text"=>"ship"}, "start"=>61, "end"=>65}]}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.679219  Using architect granular relationships for Reverse-engineered scalable process improvement\n"},
      "line_number"=>10,
      "absolute_offset"=>931,
      "submatches"=>[{"match"=>{"text"=>"ship"}, "start"=>61, "end"=>65}]}},
   {"type"=>"end",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "binary_offset"=>nil,
      "stats"=>{"elapsed"=>{"secs"=>0, "nanos"=>101208, "human"=>"0.000101s"}, "searches"=>1, "searches_with_match"=>1, "bytes_searched"=>1149, "bytes_printed"=>628, "matched_lines"=>2, "matches"=>2}}},
   {"data"=>
     {"elapsed_total"=>{"human"=>"0.002051s", "nanos"=>2051125, "secs"=>0},
      "stats"=>{"bytes_printed"=>628, "bytes_searched"=>1149, "elapsed"=>{"human"=>"0.000101s", "nanos"=>101208, "secs"=>0}, "matched_lines"=>2, "matches"=>2, "searches"=>1, "searches_with_match"=>1}},
    "type"=>"summary"}],
 @max_loc="/var/logs/trifle/business/2022/09/19.log#100",
 @min_loc="/var/logs/trifle/business/2022/09/19.log#90">
```

Now you can see that searching for `'ship'` returns two matching results. This is only because on my last 10 lines of log I have words `relationships` and `partnerships`. If you end up with empty result, go ahead and load previous page.

```ruby
irb(main):027:0> op.prev
=>
#<Trifle::Logs::Result:0x000000010475ac10
 @lines=
  [{"type"=>"begin", "data"=>{"path"=>{"text"=>"<stdin>"}}},
   {"type"=>"match",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "lines"=>{"text"=>"2022-09-19T16:47:36.678408  Using integrate end-to-end partnerships for Optimized zero defect database\n"},
      "line_number"=>3,
      "absolute_offset"=>218,
      "submatches"=>[{"match"=>{"text"=>"ship"}, "start"=>62, "end"=>66}]}},
   {"type"=>"end",
    "data"=>
     {"path"=>{"text"=>"<stdin>"},
      "binary_offset"=>nil,
      "stats"=>{"elapsed"=>{"secs"=>0, "nanos"=>126083, "human"=>"0.000126s"}, "searches"=>1, "searches_with_match"=>1, "bytes_searched"=>1159, "bytes_printed"=>327, "matched_lines"=>1, "matches"=>1}}},
   {"data"=>
     {"elapsed_total"=>{"human"=>"0.002396s", "nanos"=>2396125, "secs"=>0},
      "stats"=>{"bytes_printed"=>327, "bytes_searched"=>1159, "elapsed"=>{"human"=>"0.000126s", "nanos"=>126083, "secs"=>0}, "matched_lines"=>1, "matches"=>1, "searches"=>1, "searches_with_match"=>1}},
    "type"=>"summary"}],
 @max_loc=nil,
 @min_loc="/var/logs/trifle/business/2022/09/19.log#80">
```

One more extra result. Yay! You can use `op.prev` to load and filter previous page and `op.next` to load and filter next page. As you started filtering at the end of latest file, there now may be new content that has been added to the log. Using `op.next` will iterate through newer content.

You can also store result of `op.perform`, `op.prev` and `op.next` into a variable. These methods return a `Result` object that holds data of a current page. You can then use `result.data` to retrieve only lines with matching content while `reuslt.meta` holds the remaining lines. This will come handy when rendering logs and matches in the UI.

Now you may have noticed that to paginate you need to call `prev` and `next` on an instance of current searcher. If you're building this as a part of Rails app, you know that instances do not live beyond response. For this reason you need to preserve `min_loc` and `max_loc` from searcher and pass them into new instance of searcher. This way you will preserve min and max index of a loaded content.

Now go ahead and search with some regexp. Try it, its fun!
