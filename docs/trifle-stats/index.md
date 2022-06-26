---
title: Trifle::Stats
nav_order: 1
---

# Trifle::Stats

[![Gem Version](https://badge.fury.io/rb/trifle-stats.svg)](https://rubygems.org/gems/trifle-stats)
[![Ruby](https://github.com/trifle-io/trifle-stats/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-stats)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-stats)

Simple analytics backed by Redis, Postgres, MongoDB, Process, Google Analytics, Segment, or whatever. [^1]

`Trifle::Stats` is a _way too_ simple timeline analytics that helps you track custom metrics. Automatically increments counters for each enabled range. It supports timezones and different week beginning.

[^1]: TBH only database drivers for now 💔.
