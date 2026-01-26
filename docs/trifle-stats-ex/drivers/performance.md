---
title: Performance
description: Learn more about performance of each driver.
nav_order: 1
---

# Performance

Driver performance depends on your datastore, indexing strategy, and the number of granularities you track.

General guidance:

- **Mongo / Postgres**: good for large datasets and dashboards.
- **Redis**: fast increments, but watch memory usage.
- **SQLite**: convenient for local/dev, not ideal for high write volume.
- **Process**: in-memory only (fast, non-persistent).

> TODO: Update example
