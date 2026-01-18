---
title: Installation (Helm)
description: Deploy Trifle App on Kubernetes using Helm.
nav_order: 1
---

# Installation (Helm)

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

```yaml
app:
  secretKeyBase: "<your-64-char-secret>"
  host: "app.trifle.io"
  registration:
    enabled: false

initialUser:
  enabled: true
  email: "admin@app.trifle.io"
  password: "change-me"
  admin: true

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: app.trifle.io
      paths:
        - path: /
          pathType: Prefix
```

3. Install the chart.

```sh
helm upgrade --install trifle .devops/kubernetes/helm/trifle \
  -n trifle --create-namespace -f values.yaml
```

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

## Production values

There is a `values-production.yaml` you can use as a starting point. It enables ingress, autoscaling, and stronger resource limits.

```sh
helm upgrade --install trifle .devops/kubernetes/helm/trifle \
  -n trifle --create-namespace -f .devops/kubernetes/helm/trifle/values-production.yaml
```
