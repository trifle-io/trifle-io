---
title: Installation
description: Deploy Trifle App on Kubernetes using Helm.
nav_order: 1
---

# Installation

Trifle App ships with a Helm chart inside the main Trifle repo at `.devops/kubernetes/helm/trifle`.

## Prereqs

- Kubernetes cluster
- Helm 3
- Access to the Trifle image repository (`image.repository`)

## Quick install (single cluster)

1. Generate a secret key base.

```sh
mix phx.gen.secret
```

2. Create a values file.

:::tabs
@tab Minimal (internal Postgres)
```yaml
app:
  secretKeyBase: "<your-64-char-secret>"
  host: "trifle.example.com"
  registration:
    enabled: false

initialUser:
  enabled: true
  email: "admin@trifle.example.com"
  password: "change-me"
  admin: true

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: trifle.example.com
      paths:
        - path: /
          pathType: Prefix
```

@tab External Postgres + ingress
```yaml
app:
  secretKeyBase: "<your-64-char-secret>"
  host: "trifle.example.com"

postgresql:
  enabled: false

externalPostgresql:
  host: "postgres.example.com"
  port: 5432
  username: "trifle"
  password: "secure-password"
  database: "trifle_prod"

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: trifle.example.com
      paths:
        - path: /
          pathType: Prefix
```
:::

3. Install the chart.

```sh
helm upgrade --install trifle .devops/kubernetes/helm/trifle \
  -n trifle --create-namespace -f values.yaml
```

Expected outcome: the deployment is healthy and the admin user is created.

:::callout note "Projects are disabled by default"
- Self-hosted deployments default to database-only sources.
- Enable projects if you want API ingestion (see below).
:::

## What Helm does for you

- Runs database migrations after install/upgrade.
- Creates the initial user (if `initialUser.enabled: true`).

:::callout warn "Don't ship defaults"
- `app.secretKeyBase` and `initialUser.password` are not optional in real life.
- If you forget to change them, you deserve whatever happens next.
:::

## External Postgres (recommended)

If you already have Postgres, disable the internal one and use the example file as a base:

```sh
helm upgrade --install trifle .devops/kubernetes/helm/trifle \
  -n trifle --create-namespace -f .devops/kubernetes/helm/trifle/values-external-db.yaml
```

Update the `externalPostgresql.*` block and re-apply.

## Enable project sources (API ingestion)

Project sources require MongoDB. You can use the built-in sidecar or point to an external Mongo.

:::tabs
@tab Sidecar Mongo (default)
```yaml
features:
  projects:
    enabled: true

# leave app.mongodbUrl empty to use mongodb://localhost:27017/trifle
mongo:
  sidecar:
    enabled: true
```

@tab External Mongo
```yaml
features:
  projects:
    enabled: true

app:
  mongodbUrl: "mongodb://mongo.example.com:27017/trifle"

mongo:
  sidecar:
    enabled: false
```
:::

## Production values

There is a `values-production.yaml` you can use as a starting point. It enables ingress, autoscaling, and stronger resource limits.

```sh
helm upgrade --install trifle .devops/kubernetes/helm/trifle \
  -n trifle --create-namespace -f .devops/kubernetes/helm/trifle/values-production.yaml
```
