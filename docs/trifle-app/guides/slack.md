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

:::tabs
@tab SaaS
```
https://app.trifle.io/integrations/slack/oauth/callback
```

@tab Self-hosted
```
https://<your-host>/integrations/slack/oauth/callback
```
:::

## 2) Set environment variables

In your Helm values:

```yaml
app:
  slack:
    clientId: "<SLACK_CLIENT_ID>"
    clientSecret: "<SLACK_CLIENT_SECRET>"
    signingSecret: "<SLACK_SIGNING_SECRET>"
    redirectUri: "https://<your-host>/integrations/slack/oauth/callback"
    scopes: "chat:write,chat:write.public,channels:read,groups:read,incoming-webhook"
```

If `scopes` is omitted, Trifle uses the default set above.

:::callout note "Self-hosted URLs"
- For self-hosted, make sure the redirect URI matches your `PHX_HOST` + HTTPS.
- For SaaS, use the `app.trifle.io` URL shown above.
:::

## 3) Connect the workspace

- Go to **Organization → Delivery**.
- Click **Connect Slack**.
- Authorize the app.

Trifle syncs channels after install. If channel sync fails, reconnect and try again.

:::callout warn "Slack config must be complete"
- Missing client id/secret/signing secret will block authorization.
:::

## Example: Slack delivery channel

Use this payload inside a monitor create/update request:

```json
{
  "delivery_channels": [
    {
      "channel": "slack_webhook",
      "label": "Ops",
      "target": "https://hooks.slack.com/services/..."
    }
  ]
}
```
