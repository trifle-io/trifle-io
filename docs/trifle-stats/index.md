---
title: Trifle::Stats
nav_order: 3
---

# Trifle::Stats

[![Gem Version](https://badge.fury.io/rb/trifle-stats.svg)](https://rubygems.org/gems/trifle-stats)
[![Ruby](https://github.com/trifle-io/trifle-stats/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-stats)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-stats)

Simple analytics backed by Redis, Postgres, MongoDB, Process, Google Analytics, Segment, or whatever. [^1]

`Trifle::Stats` is a _way too_ simple timeline analytics that helps you track custom metrics. Automatically increments counters for each enabled range. It supports timezones and different week beginning.

# Why?

There are many ways to do analytics. You can use 3rd party service (Segment, or whatever), external service (Prometheus, or whatever) or build it inhouse yourself. Use of 3rd party service introduces latency into your app. And while external service is faster, it often adds complexity into your app. You either need you to addapt to its ideology (aka their believes of analytics) or write lots of gluecode because they only offer simple client library. And while doing it yourself is often enough, without previous experience it sets you down the path of explorer. And thats like kitchen remodeling. It will take twice as long and cost twice as much.

`Trifle::Stats` helps with the in-house analytics. It gives you simple methods for storing and retrieving data and does enough (but not too much) magic on the background for you. This way you don't need to worry where or how your data is being stored or structured. All that matters is to track values that matters and fetch its timeline data. Plotting is all in your hands.

[^1]: TBH only database drivers for now 💔.
