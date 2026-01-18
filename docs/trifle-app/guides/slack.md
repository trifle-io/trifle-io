---
title: Configure Slack
description: Connect Slack for delivery channels.
nav_order: 1
---

# Configure Slack

Slack integration is used for delivery channels and monitor notifications.

## 1) Create a Slack app

- Go to Slack API and create a new app.
- Add OAuth redirect URL:

```
https://app.trifle.io/integrations/slack/oauth/callback
```

## 2) Set environment variables

In your Helm values:

```yaml
app:
  slack:
    clientId: "<SLACK_CLIENT_ID>"
    clientSecret: "<SLACK_CLIENT_SECRET>"
    signingSecret: "<SLACK_SIGNING_SECRET>"
    redirectUri: "https://app.trifle.io/integrations/slack/oauth/callback"
    scopes: "chat:write,chat:write.public,channels:read,groups:read,incoming-webhook"
```

If `scopes` is omitted, Trifle uses the default set above.

## 3) Connect the workspace

- Go to **Organization → Delivery**.
- Click **Connect Slack**.
- Authorize the app.

Trifle syncs channels after install. If channel sync fails, reconnect and try again.

:::callout warn "Slack config must be complete"
- Missing client id/secret/signing secret will block authorization.
:::
