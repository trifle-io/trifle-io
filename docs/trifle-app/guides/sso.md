---
title: Configure Google SSO
description: Enable Google Workspace SSO.
nav_order: 3
---

# Configure Google SSO

Trifle App supports Google OAuth for organization SSO.

## 1) Create OAuth credentials

- Create an OAuth 2.0 **Web application** in Google Cloud Console.
- Add this redirect URI:

```
https://app.trifle.io/auth/google/callback
```

## 2) Set environment variables

```yaml
app:
  googleOAuth:
    clientId: "<GOOGLE_OAUTH_CLIENT_ID>"
    clientSecret: "<GOOGLE_OAUTH_CLIENT_SECRET>"
    redirectUri: "https://app.trifle.io/auth/google/callback"
```

If `redirectUri` is not set, Trifle builds it from `PHX_HOST` and `PORT`.

## 3) Enable SSO in the UI

- Go to **Organization → SSO**.
- Add allowed domains (e.g. `example.com`).
- Toggle **Enable**.

Only organization admins can manage SSO settings.

:::callout note "Auto-provisioning"
- Users from allowed domains can auto-join when SSO is enabled.
- Existing members can still sign in even if their domain is not listed.
:::
