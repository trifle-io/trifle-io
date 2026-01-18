---
title: Getting Started
description: From zero to metrics in one pass.
nav_order: 3
---

# Getting Started

This is the shortest path from "no app" to "I can see a chart".

## 0. Install the app

Use the Helm chart in the Trifle repo and apply a minimal values file. (See [Installation](/trifle-app/installation)).

Expected outcome: Trifle App is running and reachable.

## 1. Sign up or Log in

- Navigate to [app.trifle.io](https://app.trifle.io).
- Sign up with your email address.

### Self-hosted Trifle App

If you're using self-hosted version of Trifle App:

- Navigate to your Trifle URL.
- Sign in with the `initialUser` credentials.
- Change the password. Future you will thank you.

Expected outcome: you can access the UI with an admin account.

## 2. Create a source + token

There are two source types, but only one can ingest via the API:

- **Project source** (user-level): supports read/write tokens. This is the only source that can ingest data via `/api/v1/metrics`.
- **Database source** (organization-level): read-only tokens, best for shared dashboards.

If you want **Database source** metrics, you must integrate **Trifle::Stats** (Ruby), **Trifle.Stats** (Elixir), or any other Trifle Stats plugin into your app and let it write metrics into your database directly. The Trifle App reads from that database; it does not accept writes for database tokens.

Go to **Projects** (for API ingestion) or **Databases** (for read-only dashboards) and create a token. Copy it.

Expected outcome: you have a token and know whether it can write.

## 3. Send your first metric (Project tokens only)

```sh
curl -X POST "https://app.trifle.io/api/v1/metrics" \
  -H "Authorization: Bearer <PROJECT_WRITE_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "event::signup",
    "at": "2026-01-17T12:00:00Z",
    "values": { "count": 1, "duration": 0.42 }
  }'
```

If this returns `201`, you're in.

Expected outcome: a `201` response and `{"data":{"created":"ok"}}`.

## 4. Explore page

Visit [Explore page](https://app.trifle.io/explore) to see raw metrics as they are being aggregated over time. It is the easiest way to validate that data is there before you dive into building a dashboard.

### Query the data

You can also hit the API endpoint to get the data programatically.

```sh
curl "https://app.trifle.io/api/v1/metrics?key=event::signup&from=2026-01-17T00:00:00Z&to=2026-01-18T00:00:00Z&granularity=1h" \
  -H "Authorization: Bearer <READ_TOKEN>"
```

Expected outcome: a JSON payload with `data.at` timestamps and `data.values`.

## 5. Build a dashboard

Create a [dashboard](https://app.trifle.io/dashboards) via the UI, or via the API (see `/api/v1/dashboards`). Point widgets at your metric keys and paths.

Expected outcome: a dashboard with at least one widget rendering data.

:::callout note "Quick sanity check"
- `GET /api/v1/source` tells you what the token can see.
:::
