---
title: Trifle::Logs
nav_order: 2
svg: M3.75 12h16.5m-16.5 3.75h16.5M3.75 19.5h16.5M5.625 4.5h12.75a1.875 1.875 0 010 3.75H5.625a1.875 1.875 0 010-3.75z
---

# Trifle::Logs

[![Gem Version](https://badge.fury.io/rb/trifle-logs.svg)](https://rubygems.org/gems/trifle-logs)
[![Ruby](https://github.com/trifle-io/trifle-logs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-logs)

Simple logger that stores your data and allows you to search on top of it.

`Trifle::Logs` is a _way too_ simple logger that helps you persist your logs. It is great for scenarios where you wanna simply dump bunch of output into a file and then search on top of it.

## Why?

Storing data into logs is nothing new. It is not always super straightforward how to search in your logs. In good ol'days you would simply grep through the logs and call it a day. This interface is missing and your only option is to offload logs to 3rd party services specilising 

`Trifle::Logs` helps you to read through your logs without them leaving your infrastructure. It allows you to tailor configuration to your specific usecase. Because sometimes it is still OK to use `puts` in 2022.
