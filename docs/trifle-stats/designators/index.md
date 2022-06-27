---
title: Designators
nav_order: 5
---

# Designators

Designators are classes used to create buckets for histograms. You can either use one of the existing Designators or define your own Designator class and use it in Configuration. Every Designator needs to implement one method:

- `designate(value:)` returns bucket for a value.

Thats it. This returned bucket will be used in `assort` method to categorize values. In other words histogram. It is OK to use decimal points in bucket.
