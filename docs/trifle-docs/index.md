---
title: 'Trifle::Docs'
nav_order: 1
svg: M16.5 3.75V16.5L12 14.25 7.5 16.5V3.75m9 0H18A2.25 2.25 0 0120.25 6v12A2.25 2.25 0 0118 20.25H6A2.25 2.25 0 013.75 18V6A2.25 2.25 0 016 3.75h1.5m9 0h-9
---

# Trifle::Docs

[![Gem Version](https://badge.fury.io/rb/trifle-docs.svg)](https://rubygems.org/gems/trifle-docs)
[![Ruby](https://github.com/trifle-io/trifle-docs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-docs)

Simple router for your static documentation. Like markdown, or textile, or whatever files. [^1]

`Trifle::Docs` is a _way too_ simple _router_. It maps your folder full of static files into your URLs and allows you to integrate them with same layout as the rest of your app. It supports rendering markdown, textile and serves other static files directly. You can easily extend it to process your own format with a Harvester. Oh yeah.

## Why?

Static Site Generators are awesome at what they do. I know, I've used them for a long time. Unfortunately they are _a bit_ cumberstone when customisation is necessary. On the other end of a spectrum are Content Management Systems. They are great at managing content. Unfortunately they are _a bit_ overkill when all your content is static (and somewhat technical).

`Trifle::Docs` lies somewhere in between these two, but slightly on the static side of spectrum. It is a _way too_ simple tool for developers who want to integrate documentation or blog into their Ruby/Rails website without storing content in database or learning custom templating language/structure. This allows them to make UI/UX of their website seamless.

> Oh, and did you know that this documentation is build on top of `Trifle::Docs`? Yup, you can check it out, this source code is [public](https://github.com/trifle-io/trifle-io).

[^1]: TBH only markdown harvester for now 💔.
