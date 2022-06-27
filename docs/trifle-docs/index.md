---
title: 'Trifle::Docs'
nav_order: 1
---

# Trifle::Docs

[![Gem Version](https://badge.fury.io/rb/trifle-docs.svg)](https://rubygems.org/gems/trifle-docs)
[![Ruby](https://github.com/trifle-io/trifle-docs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-docs)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/trifle-io/trifle-docs)

Simple router for your static documentation. Like markdown, or textile, or whatever files. [^1]

`Trifle::Docs` is a _way too_ simple _router_. It maps your folder full of static files into your URLs and allows you to integrate them with same layout as the rest of your app. It supports rendering markdown, textile and serves other static files directly. You can easily extend it to process your own format with a Harvester. Oh yeah.

# Why?

Static Site Generators are awesome at what they do. I know, I've used them for a long time. Unfortunately they are _a bit_ cumberstone when customisation is necessary. On the other end of a spectrum are Content Management Systems. They are great at managing content. Unfortunately they are _a bit_ overkill when all your content is static (and somewhat technical).

`Trifle::Docs` fills the void between these two. It is a _way too_ simple tool for developers who want to integrate documentation or blog into their Ruby/Rails website without storing content in database or learning custom templating language/structure. It's for everyone who wants to make UX of your website seamless.

> Oh, and did you know that this documentation is build on top of `Trifle::Docs`? Yup, you can check it out, this source code is [public](https://github.com/trifle-io/trifle-io).

[^1]: TBH only markdown harvester for now 💔.