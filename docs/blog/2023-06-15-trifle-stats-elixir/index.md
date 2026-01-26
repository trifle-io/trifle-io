---
title: 'Trifle.Stats for Elixir'
description: 'Why the Elixir port exists, what is implemented, and what is still missing.'
date: '2023-06-23 22:11:43'
author: 'Jozef Vaclavik'
template: blog
---

# `Trifle.Stats` for Elixir

Over last couple weeks I needed to build a stats for Elxiir/Phoenix project I've been working on. I've decided to port `Trifle::Stats` ruby version and release an elixir version of it.

Switching from object oriented programming to functional programming always takes me by surprise. `Trifle::Stats` codebase is fairly simple and preserving the core functionality has been pretty straightforward. In some cases the code actually looks cleaner and easier to follow through.

This is my 2nd time building Elixir package. I'm still a novice and learning my way through it. There is so much I don't know how to do, but I'm slowly getting there.

I've managed to port Nocturnal, Packer, Operations for track, assert and values and Mongo driver over the weekend. From there I had to work my way integrating it into a Phoenix app I've been working on and finetune couple more details.

I'm still not sure how to do phoenix configuration; there are still missing drivers and Assort functionality (including Designators). I also have no idea how to make depending drivers optional (ie redis not being required by default) and that will be next what I'll be working on. Afterwards missing Assort with Designators.

It's a journey and `Trifle.Stats` still has a way to go. I'm quite excited for the elixir version.
