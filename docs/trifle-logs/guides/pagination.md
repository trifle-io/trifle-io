---
title: Paginate Results
description: Move backward and forward through log pages.
nav_order: 2
---

# Paginate Results

`Trifle::Logs::Operations::Searcher` keeps paging state for you.

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged')
page1 = searcher.perform
page2 = searcher.next
page0 = searcher.prev
```

If you need manual paging (e.g. for stateless APIs), pass `min_loc` or `max_loc` when you construct the searcher:

```ruby
searcher = Trifle::Logs.searcher('billing', pattern: 'Charged', max_loc: '/var/logs/trifle/billing/2026/01/26.log#200')
next_page = searcher.next
```
