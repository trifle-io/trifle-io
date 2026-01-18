---
title: Deployment
description: Learn how you can deploy Trifle App on your own.
nav_order: 2
---

# Deployment

Trifle App ships as a public Docker image, so you can run it anywhere that speaks containers. The supported path is Kubernetes via the built-in Helm chart.

## What you’re deploying

- A single application container (Phoenix app) plus its dependencies (Postgres).
- The Helm chart can run Postgres for you or connect to an external database.
- The chart runs migrations and bootstraps the initial admin user.

:::callout note "Short version"
- Helm is the paved road. Docker is the dirt path that still gets you there.
:::

## Recommended path: Helm

The Helm chart lives in the Trifle repo and is the fastest way to get a stable install:

- **Chart location**: `.devops/kubernetes/helm/trifle`
- **Values**: start from `values.yaml` and override what you need
- **Typical flow**: install → set `initialUser` → configure ingress → go live

From there, follow the dedicated docs:

- [Installation](/trifle-app/installation)
- [Configuration](/trifle-app/configuration)

## Docker deployment (available, undocumented)

You can run the same image with plain Docker or Docker Compose. It works. We just don’t have a blessed guide yet.

If you go this route, you still need to:

- Provide the same env vars as the Helm chart (see Configuration).
- Run database migrations on boot.
- Set `PHX_HOST`, `SECRET_KEY_BASE`, and your DB URL.
